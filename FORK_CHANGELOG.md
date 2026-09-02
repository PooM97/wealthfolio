# Fork Changelog

Personal-fork changes on top of upstream `wealthfolio/wealthfolio`. Not part of
upstream — kept here as an index so future merges/rebases can spot where
upstream changes will conflict with local changes.

Each entry is a pointer, not a writeup: full rationale and behavior-change
detail lives in the commit message (`git log --grep "<title>"`). This file only
needs the title and the **conflict zones** — files whose upstream edits should
make you re-check that commit.

When pulling upstream updates, check each entry's **Conflict zones** against
files upstream touched, in every section back to your current base.

---

## feat(docker): add fork-image build/update scripts

**Conflict zones:**

- `compose.yml` — usage-comment header (added a "Fork overlay" line)

---

## fix(dev): spawn pnpm via shell on Windows

**Conflict zones:**

- `apps/frontend/scripts/dev-addon-sandbox.mjs` — `spawnPnpm`
- `scripts/dev-web.mjs` — `spawnNamed`

---
