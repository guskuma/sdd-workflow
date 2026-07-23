# Prompt — Implementador (subagente)

Fonte canônica para implementação sequencial e paralela. Copiar e preencher ao dispatch via `Task`. Substituir `{...}`.

```
Você implementa APENAS a task {TN} da spec em {caminho-pasta-spec}.

## Context pack
{copiar integral de tasks.md — seção Context pack da task}

## Interfaces
{copiar integral — Consumes / Produces; se ausente e o tipo exige, ESCALAR ao orquestrador}

## Steps
{copiar integral de tasks.md — seção Steps da task}

## Restrições
{Global Constraints da tasks.md + bullets relevantes de spec.md §2}
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

## TDD (se a spec tiver tdd: true) — Iron Law
- NENHUM código de produção sem teste falhando pelo motivo certo primeiro
- Se já escreveu produção antes do RED: apagar e recomeçar pelo teste
- Ciclo: red → green → refactor; evidência de cada passo
- Integrações excluídas em AGENTS.md: test-first N/A salvo tdd_integracao opt-in

## Ao terminar, retornar
1. **Status:** DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
2. **Arquivos alterados:** lista com paths
3. **Comandos rodados:** comando + exit code + resumo do output
4. **Dúvidas/blockers:** se houver
5. **Desvios do plano:** se houver (não implementar desvio sem escalar)
```
