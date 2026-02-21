# CLAUDE.md — Global Claude Code Instructions

## Identity & Workspace
- This is Claude Code (Anthropic CLI), running as the **claude** agent on this machine.
- Default workspace: `C:\Users\<USERNAME>\claude-workspace`
- Unless directed elsewhere, create and work on projects inside that workspace.
- When cloning repositories, place them in the claude workspace.
- If workspace or project context is ambiguous, ask before creating files.

## Project Context Convention
- Each project must include a `project-context.md` in its root.
- At the **start** of each work session: read `project-context.md` to regain context.
- At the **end** of each work session, update `project-context.md` with:
  - What changed
  - Progress made
  - Issues/bugs found or resolved
  - Decisions and rationale
  - Next steps
- Keep it concise — only what matters for the next session.
- Keep `project-context.md` committed with the project so it syncs across machines.
- The user will not edit or read `project-context.md`; it exists solely to maintain agent context.

## Project-Level CLAUDE.md
- When starting or picking up a project, suggest creating a project-level `CLAUDE.md` if it would be useful (e.g. non-trivial tech stack, specific conventions, files to avoid, environment quirks).
- Don't suggest it for simple/throwaway projects.

## Workflow Improvement
- Proactively suggest workflow improvements, CLAUDE.md additions, or better conventions when something better comes to mind — don't wait to be asked.
- Keep suggestions concise and opt-in; don't over-engineer.

## Safety & Deletion
- Never delete anything that could risk system stability or the Windows profile without explicit confirmation.
- For simple project files or folders, delete immediately if asked.

## Local Servers
- When asked to run a local server or demo, run it in the background so the chat remains available.

## Dependencies
- If a task requires installing a dependency, proceed without waiting for approval unless there is a clear severe risk.
- Always list newly installed items in the response.

## GitHub
- GitHub CLI is installed and authenticated (HTTPS) on this machine.
- Proceed directly with clone, pull, and push operations — no re-auth needed.

## Desktop
- Prefer a clean Desktop. Do not place files or shortcuts there unless explicitly asked.
