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

## feat(charts): add 3Y interval to investment and net worth range selectors

**Conflict zones:**

- `packages/ui/src/components/financial/interval-selector.tsx` — `TimePeriod`
  type, `intervalDescriptions`, `intervals`
- `apps/frontend/src/lib/types.ts` — `TimePeriod` type
- `apps/frontend/src/pages/dashboard/dashboard-content.tsx` —
  `getDashboardChartMinDomainSpanRatio`,
  `getDashboardNetContributionMaxDomainSpanRatio`
- `apps/frontend/src/i18n/locales/*/ui.json` — `ui:interval` block (all 9
  locales)

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

## feat(about): show build git SHA on About page

**Conflict zones:**

- `apps/frontend/src/adapters/types.ts` — `AppInfo` interface
- `apps/frontend/src/adapters/web/settings.ts` — `getAppInfo`
- `apps/frontend/src/pages/settings/about/about-page.tsx` — version display
- `apps/server/build.rs`, `apps/tauri/build.rs` — build script `main()`
- `apps/server/src/api/settings.rs`, `apps/tauri/src/commands/utilities.rs` —
  `AppInfo`/`AppInfoResponse` struct, `get_app_info`
- `Dockerfile` — build args section
- `scripts/docker-build.sh` — `ARGS` array

---
