# SDD — Spec-Driven Development (plugin multiplataforma)

Fluxo de desenvolvimento guiado por spec, empacotado como **plugin de skills** instalável em **Cursor, Claude Code, OpenAI Codex, GitHub Copilot CLI, Gemini CLI e OpenCode**.

As skills cobrem o ciclo completo — `01 New → 02 Research → 03 Specify → 04 Plan → 05 Review → 06 Execute ⇄ 07 Task review → 08 Spec review → 09 Docs` — mais skills transversais de **TDD/verificação**, **debugging sistemático**, **verificação por evidência** e **execução paralela**.

> **Genérico por design.** As skills não assumem stack/linguagem. O específico de cada projeto (comandos de build, issue tracker, integrações, branch base, mapas) vive no `AGENTS.md` do repositório que consome o plugin. Veja o contrato em [`skills/using-sdd/references/agents-md-contract.md`](skills/using-sdd/references/agents-md-contract.md).

> Repositório: **[guskuma/sdd-workflow](https://github.com/guskuma/sdd-workflow)**.

## O que está incluído

| Skill | Tipo | Para que serve |
|-------|------|----------------|
| `using-sdd` | bootstrap | Disciplina de uso + adaptação entre plataformas |
| `sdd-01-new` … `sdd-09-docs` | fases | Ciclo SDD ponta a ponta |
| `debugging` | transversal | Causa raiz antes do fix (4 fases) |
| `verification` | transversal | Evidência antes de afirmar sucesso |
| `parallel-execution` | transversal | Tasks independentes via subagentes |
| `commit-message` | transversal | Mensagens Conventional Commits (+ issue key opcional) |

Inclui ainda: `commands/` (slash `/sdd-0X`), `agents/code-reviewer.agent.md`, templates SDD empacotados (scaffoldados no projeto pelo `/sdd-01-new`).

## Instalação

### Cursor

Adicione o marketplace e instale o plugin `sdd-workflow` (ou aponte o Cursor para este repositório como plugin). Os comandos `/sdd-0X` ficam disponíveis no chat.

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
3. As skills usam nomes de tools do estilo Claude Code/Cursor; o mapeamento para outras plataformas está em `skills/using-sdd/references/*-tools.md`.

## Pré-requisito no projeto-alvo: `AGENTS.md`

Para o fluxo funcionar bem, o repositório que usa o plugin precisa de um `AGENTS.md` na raiz com, no mínimo: **Gate de qualidade** (comandos de lint/test/build), **issue tracker**, **branches**, **integrações externas** e **restrições padrão**. Modelo completo em [`skills/using-sdd/references/agents-md-contract.md`](skills/using-sdd/references/agents-md-contract.md).

## Compatibilidade por plataforma

| Recurso | Cursor | Claude Code | Codex | Copilot CLI | Gemini CLI | OpenCode |
|---------|:------:|:-----------:|:-----:|:-----------:|:----------:|:--------:|
| Skills | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Slash `/sdd-0X` | ✓ | ✓ | — (invocar por nome) | — | ✓ | — |
| Subagentes (`parallel-execution`, `code-reviewer`) | ✓ | ✓ | ✓ (multi_agent) | ✓ | — | depende |
| Plan mode (no `/sdd-06`) | ✓ | ✓ | — (degrada) | — | — | — |
| Hook SessionStart | ✓ | ✓ | n/a | ✓ | n/a | n/a |

> Onde um recurso não existe, as skills degradam graciosamente (ex.: sem Plan mode, descrevem o micro-plano no chat; sem subagentes, executam sequencialmente).

## Licença

MIT — ver [LICENSE](LICENSE).
