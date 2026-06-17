---
name: sdd-03-specify
description: >-
  Fase Specify do SDD: define To Be, goals, critérios de sucesso, abordagens, non-goals,
  restrições e edge cases; auto-revisão e confirmação com o dev. Use com /sdd-03-specify.
---

# SDD — Specify

## Objetivo

Definir **o que deve existir** (To Be). Tudo que for implementado depois precisa estar aqui.

## Contexto do projeto

Restrições padrão do repositório: `AGENTS.md`. Convenção geral: `specs/templates/sdd-restricoes.md`.

## Pré-requisitos

- `spec.md` com §1 As Is preenchido (research feito).
- Skill `/sdd-02-research` concluída ou §1 já válido.

## Passos

1. Ler §1 As Is e o pedido do dev.
2. Preencher **§2 To Be** (ver matriz por `tipo` no final):
   - Resumo, goals, **critérios de sucesso**, non-goals, **restrições**, **abordagens consideradas**, **escopo da entrega**, RF, edge cases
   - **Restrições:** incluir as padrão de `AGENTS.md` + específicas da spec
3. **Abordagens (2–3 opções)** — quando a matriz exigir:
   - Comparar caminhos plausíveis na tabela; indicar **recomendação** e marcar **escolhida** após alinhamento com o dev
   - Se só um caminho razoável: `N/A — abordagem única` + justificativa em uma frase
4. **Gate de decomposição** — após esboçar o To Be:
   - Se goals/RF indicarem escopo grande (≥2 subsistemas independentes ou entregáveis desacoplados), propor divisão em **Escopo da entrega**
   - Não definir `status: specified` sem decisão explícita do dev (uma spec, N specs ou fases)
5. **Uma pergunta por vez** — para lacunas em RF, edge cases, restrições ou abordagens; preferir múltipla escolha; não enviar várias perguntas na mesma mensagem
6. Preencher **§4 User stories** (Como/Quero/Para + critérios de aceite)
7. Se a complexidade for alta: criar `design.md` (`specs/templates/design-template.md`) → fluxo **incremental** (blocos 1–3 com OK do dev); linkar em §3
8. **Auto-revisão da spec** — preencher o checklist **Revisão da spec (Specify)** em §2; corrigir inline; itens críticos em aberto impedem a confirmação
9. **Confirmação de entendimento** (obrigatório):
   - Paráfrase em §2; perguntar: "Está correto? O que ajustar?"
   - **Não** sugerir `/sdd-04-plan` até o dev confirmar
10. `status` → `specified` somente após confirmação do dev **e** auto-revisão sem itens críticos em aberto

## Por quê?

Se o To Be revelar escopo diferente do registrado em **Por quê?**, refinar com confirmação do dev.

## TDD — reavaliação de integrações

Se o To Be incluir integrações excluídas do TDD em `AGENTS.md` e `tdd: true`:

- Reavaliar `tdd_integracao` e **avisar** o dev (ver `specs/templates/sdd-tdd.md`).
- Registrar a decisão no frontmatter antes de avançar para o Plan.

## Regras

- **Non-goals** e **restrições** obrigatórios (ver `specs/templates/sdd-restricoes.md`).
- **Critérios de sucesso** obrigatórios exceto `chore`/`docs` (opcional, 1 linha).
- Não duplicar o mesmo item em non-goals e restrições sem necessidade.
- Sem código de produção nesta fase.
- Solução que violaria restrição → parar, alinhar com o dev, ajustar a spec antes do Plan.

## Saída esperada

`spec.md` §2 e §4 completos; auto-revisão feita; confirmação humana registrada.

## Matriz por `tipo` (profundidade)

| `tipo` | Abordagens 2–3 | Critérios de sucesso | Auto-revisão | Decomposição | Design incremental |
|--------|----------------|----------------------|--------------|--------------|-------------------|
| `feat` | Sim se houver escolha | Obrigatório | Completa | Se escopo grande | Se `design.md` |
| `refactor` | Sim se houver escolha | Obrigatório | Completa | Se escopo grande | Se `design.md` |
| `fix` | N/A se caminho único | Recomendado (1–2 itens) | Completa | Se escopo grande | Raro |
| `perf` | Se houver trade-off | Obrigatório | Completa | Se escopo grande | Se `design.md` |
| `chore` / `docs` | N/A | Opcional (1 linha) | Leve (placeholders + escopo) | Se escopo grande | Não |

**Auto-revisão leve:** apenas placeholders/TBD e escopo da entrega.
