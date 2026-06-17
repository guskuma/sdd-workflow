# Mapeamento de tools — OpenAI Codex

As skills usam nomes de tools do estilo Claude Code/Cursor. No Codex, use o equivalente da sua interface:

| Skill referencia | Codex |
|---|---|
| `Read` (ler arquivo) | leitura de arquivo nativa |
| `Write` / `Edit` / `StrReplace` | edição/aplicação de patch nativa |
| `Bash` / `Shell` | execução de comando no shell |
| `Grep` / `Glob` | busca de conteúdo / arquivos |
| `Skill` (invocar skill) | ativação de skill por nome/descrição (descoberta nativa) |
| `Task` (subagente) | requer `multi_agent = true` em `[features]` no config do Codex |
| `TodoWrite` | tracking nativo, se disponível; senão, lista no chat |
| `SwitchMode` (Plan mode) | Sem equivalente — descreva o micro-plano no chat e siga |

## Subagentes

As skills `parallel-execution` e qualquer despacho via `Task` dependem do recurso multi-agente do Codex:

```toml
[features]
multi_agent = true
```

Sem esse recurso, execute as tasks **sequencialmente** (uma por vez).
