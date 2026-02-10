Initialize context engineering in this project.

Run the init script to create the context/ directory structure:
- context/foundation/ - human-authored source of truth
- context/specs/ - feature/fix/improve definitions  
- context/tasks/ - atomic implementation units

If the user says "with examples", also copy example files.

Execute: `${CLAUDE_PLUGIN_ROOT}/scripts/init.sh` (or with `--with-examples` flag)

After initialization, explain the directory structure and suggest next steps.
