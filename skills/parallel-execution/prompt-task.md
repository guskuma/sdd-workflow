# Template — prompt de subagente (task paralela SDD)

Copiar e preencher ao dispatch via `Task`. Substituir `{...}`.

```
Você implementa APENAS a task {TN} da spec em {caminho-pasta-spec}.

## Context pack
{copiar integral de tasks.md — seção Context pack da task}

## Steps
{copiar integral de tasks.md — seção Steps da task}

## Restrições
{copiar bullets relevantes de spec.md §2 Restrições}
{restrições aplicáveis do AGENTS.md — integrações, stack, mapeamento de erros}

## Proibido
- Editar arquivos fora da coluna "Onde" desta task
- Shadow code (fora da spec/plano)
- Commits (só se o dev pedir explicitamente)
- Alterar build files, migrations ou config compartilhada (salvo se "Onde" incluir)

## Convenções
- Seguir as convenções de código e o AGENTS.md do projeto
- Respeitar a separação de camadas do projeto (ver AGENTS.md)
- Mapeamento de erros de integração: conforme AGENTS.md

## TDD (se a spec tiver tdd: true)
- Respeitar Steps test-first quando aplicável
- Integrações excluídas em AGENTS.md: test-first N/A salvo tdd_integracao opt-in

## Ao terminar, retornar
1. **Status:** DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
2. **Arquivos alterados:** lista com paths
3. **Comandos rodados:** comando + exit code + resumo do output
4. **Dúvidas/blockers:** se houver
5. **Desvios do plano:** se houver (não implementar desvio sem escalar)
```
