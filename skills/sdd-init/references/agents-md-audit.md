# Checklist de audit — `AGENTS.md` vs contrato SDD atual

Usado pelo `/sdd-init` em **modo update**. Comparar o que existe no repo-alvo com o [contrato](../../using-sdd/references/agents-md-contract.md) e o [template](../templates/agents-md-template.md).

**Não** marcar como desatualizado valor específico do projeto (stack, comandos, URLs, paths reais) só porque difere do template — isso é conteúdo do dev.

## Severidade

| Tag | Significado |
|-----|-------------|
| `lacuna` | Seção/campo obrigatório ausente ou ainda placeholder/`TODO`/`{...}` |
| `desatualizado` | Estrutura ou forma do contrato mudou; conteúdo pode existir mas não atende o modo atual |
| `relacionado` | `CLAUDE.md` / `GEMINI.md` fora do padrão atual |

## Checks — `AGENTS.md`

| ID | Check | Tag se falhar | O que propor |
|----|-------|---------------|--------------|
| A1 | Existem as seções obrigatórias do contrato: Stack, Gate de qualidade, Issue tracker, Branches Git, Integrações externas, Restrições padrão, Convenção de pastas (specs), Mapa de research, Mapa de documentação, Feature flags | `lacuna` | Inserir seção(ões) ausente(s) a partir do template |
| A2 | Gate tem **Gate iterativo**, **Gate completo** e **Teste único (debug)** (ou equivalentes claros) | `desatualizado` / `lacuna` | Completar subseções faltantes sem apagar comandos já preenchidos |
| A3 | Integrações externas tem coluna **TDD por padrão?** (`sim` \| `fora`) | `desatualizado` | Ajustar tabela ao formato do template; preservar nomes/notas |
| A4 | Feature flags: tabela com Mecanismo, Convenção de nome, Default seguro, Path / registro (ou Mecanismo `N/A`) | `lacuna` / `desatualizado` | Inserir/normalizar § Feature flags |
| A5 | Convenção de pastas (specs) inclui `templates/`, pasta `YYYY-MM-{ISSUE-KEY}-slug/` com `spec.md`, `executions.md`, `mr-template.md`, `issue-summary.md`, `closure.md` (design/tasks opcionais); **sem** exigir `implementation-log.md`; tem § Histórico de implementações (descoberta via `status: done` → `concluido` → `closure.md`; `done` e `closure.md` pelo `finish-branch`, não pelo `/sdd-08-docs`; `pr` com url / `#N` / `!N` / `merged-local`; ciclo com `approved` antes do Execute) | `desatualizado` | Atualizar o bloco de árvore e o protocolo de histórico ao padrão atual; se `implementation-log.md` existir no disco, propor nota de legado congelado (não apagar sem pedido) |
| A6 | Cabeçalho/nota aponta que o arquivo é contrato SDD (gerado/atualizado por `/sdd-init`) e referencia o contrato do plugin | `desatualizado` | Acrescentar nota curta do template se ausente |
| A7 | Seção obsoleta que o plugin **não** usa mais no `AGENTS.md` (ex.: template de MR/PR embutido — templates vêm do `/sdd-08-docs`) | `desatualizado` | Oferecer remoção **opt-in**; nunca remover sem confirmação |

## Checks — arquivos relacionados

| ID | Check | Tag se falhar | O que propor |
|----|-------|---------------|--------------|
| R1 | `CLAUDE.md` existe e referencia `AGENTS.md` (link ou menção explícita) | `relacionado` | Acrescentar parágrafo do template **com confirmação** (não reescrever o arquivo inteiro) |
| R2 | `GEMINI.md` existe e importa `AGENTS.md` (`@./AGENTS.md` ou equivalente) | `relacionado` | Acrescentar import **com confirmação** |
| R3 | `CLAUDE.md` / `GEMINI.md` ausentes | `lacuna` | Criar a partir dos templates |

## Como listar ao dev (formato)

Uma linha por finding, sucinta:

```
- [ID] (tag) O quê — por quê / o que muda
```

Exemplo:

```
- [A4] (lacuna) Falta § Feature flags — skills de plan/init esperam Mecanismo + convenção
- [A5] (desatualizado) Árvore de specs sem issue-summary/mr-template — alinhar ao contrato atual
- [R1] (relacionado) CLAUDE.md não aponta para AGENTS.md — acrescentar parágrafo do template
```

## O que **não** auditar como “errado”

- Comandos de lint/test/build diferentes do que o agente “esperaria”
- Issue tracker / branch base escolhidos pelo projeto
- Restrições padrão com texto específico do domínio
- Mapas de research/docs com paths reais do projeto
- ADR opcional ausente ou `N/A`
