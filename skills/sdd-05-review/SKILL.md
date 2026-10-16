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

- `status: planned` (plan concluído — inclui o gate de `skills/sdd-04-plan/references/plan-review.md`; se Plan em ondas, todas as ondas + `cross` ✅, salvo escalado ao dev).

## Passos

1. Ler `spec.md`, `design.md` (se houver), `tasks.md` / §5.
2. Produzir no chat um **relatório de revisão** do produto, não uma segunda auditoria do gate:
   - Alinhamento goals ↔ tasks (falta o resultado certo, sobra escopo?)
   - **Abordagem escolhida** (§2) ainda é a que o plano executa?
   - **Critérios de sucesso** descrevem o resultado certo?
   - **Escopo da entrega** cabe neste plano?
   - Non-goals e restrições respeitados? (ver `specs/templates/sdd-restricoes.md` e `AGENTS.md`)
   - Edge cases e riscos externos (`AGENTS.md`) fazem sentido?
   - Suposições e tradeoffs ainda implícitos?
   - Tasks candidatas a paralelo que o plano marcou sequenciais, ou o inverso?
   - **Plan compliance:** gate de `skills/sdd-04-plan/references/plan-review.md` ✅ em quais escopos, ou o que ficou escalado?
3. Checklist para o dev marcar:
   - [ ] Spec reflete o que quero entregar
   - [ ] Abordagem escolhida e escopo da entrega estão claros
   - [ ] Critérios de sucesso descrevem o resultado certo
   - [ ] Non-goals e restrições estão claros e o plano não os viola
   - [ ] Edge cases, riscos e tradeoffs estão explícitos
   - [ ] Gate de plan compliance ✅ (ou a escalação está aceita)
   - [ ] `tdd` e `tdd_integracao` são os do Specify, e o plano não os reabre
   - [ ] Aprovo iniciar o Execute
4. Sem ✅ do plan compliance no escopo final → não sugerir Execute.
5. Se o critério de `plan_depth` parecer errado → questionar antes de aprovar. Isso reabre o gate (passo 6).
6. Se o dev pedir ajustes → editar spec/tasks, **não codar**.
   - Edição em **Steps**, **Interfaces**, **Mapa de arquivos** ou **`plan_depth`**: `status` permanece `planned`. Rodar de novo o gate de [`plan-review.md`](../sdd-04-plan/references/plan-review.md) no escopo tocado. Sem ✅, não gravar `approved`.
   - Edição só de goal, US ou non-goal, sem esses campos: não rerodar o gate.
7. Quando o dev aprovar por escrito no chat, gravar os dois:
   - `spec.md`: `status: approved` (obrigatório — anotação só em `executions.md` não libera o Execute)
   - `executions.md`: "Plano aprovado em {data}"
   - Não gravar `in-review`. Spec antiga com `in-review` → reescrever para `approved` nesta aprovação.

## Regras

- Não implementar código nesta fase.
- Questionar shadow code: task sem rastro em goals/US → remover ou atualizar a spec.
- **Disciplina (Review):** expor suposições e tradeoffs antes do Execute — não deixar o implementador adivinhar. Critérios de sucesso do §2 devem ter caminho de verificação no plano (task, teste ou gate).
- **Disciplina (zero-context):** se o relatório concluir que a task não é executável isolada, bloquear aprovação até o plan corrigir.
- Sem `status: approved`, não sugerir `/sdd-06-execute`.

## Red flags

| Racionalização | Realidade |
|----------------|-----------|
| "O dev concordou no chat; anoto e sigo" | Sem `status: approved` o Execute recusa |
| "`in-review` já comunica aprovação" | O valor vigente é `approved` |
| "Ajustei Steps e já aprovei" | Steps, Interfaces, mapa ou `plan_depth` rerodam o gate antes de `approved` |

## Saída esperada

Aprovação explícita do dev no chat; `status: approved`; plano estável para `/sdd-06-execute`.
