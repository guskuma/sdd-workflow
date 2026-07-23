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

- `status: planned` (plan concluído — inclui gate **plan compliance** do `/sdd-04-plan` §4.4; se Plan em ondas, todas as ondas + `cross` ✅, salvo escalado ao dev).

## Passos

1. Ler `spec.md`, `design.md` (se houver), `tasks.md` / §5.
2. Produzir no chat um **relatório de revisão**:
   - Alinhamento goals ↔ tasks (gaps?)
   - **Abordagem escolhida** (§2) refletida no plano?
   - **Critérios de sucesso** cobertos por tasks?
   - **Escopo da entrega** coerente com o tamanho do plano?
   - Non-goals respeitados no plano?
   - Restrições respeitadas no plano? (ver `specs/templates/sdd-restricoes.md` e `AGENTS.md`)
   - **Global Constraints** presentes e verbatim (quando formato completo)?
   - **Mapa de arquivos** coerente com as colunas **Onde**?
   - **`plan_depth`** (`snippets` \| `contracts`) registrado com critério plausível (§4.0)?
   - Edge cases cobertos por tasks?
   - Riscos / dependências externas (ver `AGENTS.md`)
   - **Suposições não validadas** ou tradeoffs ainda implícitos na spec/plano?
   - Tasks candidatas a paralelo
   - **Plan compliance (04):** passou no gate automático (ou o que ficou aberto após escalação)?
   - **Zero-context:** um subagente conseguiria implementar **só** com Constraints + Mapa + uma task?
3. Checklist para o dev marcar:
   - [ ] Spec reflete o que quero entregar
   - [ ] Abordagem escolhida e escopo da entrega estão claros
   - [ ] Critérios de sucesso são verificáveis no plano
   - [ ] Non-goals estão claros
   - [ ] Restrições estão claras e o plano não as viola
   - [ ] **Global Constraints** + **Mapa de arquivos** + **`plan_depth`** no topo (quando exigido por `tipo`)
   - [ ] Tasks têm DoD mensurável
   - [ ] Tasks têm **Context pack** + **Interfaces** (Consumes/Produces) + **Steps** executáveis (quando exigido por `tipo`)
   - [ ] Steps **bite-sized** (1 ação, alvo 2–5 min; >5 min só com justificativa)
   - [ ] **Iron Law conforme `plan_depth`:**
     - `snippets` → snippet completo + comando + esperado nos steps de código/verificação
     - `contracts` → Interfaces/assinaturas + teste (ou scaffold) completo que trava comportamento + comando/esperado; sem prosa vaga
   - [ ] Thin slice de negócio (se houver) com teste completo mesmo sob `contracts`
   - [ ] Sem placeholders (TBD, "similar à T0X", "adicionar validação" sem o como)
   - [ ] Paralelismo: **Onde** disjunto onde **Paralelo? = sim**
   - [ ] TDD alinhado: `tdd` e `tdd_integracao` no frontmatter condizem com o plano (ver `specs/templates/sdd-tdd.md`)
   - [ ] Aprovo iniciar o Execute
4. Se o formato completo for exigido e faltar Interfaces / Constraints / Mapa / `plan_depth` / Iron Law do modo → **não** sugerir Execute; pedir ajuste no plan primeiro.
5. Se o critério de `plan_depth` parecer errado (ex.: greenfield com `snippets` em tudo, ou fix pontual com `contracts` sem motivo) → **questionar** antes de aprovar.
6. Se o dev pedir ajustes → editar spec/tasks, **não codar** até nova aprovação.
7. Quando aprovado: `status` → `in-review` ou anotar em `executions.md` "Plano aprovado em {data}".

## Regras

- Não implementar código nesta fase.
- Questionar shadow code: task sem rastro em goals/US → remover ou atualizar a spec.
- **Disciplina (Review):** expor suposições e tradeoffs antes do Execute — não deixar o implementador adivinhar. Critérios de sucesso do §2 devem ter caminho de verificação no plano (task, teste ou gate).
- **Disciplina (zero-context):** se o relatório concluir que a task não é executável isolada, bloquear aprovação até o plan corrigir.

## Saída esperada

Aprovação explícita do dev no chat; plano estável para `/sdd-06-execute`.
