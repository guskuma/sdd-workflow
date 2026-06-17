# Mapeamento de tools — GitHub Copilot CLI

As skills usam nomes de tools do estilo Claude Code/Cursor. No Copilot CLI, use o equivalente:

| Skill referencia | Copilot CLI |
|---|---|
| `Read` (ler arquivo) | `view` |
| `Write` (criar arquivo) | `create` |
| `Edit` / `StrReplace` (editar) | `edit` |
| `Bash` / `Shell` (rodar comando) | `bash` |
| `Grep` (buscar conteúdo) | `grep` |
| `Glob` (buscar arquivos por nome) | `glob` |
| `Skill` (invocar skill) | `skill` |
| `Task` (despachar subagente) | `task` (parâmetro `agent_type`) |
| Várias chamadas `Task` (paralelo) | Várias chamadas `task` |
| `TodoWrite` (tracking) | `sql` na tabela `todos` |
| `WebFetch` | `web_fetch` |
| `SwitchMode` (Plan mode) | Sem equivalente — descreva o micro-plano no chat e siga |

## Subagentes (`agent_type`)

| Estilo Claude/Cursor | Copilot CLI |
|---|---|
| `general-purpose` / `generalPurpose` | `"general-purpose"` |
| `Explore` | `"explore"` |
| Agentes nomeados do plugin (ex.: `code-reviewer`) | Descobertos automaticamente dos plugins instalados |
