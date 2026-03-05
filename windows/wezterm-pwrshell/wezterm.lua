local wezterm = require 'wezterm'
local act = wezterm.action

local home = wezterm.home_dir or os.getenv 'USERPROFILE' or os.getenv 'HOME' or 'C:/Users/Public'
local pictures = (home:gsub('\\', '/')) .. '/Pictures/WezTerm'
local workspace_root = (home:gsub('\\', '/')) .. '/Documents/codex-workspace'

local wallpapers = {
  pictures .. '/cyberpunk-tech.jpg',
  pictures .. '/cyberpunk-neon-city.jpg',
  pictures .. '/tonystark-lab.jpg',
}

local workspace_background_cache = {}

local function workspace_wallpaper(workspace_name)
  if #wallpapers == 0 then
    return nil
  end
  local checksum = 0
  local name = workspace_name or 'default'
  for i = 1, #name do
    checksum = checksum + string.byte(name, i)
  end
  local idx = (checksum % #wallpapers) + 1
  return wallpapers[idx]
end

local function build_background(path)
  return {
    {
      source = { File = path },
      hsb = {
        hue = 1.0,
        saturation = 1.1,
        brightness = 0.11,
      },
      horizontal_align = 'Center',
      vertical_align = 'Middle',
    },
    {
      source = { Color = '#05070a' },
      width = '100%',
      height = '100%',
      opacity = 0.58,
    },
  }
end

local function apply_workspace_background(window)
  local workspace = window:active_workspace() or 'default'
  local chosen = workspace_wallpaper(workspace)
  if not chosen then
    return
  end

  local window_id = window:window_id()
  if workspace_background_cache[window_id] == chosen then
    return
  end

  workspace_background_cache[window_id] = chosen
  local overrides = window:get_config_overrides() or {}
  overrides.background = build_background(chosen)
  window:set_config_overrides(overrides)
end

wezterm.on('update-right-status', function(window, pane)
  apply_workspace_background(window)

  local timestamp = wezterm.strftime '%a %b %d  %H:%M'
  window:set_left_status ''
  window:set_right_status(wezterm.format({
    { Foreground = { Color = '#5ea1ff' } },
    { Text = timestamp .. '  ' },
  }))
end)

wezterm.on('format-tab-title', function(tab, _, _, _, _, max_width)
  local proc = tab.active_pane.foreground_process_name or tab.active_pane.title or 'shell'
  proc = proc:gsub('^.+[\\/]', '')
  local title = string.format(' %d:%s ', tab.tab_index + 1, proc)
  title = wezterm.truncate_right(title, max_width)

  if tab.is_active then
    return {
      { Background = { Color = '#0f1722' } },
      { Foreground = { Color = '#55f1ff' } },
      { Text = title },
    }
  end

  return {
    { Background = { Color = '#0a1018' } },
    { Foreground = { Color = '#6a7a8a' } },
    { Text = title },
  }
end)

local function move_current_pane_to_new_tab(_, pane)
  if pane and pane.move_to_new_tab then
    local ok = pcall(function()
      pane:move_to_new_tab()
    end)
    if ok then
      return
    end
  end
end

local function show_edit_menu(window, pane)
  window:perform_action(act.InputSelector {
    title = 'Clipboard',
    choices = {
      { id = 'copy', label = 'Copy' },
      { id = 'cut', label = 'Cut' },
      { id = 'paste', label = 'Paste' },
    },
    action = wezterm.action_callback(function(inner_window, inner_pane, id)
      if not id then
        return
      end
      if id == 'copy' then
        inner_window:perform_action(act.CopyTo 'Clipboard', inner_pane)
      elseif id == 'cut' then
        inner_window:perform_action(act.CopyTo 'Clipboard', inner_pane)
        inner_window:perform_action(act.SendKey { key = 'x', mods = 'CTRL' }, inner_pane)
      elseif id == 'paste' then
        inner_window:perform_action(act.PasteFrom 'Clipboard', inner_pane)
      end
    end),
  }, pane)
end

wezterm.on('new-tab-button-click', function(window, pane, button, _)
  if button ~= 'Right' then
    return
  end

  window:perform_action(act.InputSelector {
    title = 'WezTerm',
    choices = {
      { id = 'new_tab', label = 'New tab' },
      { id = 'split_h', label = 'Split horizontal' },
      { id = 'split_v', label = 'Split vertical' },
      { id = 'move_pane_tab', label = 'Move pane to new tab' },
      { id = 'close_pane', label = 'Close current pane' },
      { id = 'launcher', label = 'Launcher menu' },
      { id = 'command_palette', label = 'Command palette' },
      { id = 'cancel', label = 'Cancel' },
    },
    action = wezterm.action_callback(function(inner_window, inner_pane, id)
      if not id then
        return
      end
      if id == 'new_tab' then
        inner_window:perform_action(act.SpawnTab 'CurrentPaneDomain', inner_pane)
      elseif id == 'split_h' then
        inner_window:perform_action(act.SplitHorizontal { domain = 'CurrentPaneDomain' }, inner_pane)
      elseif id == 'split_v' then
        inner_window:perform_action(act.SplitVertical { domain = 'CurrentPaneDomain' }, inner_pane)
      elseif id == 'move_pane_tab' then
        move_current_pane_to_new_tab(inner_window, inner_pane)
      elseif id == 'close_pane' then
        inner_window:perform_action(act.CloseCurrentPane { confirm = false }, inner_pane)
      elseif id == 'launcher' then
        inner_window:perform_action(act.ShowLauncher, inner_pane)
      elseif id == 'command_palette' then
        inner_window:perform_action(act.ActivateCommandPalette, inner_pane)
      elseif id == 'cancel' then
        return
      end
    end),
  }, pane)

  return false
end)

return {
  default_prog = { 'powershell.exe', '-NoLogo' },
  default_cwd = workspace_root,
  color_scheme = 'Tokyo Night',
  font = wezterm.font 'JetBrainsMono Nerd Font',
  font_size = 12.5,
  line_height = 1.08,
  cell_width = 1.0,
  window_background_opacity = 0.97,
  text_background_opacity = 1.0,
  win32_system_backdrop = 'Acrylic',
  window_decorations = 'INTEGRATED_BUTTONS|RESIZE',
  window_padding = { left = 10, right = 10, top = 8, bottom = 6 },
  enable_scroll_bar = false,
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,
  show_new_tab_button_in_tab_bar = true,
  tab_bar_at_bottom = false,
  status_update_interval = 1000,
  adjust_window_size_when_changing_font_size = false,
  exit_behavior = 'Close',
  command_palette_bg_color = '#090d13',
  command_palette_fg_color = '#c5d7e8',
  switch_to_last_active_tab_when_closing_tab = true,
  background = build_background(wallpapers[1]),

  keys = {
    { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
    { key = 'P', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
    { key = 'L', mods = 'CTRL|SHIFT', action = act.ShowLauncher },
    { key = 'X', mods = 'CTRL|SHIFT', action = act.SpawnCommandInNewTab { args = { 'codex', '--dangerously-bypass-approvals-and-sandbox' } } },
    { key = 'W', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = false } },
    { key = 'Q', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = false } },
    {
      key = 'Y',
      mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        move_current_pane_to_new_tab(window, pane)
      end),
    },
    { key = 'phys:Minus', mods = 'ALT|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'phys:Equal', mods = 'ALT|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'phys:Minus', mods = 'CTRL|SHIFT', action = act.DecreaseFontSize },
    { key = 'phys:Equal', mods = 'CTRL|SHIFT', action = act.IncreaseFontSize },
    {
      key = 'O',
      mods = 'CTRL|SHIFT',
      action = act.SpawnCommandInNewTab {
        args = {
          'powershell.exe',
          '-NoLogo',
          '-NoExit',
          '-Command',
          "$root = Join-Path $HOME 'Documents\\codex-workspace'; if (Test-Path $root) { $pick = fd -td . $root | fzf; if ($pick) { Set-Location (Join-Path $root $pick) } }",
        },
      },
    },
  },
  mouse_bindings = {
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        show_edit_menu(window, pane)
      end),
    },
  },

  launch_menu = {
    {
      label = 'cx (danger mode)',
      args = { 'codex', '--dangerously-bypass-approvals-and-sandbox' },
    },
    {
      label = 'PowerShell',
      args = { 'powershell.exe', '-NoLogo' },
    },
    {
      label = 'Cmd',
      args = { 'cmd.exe' },
    },
  },
}
