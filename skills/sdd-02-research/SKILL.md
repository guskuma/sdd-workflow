---
name: sdd-02-research
description: >-
  Fase Research do SDD: mapeia o As Is do código e da documentação. Use com /sdd-02-research
  ou quando o usuário pedir research, investigação de contexto ou estado atual antes de
  especificar uma mudança.
---

# SDD — Research

## Objetivo

Documentar **como é hoje** (As Is) na spec ativa. Não propor solução ainda.

## Contexto do projeto

Consultar o `AGENTS.md` — seção **Mapa de research (As Is)** para paths de código, docs e configuração.

## Pré-requisitos

- Pasta da spec em `specs/YYYY-MM-{ISSUE-KEY-ou-slug}/` com `spec.md` (criada via `/sdd-01-new`).
- Issue key no frontmatter (ou `N/A`).

## Passos

1. Ler `spec.md` (título, issue, contexto inicial do dev).
2. Explorar código e docs conforme o mapa em `AGENTS.md`.
3. Preencher em `spec.md`:
   - **§1 As Is**: contexto, comportamento atual, tabela de arquivos/componentes
   - **Lacunas do research**: perguntas ao dev se algo não estiver claro no código
   - Opcional: rascunho de **restrições** observadas (contratos, integrações, stack) para facilitar `/sdd-03-specify` — formalização obrigatória na fase Specify
   - Se o research revelar **≥2 subsistemas independentes** no escopo, registrar em **Lacunas** e antecipar a discussão de **Escopo da entrega** no `/sdd-03-specify`
4. Atualizar `status` no frontmatter para `research`.
5. Resumir no chat: achados principais + perguntas em aberto.

## TDD — aviso de integrações

Se o research identificar integrações excluídas do TDD em `AGENTS.md` e `tdd: true`:

- **Avisar** o dev que TDD nessas áreas fica fora do escopo por padrão (ver `specs/templates/sdd-tdd.md`).
- Sugerir atualizar `tdd_integracao` no frontmatter se o dev quiser incluir.
- Não alterar `tdd_integracao` sem confirmação explícita do dev.

## Regras

- Citar paths reais do projeto.
- Não alterar código.
- Não preencher To Be / goals (fase Specify).
- Se não houver spec, pedir `/sdd-01-new` primeiro.

## Saída esperada

`spec.md` §1 completo e revisável pelo humano; **lacunas e perguntas** listadas no chat. Próximo passo: `/sdd-03-specify`.
