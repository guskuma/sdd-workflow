# Mapeamento de tools — Gemini CLI

As skills usam nomes de tools do estilo Claude Code/Cursor. No Gemini CLI, use o equivalente:

| Skill referencia | Gemini CLI |
|---|---|
| `Read` (ler arquivo) | `read_file` |
| `Write` (criar arquivo) | `write_file` |
| `Edit` / `StrReplace` | `replace` / edição de arquivo |
| `Bash` / `Shell` | `run_shell_command` |
| `Grep` | `search_file_content` |
| `Glob` | `glob` |
| `Skill` (invocar skill) | `activate_skill` |
| `WebFetch` | `web_fetch` |
| `Task` (subagente) | sem equivalente direto — execute sequencialmente |
| `SwitchMode` (Plan mode) | Sem equivalente — descreva o micro-plano no chat e siga |

O Gemini CLI carrega o metadado das skills no início da sessão (via `GEMINI.md`) e ativa o conteúdo completo sob demanda.
