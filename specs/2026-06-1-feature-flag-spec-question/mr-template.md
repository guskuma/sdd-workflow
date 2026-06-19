## Summary

Closes #1

This release (**v0.4.0**) adds early **feature flag intent** capture to the SDD workflow — mirroring the existing TDD opt-in in `/sdd-01-new`.

**Why:** Feature flags were only considered late in `/sdd-04-plan` (“when applicable”). Teams should decide upfront whether a change needs a toggle, independent of spec type (`feat`, `fix`, `refactor`, etc.).

**What changed:**

| Area | Change |
|------|--------|
| `/sdd-01-new` | Asks about feature flags for **any** spec type; stores `feature_flag: sim \| nao \| tbd` in `spec.md` frontmatter |
| `spec-template.md` | New `feature_flag` field + metadata row |
| `/sdd-04-plan` | Re-evaluates the New decision; if `AGENTS.md` § Feature flags is empty, asks for the project pattern and **explicit opt-in** before writing `AGENTS.md` |
| `/sdd-init` | Detects or asks for feature-flag conventions during bootstrap |
| `agents-md-template.md` + contract | Structured Feature flags section (mechanism, naming, safe default, code path) |
| Docs | `commands/sdd-01-new.md`, `README.md` |

Skills stay **generic** — implementation details (env var, config file, external service) live in the consuming repo’s `AGENTS.md`, not hardcoded in the plugin.

## Change type

- [ ] Fix (patch)
- [x] New skill/command or capability (minor)
- [ ] Breaking change to usage contract (major)
- [ ] Docs/infra only (no behavior change)

## How to test

This plugin ships Markdown skills and JSON manifests — **no automated test suite**. Validate manually on at least one platform you use (Cursor recommended):

### 1. `/sdd-01-new` (any spec type)

1. Start a new spec with any `tipo` (`feat`, `fix`, `chore`, …).
2. Confirm the agent asks: *“Will this spec use a **feature flag**…?”*
3. Confirm `feature_flag: sim | nao | tbd` is written to the new `spec.md` frontmatter and metadata table.

### 2. `/sdd-init` (bootstrap)

1. On a repo without a filled Feature flags section, run `/sdd-init`.
2. Confirm detection hints and/or questions about mechanism, naming, safe default, and code path.
3. Confirm existing manual content in `AGENTS.md` is **not** overwritten (update mode).

### 3. `/sdd-04-plan` (re-evaluation + opt-in)

1. Use a spec with `feature_flag: sim` and an empty/generic `AGENTS.md` § Feature flags.
2. Confirm Plan re-evaluates impacts before detailing the flag.
3. Confirm the agent asks whether to **update `AGENTS.md`** and only writes after **explicit confirmation**.
4. If you decline, confirm the pattern is documented in `tasks.md` only.

### 4. Manifest sanity (local)

```bash
python3 -m json.tool package.json plugin.json .cursor-plugin/plugin.json \
  .claude-plugin/plugin.json gemini-extension.json \
  .github/plugin/marketplace.json .claude-plugin/marketplace.json
```

All should parse cleanly; every manifest should report `"version": "0.4.0"`.

## Impacts and risks

| Impact | Notes |
|--------|-------|
| +1 question per new spec | Same trade-off as TDD opt-in — intentional early decision |
| Plan may ask to update `AGENTS.md` | Only with explicit dev confirmation |
| Legacy specs without `feature_flag` | Plan keeps legacy “when applicable” behavior |

**Constraints respected:** generic skills, single template source (`skills/sdd-01-new/templates/`), SemVer minor bump, no runtime flag system in the plugin itself.

**Residual risk:** Platform-specific behavior (slash commands, skill discovery) should be smoke-tested on the platforms you ship to.

## Evidence

- All 7 tasks done; `/sdd-07-task-review` and `/sdd-08-spec-review` approved
- JSON manifests validated (`python3 -m json.tool`, exit 0)
- `CHANGELOG.md` entry `[0.4.0]`
- Spec: `specs/2026-06-1-feature-flag-spec-question/`

## Checklist

- [x] Skills remain **generic** (project specifics in target repo `AGENTS.md`)
- [x] Manifest JSON files valid
- [x] Version bumped in all manifests (`0.4.0`)
- [x] `CHANGELOG.md` updated
- [ ] Manually tested on affected platforms (Cursor / Claude / Codex / Copilot / Gemini / OpenCode)

---

**Suggested PR title:** `1-feature-flag-spec-question`  
**Branch:** `feat/1-feature-flag-spec-question` → `main`
