# SDD — Spec-Driven Development (plugin multiplataforma)

Fluxo de desenvolvimento guiado por spec, empacotado como **plugin de skills** instalável em **Cursor, Claude Code, OpenAI Codex, GitHub Copilot CLI, Gemini CLI e OpenCode**.

As skills cobrem o ciclo completo — `/sdd-init` (bootstrap) → `01 New` → `02 Research` → `03 Specify` → `04 Plan` → `05 Review` → `06 Execute` ⇄ `07 Task review` → `08 Spec review` → `09 Docs` — mais skills transversais de **debugging sistemático**, **verificação por evidência**, **execução paralela** e **commit message**.

Em cada mudança rastreável, o fluxo também **gera documentação de histórico** versionada no repositório — pasta `specs/` com spec (As Is → To Be), plano, execuções, revisões e `implementation-log.md` — registrando o porquê, o que mudou e como foi validado.

> **Genérico por design.** As skills não assumem stack/linguagem. O específico de cada projeto (comandos de build, issue tracker, integrações, branch base, mapas) vive no `AGENTS.md` do repositório que consome o plugin. Veja o contrato em [`skills/using-sdd/references/agents-md-contract.md`](skills/using-sdd/references/agents-md-contract.md).

> Repositório: **[guskuma/sdd-workflow](https://github.com/guskuma/sdd-workflow)**.

## Documentação de histórico

O `/sdd-01-new` faz o scaffold de `specs/` na primeira mudança do repositório (templates em `specs/templates/`). Cada spec vive em uma pasta datada e acumula artefatos ao longo das fases:

```
specs/
├── templates/                 # cópia dos templates do plugin (primeira spec)
├── implementation-log.md      # índice global de specs concluídas
└── YYYY-MM-{ISSUE-KEY}-slug/
    ├── spec.md                # As Is, To Be, goals, restrições (research → specify)
    ├── design.md              # opcional — alta complexidade (specify)
    ├── tasks.md               # opcional — backlog detalhado (plan, ≥ 5 tasks)
    ├── executions.md          # gates, revisões, desvios, fechamento (execute → docs)
    ├── issue-summary.md       # snapshot da issue (new)
    └── mr-template.md         # corpo do MR/PR (preenchido em docs)
```

| Arquivo | Fase principal | O que registra |
|---------|----------------|----------------|
| `spec.md` | 02 Research → 03 Specify | Contexto, As Is, To Be, goals, non-goals, restrições |
| `design.md` | 03 Specify | Decisões de design quando a complexidade exige |
| `tasks.md` | 04 Plan | Backlog com dependências e fases (ou §5 de `spec.md` se < 5 tasks) |
| `executions.md` | 06 Execute → 09 Docs | O que foi feito, gates, revisões, documentação |
| `issue-summary.md` | 01 New | Snapshot da issue no início |
| `mr-template.md` | 09 Docs | Descrição pronta para abrir o MR/PR |
| `implementation-log.md` | 09 Docs | Entrada por spec concluída (link, branch, data) |

> Sem issue tracker? Use um identificador curto no lugar de `{ISSUE-KEY}` (ex.: o slug) e marque os campos de issue como `N/A`. A convenção completa está em [`skills/using-sdd/references/agents-md-contract.md`](skills/using-sdd/references/agents-md-contract.md).

## O que está incluído

| Skill | Tipo | Para que serve |
|-------|------|----------------|
| `using-sdd` | bootstrap | Disciplina de uso + adaptação entre plataformas |
| `sdd-init` | bootstrap | Análise do repositório + geração de `AGENTS.md`, `CLAUDE.md` e `GEMINI.md` (idempotente) |
| `sdd-01-new` … `sdd-09-docs` | fases | Ciclo SDD ponta a ponta (TDD opcional, decidido no `01-new`) |
| `debugging` | transversal | Causa raiz antes do fix (4 fases) |
| `verification` | transversal | Evidência antes de afirmar sucesso |
| `parallel-execution` | transversal | Tasks independentes via subagentes |
| `commit-message` | transversal | Mensagens Conventional Commits (+ issue key opcional) |

Inclui ainda: `commands/` (slash `/sdd-init` e `/sdd-0X`), `agents/code-reviewer.agent.md`, templates SDD empacotados (scaffoldados em `specs/` pelo `/sdd-01-new`; bootstrap de projeto pelo `/sdd-init`).

## Instalação

### Cursor

Adicione o marketplace e instale o plugin `sdd-workflow` (ou aponte o Cursor para este repositório como plugin). Os comandos `/sdd-init` e `/sdd-0X` ficam disponíveis no chat.

### Claude Code

```bash
/plugin marketplace add guskuma/sdd-workflow
/plugin install sdd-workflow@sdd-marketplace
```

### GitHub Copilot CLI

```bash
copilot plugin marketplace add guskuma/sdd-workflow
copilot plugin install sdd-workflow@sdd-marketplace
```

### OpenAI Codex

Peça ao Codex:

```
Fetch and follow instructions from https://raw.githubusercontent.com/guskuma/sdd-workflow/refs/heads/main/.codex/INSTALL.md
```

Detalhes: [`.codex/INSTALL.md`](.codex/INSTALL.md).

### Gemini CLI

```bash
gemini extensions install https://github.com/guskuma/sdd-workflow
```

### OpenCode

Detalhes: [`.opencode/INSTALL.md`](.opencode/INSTALL.md).

## Como funciona

1. O hook `SessionStart` injeta a skill `using-sdd` no início da sessão (formato JSON detectado por plataforma).
2. `using-sdd` orienta o agente a sempre consultar o `AGENTS.md` do projeto e a invocar as skills relevantes.
3. Sem `AGENTS.md`, o agente sugere `/sdd-init` para analisar o repositório e gerar os arquivos de bootstrap.
4. As skills usam nomes de tools do estilo Claude Code/Cursor; o mapeamento para outras plataformas está em `skills/using-sdd/references/*-tools.md`.

## Pré-requisito no projeto-alvo: `AGENTS.md`

Para o fluxo funcionar bem, o repositório que usa o plugin precisa de um `AGENTS.md` na raiz com, no mínimo: **Gate de qualidade** (comandos de lint/test/build), **issue tracker**, **branches**, **integrações externas** e **restrições padrão**. Modelo completo em [`skills/using-sdd/references/agents-md-contract.md`](skills/using-sdd/references/agents-md-contract.md).

> **Primeira vez no projeto?** Rode `/sdd-init` — a skill detecta stack, comandos de CI, issue tracker e convenções Git quando possível, gera `AGENTS.md` (ou preenche lacunas no existente) e cria `CLAUDE.md` / `GEMINI.md` apontando para ele.

## Compatibilidade por plataforma

| Recurso | Cursor | Claude Code | Codex | Copilot CLI | Gemini CLI | OpenCode |
|---------|:------:|:-----------:|:-----:|:-----------:|:----------:|:--------:|
| Skills | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Slash `/sdd-init`, `/sdd-0X` | ✓ | ✓ | — (invocar por nome) | — | ✓ | — |
| Subagentes (`parallel-execution`, `code-reviewer`) | ✓ | ✓ | ✓ (multi_agent) | ✓ | — | depende |
| Plan mode (no `/sdd-06`) | ✓ | ✓ | — (degrada) | — | — | — |
| Hook SessionStart | ✓ | ✓ | n/a | ✓ | n/a | n/a |

> Onde um recurso não existe, as skills degradam graciosamente (ex.: sem Plan mode, descrevem o micro-plano no chat; sem subagentes, executam sequencialmente).

## Licença

MIT — ver [LICENSE](LICENSE).
