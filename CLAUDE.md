# SDD Plugin — guia para contribuição

Este repositório é um **plugin multiplataforma** de skills para o fluxo SDD (Spec-Driven Development). As skills são **genéricas**: o que é específico de cada projeto fica no `AGENTS.md` do repositório que consome o plugin.

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
