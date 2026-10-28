# Ship Modes

`/lets-ship` and `/pr-loop` run in one of three modes. The mode decides who answers each gate. It never changes what gets checked.

| Mode | Flag | Who answers gates | Ends at |
|---|---|---|---|
| **full-stop** | `--full-stop` | You, at every gate | Main merge, after your approval |
| **auto** | `--auto` | The agent, through dev + live verify | **Ready for main**: report posted, waits for you |
| **yolo** | `--yolo` | The agent, all the way | Merged to main |

## Picking the Mode

A flag picks the mode. **No flag → ask once, before Phase 1**, with the harness's ask-user tool (see [harness-tools.md](harness-tools.md)):

> Which mode?
> - **full-stop** — you stay in the loop and approve each phase.
> - **auto** — I ship to dev, verify in a real environment, fix PR findings, and stop ready for main.
> - **yolo** — same as auto, then I merge to main without asking.

If there's no ask-user tool, ask in chat and wait. Never assume a mode.

## full-stop

Every gate asks with the ask-user tool and offers options, not open questions. Fix budgets still apply. When one runs out, ask what to do.

## auto

- Skips the gates in Phases 1–7. Spec, work, review, compound, PR and dev merge all run unattended.
- Auto-fixes CONFIRMED review findings (max 2 internal iterations) and real PR bot findings (3 rounds, 5 for security). Writes dismissals for the rest.
- **Live verify in a realistic environment.** Use whatever the project really runs on: a browser for web (`browse`, agent-browser, Playwright), a simulator or device for mobile, a real request against the deployed dev environment for APIs. Unit tests and CI don't count.
- Stops at Phase 8 with the report posted on the PR and in chat: "Ready for main." **Never merges main.**
- When a budget runs out or the verdict is `FAIL` twice, stop and ask. Don't loop.

## yolo

Runs auto, then Phase 8 merges into the default branch **without asking**, but only if all of these hold:

- the latest verdict is `PASS` or `PASS+NOTES`;
- `verified_sha` still matches (re-fetched);
- the PR is not BEHIND or DIRTY;
- no real finding is left open.

These are the checks in `/pr-loop` Phase 8, which is the authoritative list. If any fails, don't merge: say which check failed and hand the decision to the user. Don't call it ready for main. The report is posted on the PR before any merge.
