# Contributing to the Smart Tiffin documentation set

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Status | Documentation-only guidance; no application code exists under this contract yet. |

## Scope

This file governs contributions to `FINAL_REFINED_DOCS/` only. For contributions to the legacy `docs/` tree or to application code (`app/`, `backend/`, `firebase/`), follow the root-level project instructions in `AGENTS.md`; this folder does not supersede those, it documents a separate, more advanced baseline pending an approved cutover (see [README.md](README.md)).

## Rules for every change in this folder

1. **Header block first.** Every Markdown file states its revision, owner, purpose, scope, dependencies, authoritative policies and status, per [analysis/CONVENTIONS_AND_ID_REGISTER.md](analysis/CONVENTIONS_AND_ID_REGISTER.md).
2. **Tag every claim.** USER-REQ (explicit user instruction), OBSERVED (screenshot, prototype or code), PROPOSED (engineering recommendation, not approved), or PENDING (an open BR/DEC). Never upgrade a tag by repetition.
3. **No invented policy values.** A fee, cutoff, percentage, threshold, tax rate or deadline is a named parameter (`policy.*`) with a link to its BR/DEC entry, never a number pulled from nowhere.
4. **Extend identifiers, never reuse them.** Check [analysis/CONVENTIONS_AND_ID_REGISTER.md](analysis/CONVENTIONS_AND_ID_REGISTER.md) §5 for the next free number in every FR/UC/AC/US/NFR/BR/DEC/ADR/TEST/RISK/TASK/screen range before adding a new entry.
5. **One authoritative file per topic.** Link to it; do not duplicate its content elsewhere.
6. **Preserve what still works.** Rewrite section by section from the existing content and the primary sources; do not delete a still-valid requirement, control or workflow without recording why in [analysis/CONFLICT_REGISTER.md](analysis/CONFLICT_REGISTER.md).
7. **Markdown only, inside this folder.** No scripts, images, archives or other binary files; diagrams are Mermaid fenced blocks inside a `.md` file.
8. **Never claim execution.** A test, build, deployment or security review is "executed" only if it actually ran in this session, with a recorded command and result, in [verification/](verification/) or [testing/TEST_RESULTS.md](testing/TEST_RESULTS.md).
9. **Illustrative money is always hypothetical.** Every BDT figure used as an example is labelled HYPOTHETICAL and uses integer minor units (paisa).
10. **Update the index.** A new file is linked from [MASTER_INDEX.md](MASTER_INDEX.md) and, where relevant, [README.md](README.md).

## Review before merge

Run through [verification/DOCUMENTATION_CHECKS.md](verification/DOCUMENTATION_CHECKS.md) and [verification/CONSISTENCY_AUDIT.md](verification/CONSISTENCY_AUDIT.md) for the current state of link, identifier and claim checks across this folder.
