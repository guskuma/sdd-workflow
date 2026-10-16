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
| `Task` (subagente) | sem equivalente direto — execute sequencialmente **na mesma sessão** |
| Retomar subagente | N/A — já é a sessão do orquestrador; seguir o fluxo de papéis (implementar → filtrar review → fix) sem spawn |
| `SwitchMode` (Plan mode) | Sem equivalente — descreva o micro-plano no chat e siga |

O Gemini CLI carrega o metadado das skills no início da sessão (via `GEMINI.md`) e ativa o conteúdo completo sob demanda.

### Retomada

Sem `Task`, não há subagente para retomar: o orquestrador executa implementador, review e fix **na mesma sessão** (degradação documentada em `sdd-06-execute`). Ainda assim **não** fundir papéis mentalmente — rode receiving-review antes do fix e registre `Retomada: N/A (mesma sessão)` se útil.
