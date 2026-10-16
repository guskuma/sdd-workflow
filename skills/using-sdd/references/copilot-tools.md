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
| Retomar subagente (fix / E2 / delta / NEEDS_CONTEXT) | Continuar o mesmo `task` se a CLI expuser continuação/sessão do agente; senão **Task novo** com o prompt integral |
| `TodoWrite` (tracking) | `sql` na tabela `todos` |
| `WebFetch` | `web_fetch` |
| `SwitchMode` (Plan mode) | Sem equivalente — descreva o micro-plano no chat e siga |

## Subagentes (`agent_type`)

| Estilo Claude/Cursor | Copilot CLI |
|---|---|
| `general-purpose` / `generalPurpose` | `"general-purpose"` |
| `Explore` | `"explore"` |
| Agentes nomeados do plugin (ex.: `code-reviewer`) | Descobertos automaticamente dos plugins instalados |

### Retomada

Skills `sdd-04-plan` e `sdd-06-execute` pedem **continuar** o mesmo subagente (fix no implementador, E1→E2 e delta no revisor, material faltante no planejador). Se a plataforma **não** permitir continuar um `task` já encerrado, abra um **Task novo** com o pacote integral do prompt — comportamento equivalente ao fluxo antigo.
