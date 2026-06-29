# Changelog

Todas as mudanças relevantes deste plugin são documentadas aqui.

O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/)
e o versionamento segue [SemVer](https://semver.org/lang/pt-BR/).

## Política de versão

- **MAJOR**: mudanças incompatíveis no contrato de uso (skills, `AGENTS.md`, comandos).
- **MINOR**: novas skills/comandos ou capacidades de forma retrocompatível.
- **PATCH**: correções e ajustes de texto sem mudança de comportamento.

Ao mudar comportamento, suba a versão em **todos** os manifestos (`plugin.json`,
`.cursor-plugin/plugin.json`, `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`,
`.github/plugin/marketplace.json`, `gemini-extension.json`, `package.json`) e registre aqui.

## [Unreleased]

## [0.5.0] - 2026-06-29

### Added

- **Disciplina de implementação** — 4 regras transversais em `using-sdd` (injetadas no `session-start`):
  não assumir / expor tradeoffs; código mínimo sem especulação; tocar só o necessário; critérios de
  sucesso com loop de verificação.
- Reforço por fase: `sdd-03-specify`, `sdd-05-review`, `sdd-06-execute`, `sdd-07-task-review`,
  `verification`, `sdd-08-spec-review`.
- `agents-md-contract.md`: projetos podem espelhar a disciplina em **Restrições padrão** do `AGENTS.md`.

## [0.4.0] - 2026-06-19

### Added

- `/sdd-01-new` pergunta feature flag (qualquer tipo) e registra `feature_flag` no frontmatter.
- `/sdd-04-plan` reavalia feature flag; se § Feature flags do `AGENTS.md` vazio, pergunta padrão e opt-in para atualizar o arquivo (só com confirmação expressa).
- `/sdd-init` detecta ou pergunta padrão de feature flags no bootstrap.
- § Feature flags estruturado em `agents-md-template.md` e `agents-md-contract.md`.
- Campo `feature_flag` em `spec-template.md`.

## [0.3.0] - 2026-06-18

### Added

- Template bundled `mr-template.md` em `skills/sdd-01-new/templates/` (scaffoldado em
  `specs/templates/` na primeira spec do projeto).

### Changed

- `sdd-01-new`: discovery automático de template MR/PR (`.gitlab/merge_request_templates/`,
  `.github/PULL_REQUEST_TEMPLATE*`, ou template bundled); origem registrada em `executions.md`.
- `sdd-09-docs`: mesma cascata de discovery para specs legadas; título do MR conforme convenção
  de branches no `AGENTS.md`.
- `sdd-init`: removida seção "Template de MR/PR" do `AGENTS.md` gerado — templates resolvidos
  por discovery nas skills SDD.

## [0.2.0] - 2026-06-18

### Added

- Comando `/sdd-init` e skill `sdd-init` para bootstrap automático do projeto-alvo:
  análise do repositório, geração de `AGENTS.md`, `CLAUDE.md` e `GEMINI.md`.
- Templates em `skills/sdd-init/templates/` (`agents-md-template.md`, `claude-md-template.md`,
  `gemini-md-template.md`).

### Changed

- `using-sdd` passa a sugerir `/sdd-init` quando o projeto não tiver `AGENTS.md`.

## [0.1.0] - 2026-06-17

### Added

- Fluxo SDD completo em 9 skills (`sdd-01-new` … `sdd-09-docs`) generalizado e
  desacoplado de qualquer projeto, com configuração específica via `AGENTS.md` do repo-alvo.
- Skills transversais: `using-sdd` (bootstrap), `verification`, `debugging`,
  `parallel-execution` e `commit-message`.
- Templates SDD empacotados em `skills/sdd-01-new/templates/`, scaffoldados no projeto-alvo.
- Slash commands `/sdd-0X` para Cursor/Claude/Gemini.
- Subagente `code-reviewer` (`agents/code-reviewer.agent.md`).
- Suporte multiplataforma: Cursor, Claude Code, Codex, GitHub Copilot CLI, Gemini CLI e OpenCode,
  com manifestos próprios e hook `session-start` (com wrapper `run-hook.cmd` para Windows).

[Unreleased]: https://github.com/guskuma/sdd-workflow/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/guskuma/sdd-workflow/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/guskuma/sdd-workflow/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/guskuma/sdd-workflow/releases/tag/v0.1.0
