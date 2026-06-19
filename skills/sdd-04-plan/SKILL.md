---
name: sdd-04-plan
description: >-
  Fase Plan do SDD: backlog detalhado com dependências, fases, impactos, feature flags
  e boas práticas. Use com /sdd-04-plan. Válido para feat, fix, refactor e mudanças de
  comportamento.
---

# SDD — Plan

## Objetivo

Backlog executável e **bem fundamentado**: 1 task = 1 entregável, dependências explícitas, fases quando necessário.

## Contexto do projeto

Consultar o `AGENTS.md` para: gate iterativo, feature flags, integrações, subsistemas e restrições padrão.

## Entregável

- Análise de consequências intencionais e não intencionais
- Reavaliação de feature flag (ou N/A justificado); opt-in para atualizar `AGENTS.md` quando § Feature flags vazio
- `tasks.md` se ≥ 5 tarefas **com fases de implementação**; senão, tasks em `spec.md` §5
- Dependências e paralelismo explícitos
- `executions.md` inicializado

Ao final: `/sdd-05-review` antes de `/sdd-06-execute`.

## Escopo do SDD

Aplica-se a **qualquer mudança** rastreável em spec. Ajustar a profundidade do plano ao `tipo` no frontmatter de `spec.md`.

## Pré-requisitos

- `spec.md` com To Be confirmado (`status: specified`).
- Dev confirmou entendimento na fase Specify.

## Postura do agente (obrigatório)

- Seja **detalhista**: aponte arquivos, classes e métodos; **mostre trechos de código** quando isso tornar o plano mais claro.
- Se houver **dúvidas**, **pergunte ao dev antes** de fechar o plano.
- **Não tenha pressa**: analise o código e a spec com calma.
- **Revise** achados e propostas antes de entregar.
- Não implementar código nesta fase.

## Passos

### 1. Análise de impacto

Para cada mudança proposta, documentar no chat e em `tasks.md` / §5:

| Mudança | Consequências intencionais | Consequências não intencionais (riscos) |
|---------|---------------------------|----------------------------------------|
| ... | ... | ... |

Considerar dependências externas e subsistemas listados em `AGENTS.md` (integrações, persistência, deploy, rollback).

### 2. Boas práticas de engenharia

- Responsabilidade única, SOLID quando pertinente, sem over-engineering.
- Tratamento de erros e edge cases da spec.
- Tarefas possíveis de **paralelizar** só quando **não houver dependência** real.

### 2.1. TDD (se `tdd: true` no frontmatter)

Seguir `specs/templates/sdd-tdd.md` e as integrações em `AGENTS.md`:

- O DoD das tasks deve incluir a ordem explícita: **teste falhando → implementação mínima → refactor**.
- Respeitar `tdd_integracao`: integrações excluídas em `AGENTS.md` → **avisar o dev** e não exigir test-first nessas áreas.
- Se o dev optar por incluir integrações no TDD durante o plan, atualizar `spec.md` antes de fechar as tasks.

### 3. Feature flags

Ler `feature_flag` do frontmatter de `spec.md`:

| Valor | Ação |
|-------|------|
| `sim` | **Reavaliar** com o dev: impactos, complexidade adicional, consequências intencionais e não intencionais. Confirmar ou ajustar antes de detalhar flag. |
| `nao` | Registrar **"Feature flag: N/A"** em `tasks.md` com justificativa (decisão do New). |
| `tbd` | Conduzir decisão com a mesma análise; atualizar frontmatter após alinhamento. |
| ausente (legado) | Avaliar "quando condizente" (comportamento legado). |

**Consultar `AGENTS.md` § Feature flags** (mecanismo, convenção, default, path).

**Se § Feature flags vazio, placeholder ou `N/A` genérico** e a spec confirmar uso de flag (`sim`/`tbd`):

1. **Perguntar** ao dev: mecanismo, convenção de nome, default seguro, path/registro no código.
2. **Perguntar explicitamente:** "Deseja que eu **atualize o `AGENTS.md`** com esse padrão?"
3. **Só alterar `AGENTS.md`** após **confirmação expressa** do dev.
4. Se o dev **recusar** atualizar: documentar o padrão apenas em `tasks.md` § Feature flag (spec corrente); **não** modificar `AGENTS.md`.

Quando confirmado `sim`:

- Propor nome/default/task conforme padrão do `AGENTS.md` (ou o informado no passo 1).
- Documentar em `tasks.md` § Feature flag.
- Atualizar frontmatter se decisão mudar após reavaliação.

### 4. Quebra em tasks

- Cada task: entregável verificável (classe, endpoint, teste, flag, doc).
- Campos: **Onde**, **Depende de**, **Bloqueia**, **DoD**, RF/US vinculada.
- O DoD padrão inclui o gate iterativo de `AGENTS.md`.
- Tasks alinhadas à **abordagem escolhida** em `spec.md` §2 (Abordagens consideradas).
- O DoD pode referenciar os **critérios de sucesso** da spec quando aplicável.
- Toda task rastreável a um goal ou US da spec.

**Quantidade:**

| Tasks | Onde documentar |
|-------|-----------------|
| < 5 | `spec.md` §5 |
| ≥ 5 | `tasks.md` (`specs/templates/tasks-template.md`) + referência em §5 |

**Mais de 5 tasks:** organizar em **fases de implementação** (Fase 1, Fase 2, …) respeitando dependências. Cada fase = conjunto executável via `/sdd-06-execute`.

### 4.1 Formato executável (Context pack + Steps)

Cada task deve permitir execução por **engenheiro sem contexto do chat** (agente, subagente ou dev novo no repo).

**Obrigatório** para: `feat`, `refactor`, `perf`; `fix` com >1 arquivo.
**Opcional** (só DoD + checklist curto): `chore`, `docs`, `fix` pontual em 1 arquivo.

Por task em `tasks.md` (ou §5 se < 5 tasks):

| Seção | Conteúdo |
|-------|----------|
| **Context pack** | Spec (goal/US), restrições relevantes, padrão do repo, arquivos vizinhos, **Não fazer** |
| **Steps** | Passos de **2–10 min** com paths exatos, snippets completos, comandos do projeto e output esperado (FAIL/PASS) |

**Proibido nos Steps** (falha de plano — corrigir antes de `/sdd-05-review`):

- TBD, TODO, "implementar depois"
- "Adicionar validação" / "tratar edge cases" sem código ou comando
- "Similar à T02" sem repetir o código (tasks podem ser lidas fora de ordem)
- Steps que descrevem o quê sem mostrar o como (code blocks obrigatórios em steps de código)

**TDD (`tdd: true`):** os Steps devem incluir a ordem red → green → refactor por task; respeitar `tdd_integracao` em `AGENTS.md`.

**Paralelismo:** coluna **Paralelo com** só se **Onde** for disjunto; marcar **Paralelo? = sim** na tabela de fases.

### 4.2 Self-review do plano

Antes de finalizar:

1. **Cobertura da spec:** cada RF/US tem task (e Step) correspondente?
2. **Scan de placeholders:** nenhum item da lista proibida acima?
3. **Consistência:** nomes de classes/métodos iguais entre tasks?
4. **Executabilidade:** alguém só com `tasks.md` consegue implementar sem abrir o chat?

Corrigir inline; gaps críticos impedem `status: planned`.

### 5. Plano de execução

- Grafo de dependências (texto ou mermaid).
- O que pode rodar em **paralelo** — skill `parallel-execution` quando **Paralelo? = sim** e **Onde** disjunto.
- Ordem sugerida de `/sdd-06-execute` ou `parallel-execution` por fase.

### 6. Finalização

1. Criar/atualizar `executions.md` (tasks `pending`, coluna Fase se ≥ 5 tasks).
2. `status` → `planned`.
3. Sugerir `/sdd-05-review`.

## Desvios e shadow code

Se o plano exigir algo **fora** dos goals/non-goals da spec ou que **viole restrições** (ver `specs/templates/sdd-restricoes.md` e `AGENTS.md`): **parar**, explicar ao dev e só incluir após **consenso** e atualização de `spec.md` (voltar a Specify se necessário).

## Saída esperada

Plano revisado pelo agente; `tasks.md` ou §5 + `executions.md`; impactos e flags documentados; pronto para review humano.
