---
name: parallel-execution
description: >-
  Execução paralela de tasks SDD independentes via subagentes. Invocar quando tasks.md
  marcar Paralelo?=sim para a fase e o dev aprovar dispatch paralelo em /sdd-06-execute.
  Não substitui a revisão por task (/sdd-07). Requer suporte a subagentes na plataforma.
---

# Execução paralela

## Objetivo

Implementar **tasks independentes da mesma fase** em paralelo via subagentes, sem perder gates nem revisão por task.

> **Suporte por plataforma:** depende de subagentes (`Task`). Se a plataforma não tiver (ver `using-sdd/references/*-tools.md`), execute **sequencialmente** via `/sdd-06-execute`.

## Pré-condições (todas obrigatórias)

| # | Condição |
|---|----------|
| 1 | Plano aprovado via `/sdd-05-review` |
| 2 | Fase em `tasks.md` com coluna **Paralelo? = sim** |
| 3 | Colunas **Onde** disjuntas — sem overlap de arquivos entre tasks paralelas |
| 4 | Dev aprovou explicitamente execução paralela |
| 5 | Nenhuma task paralela toca build files, migrations ou config compartilhada crítica |

Se houver overlap → executar **sequencial** via `/sdd-06-execute`.

## Quando invocar

`/sdd-06-execute` detecta fase com `Paralelo?=sim` e pergunta ao dev:

> "Executar {T01 ∥ T02} em paralelo (subagentes isolados)?"

- **Sim** → esta skill
- **Não** → sequencial, uma task por vez

## Fluxo

```
1. Validar elegibilidade (Onde disjunto, plano aprovado)
2. Montar pacote por task (prompt-task.md + Context pack + Steps de tasks.md)
3. Dispatch via Task — 1 subagente por task (NUNCA 2 no mesmo arquivo)
4. Aguardar todos; coletar summaries
5. git diff — detectar conflitos ou edições inesperadas
6. Se conflito → parar; resolver sequencialmente ou pedir ao dev
7. Gate iterativo da fase via skill verification (uma vez)
8. /sdd-07-task-review POR TASK (sequencial, dois estágios cada)
```

## Pacote por subagente

Usar o template [`prompt-task.md`](./prompt-task.md). Incluir **texto integral** da task — o subagente **não** deve ler `tasks.md` sozinho.

## Status do subagente

| Status | Ação |
|--------|------|
| DONE | Integrar diff; seguir para revisão |
| DONE_WITH_CONCERNS | Ler concerns; avaliar antes de integrar |
| NEEDS_CONTEXT | Fornecer contexto; re-dispatch |
| BLOCKED | Escalar ao dev; não forçar retry igual |

## Red flags

- Paralelizar tasks com mesmo arquivo ou pacote em refactor amplo
- Pular `/sdd-07-task-review` por task após paralelo
- Confiar no report do subagente — verificar diff + `verification`
- Dois implementadores editando o mesmo path

## Após integração

1. Registrar em `executions.md` por task: implementação paralela, arquivos alterados.
2. Invocar **`verification`** — gate iterativo da fase.
3. Para cada task: **`/sdd-07-task-review`** (Estágio 1 → Estágio 2).

## Saída esperada

Tasks da fase implementadas sem conflito; gate da fase verificado; revisões por task pendentes ou aprovadas.
