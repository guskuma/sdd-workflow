---
name: sdd-03-specify
description: >-
  Fase Specify do SDD: define To Be, goals, critérios de sucesso, abordagens, non-goals,
  restrições e edge cases; auto-revisão e confirmação com o dev. Use com /sdd-03-specify.
---

# SDD — Specify

## Objetivo

Definir **o que deve existir** (To Be). Tudo que for implementado depois precisa estar aqui.

**Iron Law:**

```
NENHUM PLAN NEM CÓDIGO ATÉ CONFIRMAÇÃO EXPLÍCITA DO TO BE PELO DEV
```

## Anti-padrão: "É simples demais para especificar"

Toda mudança rastreável passa por Specify — mesmo ajuste de uma função ou config. Specs “simples” são onde pressupostos não examinados mais geram rework. O To Be pode ser curto (poucas frases), mas **deve** existir, passar pela auto-revisão e ser confirmado.

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
   - Apresentar trade-offs de forma conversacional; liderar com a recomendação e o porquê
4. **Gate de decomposição** — após esboçar o To Be:
   - Se goals/RF indicarem escopo grande (≥2 subsistemas independentes ou entregáveis desacoplados), propor divisão em **Escopo da entrega**
   - Não definir `status: specified` sem decisão explícita do dev (uma spec, N specs ou fases)
5. **Uma pergunta por vez** — para lacunas em RF, edge cases, restrições ou abordagens; preferir múltipla escolha; não enviar várias perguntas na mesma mensagem
6. Preencher **§4 User stories** (Como/Quero/Para + critérios de aceite)
7. Se a complexidade for alta: criar `design.md` (`specs/templates/design-template.md`) → fluxo **incremental** (blocos 1–3 com OK do dev após cada bloco); linkar em §3
   - Cobrir conforme a complexidade: arquitetura, componentes, fluxo de dados, erros, teste
   - Unidades com um propósito claro e interfaces definidas; não propor refactor não relacionado ao goal
8. **Auto-revisão da spec** — preencher o checklist **Revisão da spec (Specify)** em §2; corrigir inline; itens críticos em aberto impedem a confirmação
   - Checar também: placeholders/TBD, contradições entre seções, ambiguidade em RF/critérios, escopo inchado vs non-goals
9. **Confirmação de entendimento** (obrigatório):
   - Paráfrase em §2; perguntar: "Está correto? O que ajustar?"
   - **Não** sugerir `/sdd-04-plan` até o dev confirmar
10. `status` → `specified` somente após confirmação do dev **e** auto-revisão sem itens críticos em aberto

## Por quê?

Se o To Be revelar escopo diferente do registrado em **Por quê?**, refinar com confirmação do dev.

## TDD — reavaliação de integrações

Se o To Be incluir integrações excluídas do TDD em `AGENTS.md` e `tdd: true`:

- Reavaliar `tdd_integracao` e **avisar** o dev (ver `specs/templates/sdd-tdd.md` e skill **`tdd`**).
- Registrar a decisão no frontmatter antes de avançar para o Plan.

## Regras

- **Non-goals** e **restrições** obrigatórios (ver `specs/templates/sdd-restricoes.md`).
- **Critérios de sucesso** obrigatórios exceto `chore`/`docs` (opcional, 1 linha).
- Não duplicar o mesmo item em non-goals e restrições sem necessidade.
- Sem código de produção nesta fase.
- Solução que violaria restrição → parar, alinhar com o dev, ajustar a spec antes do Plan.
- **Disciplina (Specify):** não assumir lacunas — perguntar. Abordagens com tradeoffs explícitos na tabela. **Critérios de sucesso** mensuráveis e verificáveis (comando, comportamento observável ou gate do `AGENTS.md`) — não vagos (“funciona bem”).

## Red flags — parar

| Racionalização | Realidade |
|----------------|-----------|
| "É óbvio, vamos pro plan" | Confirmação do To Be é obrigatória |
| "Spec curta não precisa de auto-revisão" | Placeholders e contradições nascem aí |
| "Já perguntei tudo de uma vez" | Uma pergunta por mensagem |
| "Design depois, na implementação" | Se a complexidade pediu `design.md`, fechar blocos aqui |

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
