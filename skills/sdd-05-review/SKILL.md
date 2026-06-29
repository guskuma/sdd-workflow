---
name: sdd-05-review
description: >-
  Revisão humana do plano SDD antes da implementação. Use com /sdd-05-review ou quando o
  dev pedir review do plano, das tasks ou da spec antes de codar.
---

# SDD — Review (humano no loop)

## Objetivo

O **desenvolvedor revisa** spec + plano. O agente facilita, não aprova sozinho.

## Contexto do projeto

Dependências externas e integrações: `AGENTS.md`.

## Pré-requisitos

- `status: planned` (plan concluído).

## Passos

1. Ler `spec.md`, `design.md` (se houver), `tasks.md` / §5.
2. Produzir no chat um **relatório de revisão**:
   - Alinhamento goals ↔ tasks (gaps?)
   - **Abordagem escolhida** (§2) refletida no plano?
   - **Critérios de sucesso** cobertos por tasks?
   - **Escopo da entrega** coerente com o tamanho do plano?
   - Non-goals respeitados no plano?
   - Restrições respeitadas no plano? (ver `specs/templates/sdd-restricoes.md` e `AGENTS.md`)
   - Edge cases cobertos por tasks?
   - Riscos / dependências externas (ver `AGENTS.md`)
   - **Suposições não validadas** ou tradeoffs ainda implícitos na spec/plano?
   - Tasks candidatas a paralelo
3. Checklist para o dev marcar:
   - [ ] Spec reflete o que quero entregar
   - [ ] Abordagem escolhida e escopo da entrega estão claros
   - [ ] Critérios de sucesso são verificáveis no plano
   - [ ] Non-goals estão claros
   - [ ] Restrições estão claras e o plano não as viola
   - [ ] Tasks têm DoD mensurável
   - [ ] Tasks têm **Context pack** + **Steps** executáveis (quando exigido por `tipo`)
   - [ ] Paralelismo: **Onde** disjunto onde **Paralelo? = sim**
   - [ ] TDD alinhado: `tdd` e `tdd_integracao` no frontmatter condizem com o plano (ver `specs/templates/sdd-tdd.md`)
   - [ ] Aprovo iniciar o Execute
4. Se o dev pedir ajustes → editar spec/tasks, **não codar** até nova aprovação.
5. Quando aprovado: `status` → `in-review` ou anotar em `executions.md` "Plano aprovado em {data}".

## Regras

- Não implementar código nesta fase.
- Questionar shadow code: task sem rastro em goals/US → remover ou atualizar a spec.
- **Disciplina (Review):** expor suposições e tradeoffs antes do Execute — não deixar o implementador adivinhar. Critérios de sucesso do §2 devem ter caminho de verificação no plano (task, teste ou gate).

## Saída esperada

Aprovação explícita do dev no chat; plano estável para `/sdd-06-execute`.
