# Executions: Perguntar feature flag ao criar spec SDD

> Spec: [spec.md](./spec.md) · Tasks: [tasks.md](./tasks.md)

**Branch:** `feat/1-feature-flag-spec-question` · **Base:** `main`

Legenda: `pending` · `in_progress` · `blocked` · `done` · `skipped`

## Setup (New)

| Item | Valor |
|------|-------|
| Templates scaffold | `specs/templates/` |
| MR template origem | `.github/PULL_REQUEST_TEMPLATE.md` |
| TDD | `false` |
| Feature flag (esta spec) | `nao` |

## Resumo

| Task | Fase | Status | Início | Fim | Responsável |
|------|------|--------|--------|-----|-------------|
| T01 | 1 | done | 2026-06-19 | 2026-06-19 | agente |
| T02 | 1 | done | 2026-06-19 | 2026-06-19 | agente |
| T06 | 1 | done | 2026-06-19 | 2026-06-19 | agente |
| T07 | 2 | done | 2026-06-19 | 2026-06-19 | agente |
| T03 | 2 | done | 2026-06-19 | 2026-06-19 | agente |
| T04 | 2 | done | 2026-06-19 | 2026-06-19 | agente |
| T05 | 3 | done | 2026-06-19 | 2026-06-19 | agente |

## Review do plano

- **Plano aprovado em:** 2026-06-19 (dev: aprovado)

## Ordem sugerida de execução

1. **Fase 1:** T01 + T02 + T06 em paralelo — concluído
2. **Fase 2:** T07 → depois T03 + T04 em paralelo — concluído
3. **Fase 3:** T05 — concluído
4. ~~**Review:** `/sdd-05-review`~~ — concluído, aprovado

## Execução global

- **Plano de execução:** dispensado (dev pediu `/sdd-06-execute todas as fases`)
- **Modo:** sequencial (Fase 1 tasks em batch; Fase 2 T07 → T03+T04; Fase 3 T05)
- **TDD:** N/A (`tdd: false`)

---

## Registro por task

### T01 — Pergunta feature flag em `sdd-01-new`

- **Status:** done
- **Alterações:** `skills/sdd-01-new/SKILL.md` — description, Objetivo, §3.1 Perguntar feature flag, frontmatter `feature_flag` no passo 4
- **DoD:** passo 3.1 incondicional por tipo; referência `AGENTS.md`; sem hardcode de ferramenta

### T02 — `feature_flag` no `spec-template.md`

- **Status:** done
- **Alterações:** `skills/sdd-01-new/templates/spec-template.md`, `specs/templates/spec-template.md` — frontmatter + tabela Metadados
- **DoD:** ambos paths idênticos na parte alterada

### T06 — Contrato + template `AGENTS.md` § Feature flags

- **Status:** done
- **Alterações:** `skills/sdd-init/templates/agents-md-template.md`, `skills/using-sdd/references/agents-md-contract.md`
- **DoD:** template estruturado; contrato atualizado; exemplo mínimo genérico

### T07 — Detecção/pergunta em `sdd-init`

- **Status:** done
- **Alterações:** `skills/sdd-init/SKILL.md` — tabela detecção, questões típicas, preenchimento § Feature flags, resumo passo 2
- **DoD:** detecção + pergunta documentadas; idempotência preservada

### T03 — Reavaliação + opt-in `AGENTS.md` em `sdd-04-plan`

- **Status:** done
- **Alterações:** `skills/sdd-04-plan/SKILL.md` — §3 Feature flags substituído; entregável atualizado
- **DoD:** fluxo vazio → pergunta → opt-in → só grava com confirmação; recusa em `tasks.md` only

### T04 — Comando + README

- **Status:** done
- **Alterações:** `commands/sdd-01-new.md`, `README.md`
- **DoD:** command + README atualizados

### T05 — Versionamento SemVer + CHANGELOG

- **Status:** done
- **Alterações:** bump `0.4.0` em `package.json`, `plugin.json`, `.cursor-plugin/plugin.json`, `.claude-plugin/plugin.json`, `gemini-extension.json`, `.github/plugin/marketplace.json`, `.claude-plugin/marketplace.json`; `CHANGELOG.md`
- **DoD:** todos manifestos `0.4.0`; JSONs válidos; CHANGELOG ok

---

### Verificação — 2026-06-19 Fase 1–3 (gate iterativo)

- **Comando:** `python3 -m json.tool` em todos os manifestos JSON
- **Exit code:** 0 (7 arquivos)
- **Evidência:** `package.json`, `plugin.json`, `.cursor-plugin/plugin.json`, `.claude-plugin/plugin.json`, `gemini-extension.json`, `.github/plugin/marketplace.json`, `.claude-plugin/marketplace.json` — todos OK
- **Comando:** `rg "0\.3\.0" --glob '*.json'`
- **Evidência:** nenhuma ocorrência (versão antiga removida de todos manifestos)
- **Revisão manual:** skills genéricas (ferramentas só como exemplos em detecção/comentário); paths alterados conforme tasks.md
- **Afirmação:** gate iterativo verde

## Revisão de tasks (`/sdd-07-task-review`)

### T01
- **Estágio 1 (spec compliance):** ✅ — §3.1 incondicional; frontmatter; referência AGENTS.md
- **Estágio 2 (code quality):** ✅ — skill genérica; sem hardcode obrigatório de ferramenta

### T02
- **Estágio 1:** ✅ — frontmatter + metadados em ambos paths
- **Estágio 2:** ✅ — paths idênticos

### T06
- **Estágio 1:** ✅ — template estruturado; contrato expandido; exemplo mínimo
- **Estágio 2:** ✅ — exemplos genéricos; ferramentas só em comentário HTML

### T07
- **Estágio 1:** ✅ — detecção, perguntas, preenchimento, idempotência
- **Estágio 2:** ✅ — alinhado ao contrato T06

### T03
- **Estágio 1:** ✅ — fluxo completo sim/nao/tbd/legado; opt-in AGENTS.md
- **Estágio 2:** ✅ — proíbe escrita sem confirmação expressa

### T04
- **Estágio 1:** ✅ — command + README conforme RF-07
- **Estágio 2:** ✅ — texto conciso e alinhado

### T05
- **Estágio 1:** ✅ — 0.4.0 em 7 manifestos; CHANGELOG conforme tasks
- **Estágio 2:** ✅ — JSONs validados; SemVer minor correto

**Próximo passo:** `/sdd-09-docs`

---

## Validação final (gate completo)

### Verificação — 2026-06-19 spec review

- **Comando:** checklist manual `.github/PULL_REQUEST_TEMPLATE.md` + `python3 -m json.tool` (7 manifestos)
- **Exit code:** 0
- **Evidência:**
  - Skills genéricas — revisão manual OK (ferramentas só em detecção/comentário HTML)
  - JSONs válidos — 7/7 OK
  - Versão `0.4.0` — presente em todos manifestos
  - `CHANGELOG.md` — entrada `[0.4.0]` conforme T05
  - Plataformas — **pendente teste manual** (Cursor/Claude/Codex/Copilot/Gemini/OpenCode)
- **Afirmação:** gate completo verde exceto teste manual em plataformas (risco residual para revisor humano)

## Revisão da spec

- **Data:** 2026-06-19
- **Resultado:** ✅ **Aprovada**
- **Tasks:** 7/7 `done` com `/sdd-07-task-review` ✅
- **Desvios spec↔código:** nenhum bloqueante
- **Observação:** `CLAUDE.md` expandido (fora do escopo T01–T05; provável `/sdd-init` anterior) — não afeta entrega de feature flag
- **Próximo:** MR/PR aberto com conteúdo de `mr-template.md`

---

## Documentação

| Arquivo | Ação |
|---------|------|
| `README.md` | Atualizado em T04 — menciona feature flag no `01-new` |
| `CHANGELOG.md` | Entrada `[0.4.0]` em T05 |
| Skills/commands/templates | Entregável principal — documentação inline nas skills |
| OpenAPI / schema / DB | N/A — plugin Markdown, sem API runtime |

**Conclusão:** documentação pública alinhada; sem gaps adicionais além do que já foi entregue nas tasks.

## MR

- **Arquivo:** `mr-template.md` — preenchido em **inglês**, adaptado ao plugin (validação manual de skills, sem testes/DB)
- **Título sugerido:** `1-feature-flag-spec-question`
- **Closes:** #1

## Comentário na issue

- **Perguntado ao dev:** não (sessão `/sdd-09-docs`)
- **Decisão:** pendente — dev pode publicar manualmente ou pedir na próxima interação

## ADR

- **Perguntado ao dev:** não
- **Decisão:** N/A — mudança de fluxo em skills, sem decisão arquitetural de runtime
