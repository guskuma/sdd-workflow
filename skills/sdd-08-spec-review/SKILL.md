---
name: sdd-08-spec-review
description: >-
  Revisão final da spec SDD: verifica se goals e user stories foram atingidos após todas
  as tasks. Use com /sdd-08-spec-review ao concluir a implementação da spec.
---

# SDD — Revisão da implementação da spec

## Objetivo

Validar se a **spec inteira** foi entregue — não apenas tasks isoladas.

## Contexto do projeto

Gate completo: `AGENTS.md` (seção Gate de qualidade).

## Quando rodar

Após todas as tasks com revisão de código aprovada (`/sdd-07-task-review`).

## Passos

1. Ler `spec.md`: goals, **critérios de sucesso**, non-goals, **restrições**, abordagem escolhida, requisitos funcionais, edge cases, user stories.
2. Ler `executions.md`: todas as tasks devem estar `done` com revisão aprovada.
3. Cruzar spec × código × testes:
   - Cada goal marcado como atendido ou justificado
   - **Critérios de sucesso** verificados ou gap justificado
   - Non-goals respeitados (nada extra entregue)
   - Restrições respeitadas (ver `specs/templates/sdd-restricoes.md` e `AGENTS.md`); violação = reprovar ou exigir atualização da spec com consenso
   - Cada US: critérios de aceite verificáveis
   - Edge cases da tabela testados ou cobertos por testes
4. Rodar o **gate completo** via skill [`verification`](../verification/SKILL.md) (obrigatório — output fresco, não confiar em registro anterior):

   > Use o comando de gate completo definido no `AGENTS.md` (seção Gate de qualidade).

   Registrar o bloco Verificação em `executions.md` (seção "Validação final") com comando, exit code e evidência.
5. Self-review do diff total da feature (escopo do MR/PR).
6. Produzir um **relatório de fechamento** no chat:
   - Goals: OK / pendente
   - Non-goals: OK / violação
   - Restrições: OK / violação
   - US: OK / pendente
   - Edge cases: OK / gap
   - Desvios spec↔código (código sem spec = reprovar; desvio só válido se a spec foi atualizada com consenso)
   - Riscos residuais para o revisor humano do MR/PR
7. Registrar em `executions.md` a seção "Revisão da spec" com data e resultado.
8. Se aprovado: sugerir `/sdd-09-docs` e depois a entrada em `implementation-log.md`.
9. Se reprovado: listar gaps e tasks de correção (novas ou reabrir).

## Regras

- Não substituir o code review humano do MR/PR — complementa o SDD.
- Gap em goal → corrigir antes de docs e merge.

## Saída esperada

Aprovação ou lista de gaps; `executions.md` atualizado; o `status` da spec pode ir a `reviewed` antes de `done`.
