# AGENTS.md — Hackatón Copa 2026 workspace

You are assisting a 4-person team at the **Hackatón Copa 2026** (theme: APIs, DevOps and Observability). There are **two independent challenges** that open and close at the same time. Work on one of them per session unless told otherwise.

## 1. Pick the challenge, then load its context FIRST

| Challenge | Load first | Then load as needed |
|---|---|---|
| **Microsoft / Azure**: deploy, diagnose and fix a flight-operations monitoring app on App Service; answer in CTFd | `skills/copa-microsoft-challenge/SKILL.md` (same file: `context/microsoft-challenge.md`) | `azure-diagnostics`, `appinsights-instrumentation`, `azure-resource-lookup`, `azure-validate`, `azure-kusto`, `azure-quotas`, `azure-resource-visualizer` |
| **Dynatrace**: search and find answers in an organizer-built tenant (Kubernetes app); answer in CTFd | `skills/copa-dynatrace-challenge/SKILL.md` (same file: `context/dynatrace-challenge.md`) | **`dt-dql-essentials` before writing any DQL**, then `dt-obs-problems`, `dt-obs-services`, `dt-obs-tracing`, `dt-obs-logs`, `dt-obs-kubernetes`, `dt-obs-hosts`, `dt-obs-frontends`, `dt-sec-insights`, `dt-app-notebooks`, … |

If the user does not say which challenge, ask.

**Precedence:**
1. The official challenge narrative (published on challenge day) and the organizers' instructions.
2. The `copa-*` context skill.
3. The vendor skills.

The vendor skills are generic. When they suggest something the challenge forbids, the challenge context wins. Examples:
- Scaffolding new infrastructure with `azd` or `azure-prepare`.
- Changing RBAC or the resource group configuration.
- Creating new Terraform or IaC.
- Changing Dynatrace settings, workflows or alerting.

## 2. Non-negotiable rules (both challenges)

- **AI and the internet are allowed. Contacting anyone outside the 4 team members is forbidden.** Never suggest it.
- **Plan for ONE attempt per CTFd question.** There is no partial credit, and hints cost points. You never submit answers. You produce an answer card (`templates/ANSWER-CARD.md`), and a human verifies and submits it.
- **Ask a human before any action that changes something:**
  - `terraform apply` or `destroy`;
  - `az` create, update, delete, restart or deploy;
  - code or config edits (show the diff first);
  - `git push`;
  - unlocking a hint;
  - any change in the Dynatrace tenant.

  Read-only work needs no confirmation.
- **Evidence first.** Symptom → evidence → hypothesis → verify one change at a time → fix → validate. Log every step in `EVIDENCE.md` (copy it from `templates/`). The organizers audit what teams actually did.
- **Never print, store or commit secrets.** Never touch anything outside the team's resource group `rg-team-<id>`.

## 3. Repository layout

```
AGENTS.md                  ← this file (CLAUDE.md imports it)
context/                   ← the two challenge context files (links to the copa-* skills)
skills/                    ← all skills, in the Agent Skills format (SKILL.md + references)
  copa-microsoft-challenge/  copa-dynatrace-challenge/      ← ours
  azure-* / appinsights-instrumentation                      ← official, microsoft/azure-skills (MIT)
  dt-*                                                       ← official, Dynatrace/dynatrace-for-ai (Apache-2.0)
.claude/skills .agents/skills .github/skills .cursor/skills .opencode/skills .gemini/skills → ../skills
.mcp.json                  ← Azure MCP server (uses your `az login`)
mcp/dynatrace.mcp.json     ← optional Dynatrace MCP gateway (needs DT_ENVIRONMENT + DT_PLATFORM_TOKEN)
templates/                 ← EVIDENCE.md and ANSWER-CARD.md
scripts/preflight.sh       ← checks tools and Azure login (read-only)
scripts/update-skills.sh   ← re-pulls the official skills
challenge/                 ← clone the 3 challenge repos here on the day (git-ignored)
```

## 4. On challenge day

1. Run `scripts/preflight.sh`.
2. Clone the three challenge repos (IaC, backend, frontend) into `challenge/`.
3. Work inside them, following the context skill. Keep fixes on `fix/e<n>-<name>` branches inside those repos.
