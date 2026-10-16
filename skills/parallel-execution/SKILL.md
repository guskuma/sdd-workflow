---
name: parallel-execution
description: >-
  Execução paralela de tasks SDD independentes via subagentes. Invocar quando tasks.md
  marcar Paralelo?=sim para a fase e o dev aprovar dispatch paralelo em /sdd-06-execute.
  Após integração, o loop de revisão por task fica a cargo do /sdd-06-execute.
  Requer suporte a subagentes na plataforma.
---

# Execução paralela

## Objetivo

Implementar **tasks independentes da mesma fase** em paralelo via subagentes, sem perder gates nem revisão por task.

> **Suporte por plataforma:** depende de subagentes (`Task`). Se a plataforma não tiver (ver `using-sdd/references/*-tools.md`), execute **sequencialmente** via `/sdd-06-execute`.

> Se o `/sdd-06-execute` ativou **`worktrees`**, os subagentes devem operar no mesmo CWD/worktree isolado.

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
2. Montar pacote por task (prompt-implement.md canônico + Context pack + Interfaces + Steps + Global Constraints)
3. Dispatch via Task — 1 subagente por task (NUNCA 2 no mesmo arquivo); guardar handle/id de cada um
4. Aguardar todos; coletar summaries
5. git diff — detectar conflitos ou edições inesperadas
6. Se conflito → parar; resolver sequencialmente ou pedir ao dev
7. Gate iterativo da fase via skill verification (uma vez)
8. Loop de revisão do /sdd-06-execute POR TASK (sequencial; retomada do implementador e do revisor **daquela** task — ver sdd-06-execute)
```

**Retomada no paralelo:** o fix retoma o **implementador daquela task**; o review retoma o **revisor daquela task**. Nunca um implementador ou revisor compartilhado entre tasks paralelas.

## Pacote por subagente

Usar o template canônico [`../sdd-06-execute/prompt-implement.md`](../sdd-06-execute/prompt-implement.md). [`prompt-task.md`](./prompt-task.md) só aponta para ele. Incluir **texto integral** da task (Context pack + Interfaces + Steps) e Global Constraints — o subagente **não** deve ler `tasks.md` sozinho.

## Status do subagente

| Status | Ação |
|--------|------|
| DONE | Integrar diff; seguir para revisão |
| DONE_WITH_CONCERNS | Ler concerns; avaliar antes de integrar |
| NEEDS_CONTEXT | Fornecer o que faltou; **retomar** o mesmo implementador (re-dispatch integral só no fallback) |
| BLOCKED | Escalar ao dev; não forçar retry igual |

## Red flags

- Paralelizar tasks com mesmo arquivo ou pacote em refactor amplo
- Pular o loop de revisão do `/sdd-06-execute` por task após paralelo
- Confiar no report do subagente — verificar diff + `verification`
- Dois implementadores editando o mesmo path
- Um revisor/implementador compartilhado entre tasks paralelas

## Após integração

1. Invocar **`verification`** — gate iterativo da fase.
2. Para cada task: executar o **loop de revisão** de `/sdd-06-execute` (Estágio 1 → Estágio 2 no mesmo revisor → **receiving-review** → retomar implementador no fix; máx. 5 iterações; retomada conforme `sdd-06-execute`).
3. **Só ao concluir** cada task: registrar em `executions.md` (implementação paralela, arquivos, revisão final, linha **Retomada:**).

## Saída esperada

Tasks da fase implementadas sem conflito; gate da fase verificado; revisões por task concluídas (aprovadas ou escaladas ao dev).
