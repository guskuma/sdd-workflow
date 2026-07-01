# SDD Plugin — guia para contribuição

> Contrato do projeto para o fluxo SDD. Gerado/atualizado por `/sdd-init`.
> Referência do contrato: `skills/using-sdd/references/agents-md-contract.md`.

Plugin multiplataforma de skills para o fluxo SDD (Spec-Driven Development). As skills são **genéricas**: o que é específico de cada projeto fica no `AGENTS.md` do repositório que consome o plugin.

## Stack

- **Linguagem:** Markdown (skills, commands, agents) + Node.js (mínimo — `package.json`, plugin OpenCode)
- **Framework:** N/A (plugin de skills; sem runtime de aplicação)
- **Build/package:** `package.json` (`"type": "module"`); manifestos por plataforma em `plugin.json`, `gemini-extension.json`, `.cursor-plugin/`, `.claude-plugin/`, `.github/plugin/`

## Gate de qualidade

### Gate iterativo (por task)

Revisão manual por task — sem lint/test/build automatizados neste repositório:

- skills permanecem **genéricas** (nada específico de projeto; specifics vão no `AGENTS.md` do repo-alvo)
- JSONs de manifesto válidos
- versão atualizada em todos os manifestos quando há mudança de comportamento
- `CHANGELOG.md` atualizado quando aplicável

### Gate completo (antes de merge)

Checklist do [`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md):

- skills genéricas
- JSONs de manifesto válidos
- versão atualizada em todos os manifestos (quando há mudança de comportamento)
- `CHANGELOG.md` atualizado
- testado nas plataformas afetadas (Cursor / Claude / Codex / Copilot / Gemini / OpenCode)

### Teste único (debug)

- N/A — revisão manual do artefato alterado (skill, command, hook ou manifesto)

## Issue tracker

- **Plataforma:** GitHub Issues
- **URL base:** https://github.com/guskuma/sdd-workflow/issues
- **Como ler:** `gh issue view <número>` ou interface web do GitHub

## Branches Git

- **Branch base:** `main`
- **Convenção:** `feat/{ISSUE-KEY}`, `fix/{ISSUE-KEY}`, `chore/{ISSUE-KEY}` (ex.: `feat/42`)
- **Plataforma de MR/PR:** GitHub
- **Título MR/PR:** `{ISSUE-KEY}-{slug}` ou descrição curta alinhada ao Conventional Commits

## Integrações externas

| Integração | TDD por padrão? | Notas |
|------------|-----------------|-------|
| Plataformas plugin (Cursor, Claude, Codex, Copilot, Gemini, OpenCode) | fora | Teste manual na plataforma afetada |
| Hook `hooks/session-start` (Bash) | fora | Validar injeção de contexto na sessão |

## Restrições padrão

- **Genérico por padrão.** Nenhuma skill deve hardcodar stack, comandos de build, issue tracker ou integrações de um projeto específico.
- **Fonte única de skills.** `skills/` é compartilhado por todas as plataformas; cada plataforma tem apenas seu manifesto.
- **Versione** ao mudar comportamento: subir versão em todos os manifestos (`*plugin.json`, `marketplace.json`, `gemini-extension.json`, `package.json`) e registrar em `CHANGELOG.md` (SemVer).

## Convenção de pastas (specs)

```
specs/
├── templates/                 # scaffoldado pelo /sdd-01-new
├── implementation-log.md      # log global
└── YYYY-MM-{ISSUE-KEY}-slug/
    ├── spec.md
    ├── design.md              # opcional
    ├── tasks.md               # opcional (≥ 5 tasks)
    ├── executions.md
    ├── mr-template.md         # preenchido em /sdd-09-docs
    └── issue-summary.md
```

## Mapa de research (As Is)

| Área | Caminhos |
|------|----------|
| Skills SDD | `skills/*/SKILL.md` |
| Slash commands | `commands/` |
| Subagentes | `agents/` |
| Hooks | `hooks/` |
| Templates SDD (bundled) | `skills/sdd-01-new/templates/`, `skills/sdd-init/templates/` |
| Manifestos / instalação | `.cursor-plugin/`, `.claude-plugin/`, `.github/plugin/`, `plugin.json`, `gemini-extension.json`, `.codex/`, `.opencode/` |
| Referências de tools (multi-plataforma) | `skills/using-sdd/references/` |

## Mapa de documentação

- `README.md` — visão geral, instalação e fluxo SDD
- `docs/` — guias por plataforma (`README.codex.md`, `README.opencode.md`)
- `CHANGELOG.md` — histórico de versões (SemVer)
- `.github/PULL_REQUEST_TEMPLATE.md` — checklist de merge

## Feature flags

- N/A

## ADR (opcional)

- **Path:** N/A

---

## Princípios de design

- **Genérico por padrão.** Nenhuma skill deve hardcodar stack, comandos de build, issue tracker ou integrações de um projeto específico. Esses valores vêm do `AGENTS.md` do projeto-alvo (ver `skills/using-sdd/references/agents-md-contract.md`).
- **Fonte única de skills.** `skills/` é compartilhado por todas as plataformas. Cada plataforma tem apenas seu manifesto.
- **Disciplina de uso.** A skill `using-sdd` é o bootstrap; o hook `hooks/session-start` a injeta no início da sessão.

## Estrutura

| Caminho | O que é |
|---------|---------|
| `skills/` | Skills SDD (fonte única). `SKILL.md` com frontmatter `name` + `description`. |
| `skills/sdd-01-new/templates/` | Templates SDD empacotados; o `/sdd-01-new` os scaffolda no projeto-alvo. |
| `commands/` | Slash commands `/sdd-0X` (Cursor/Claude/Gemini). |
| `agents/` | Subagentes. Use a extensão `*.agent.md` (exigida pelo Copilot CLI; também é um `.md` válido, então Cursor/Claude leem o mesmo arquivo — a identidade vem do `name` no frontmatter, sem registro duplicado). |
| `hooks/` | `hooks.json` (Claude/Copilot), `hooks-cursor.json` (Cursor), `session-start` (script), `run-hook.cmd` (wrapper polyglot p/ Windows). |
| `.cursor-plugin/`, `.claude-plugin/`, `.github/plugin/`, `plugin.json`, `gemini-extension.json`, `.codex/`, `.opencode/` | Manifestos/instalação por plataforma. |

## Ao editar skills

- Mantenha os nomes de tools no estilo Claude Code/Cursor; o mapeamento para outras plataformas está em `skills/using-sdd/references/*-tools.md`.
- Não reintroduza acoplamento a um projeto específico. Em vez disso, referencie o `AGENTS.md`.
- Versione: ao mudar comportamento, suba a versão em todos os manifestos (`*plugin.json`, `marketplace.json`, `gemini-extension.json`, `package.json`) e registre em `CHANGELOG.md` (SemVer).
