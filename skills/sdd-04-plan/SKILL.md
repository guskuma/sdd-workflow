---
name: sdd-04-plan
description: >-
  Fase Plan do SDD: backlog detalhado com dependências, fases, impactos e feature
  flags já decididas no Specify. Ondas só em spec grande (ver references/plan-waves.md).
  Use com /sdd-04-plan.
---

# SDD — Plan

## Objetivo

Backlog executável e **bem fundamentado**: 1 task = 1 entregável, dependências explícitas, fases quando necessário. Premissa **zero-context / bite-sized**: o executor (subagente ou dev) implementa só com a task — sem histórico do chat.

**Iron Law (Steps de código):**

```
NENHUM STEP DE CÓDIGO SEM ARTEFATO EXECUTÁVEL SUFICIENTE PARA O plan_depth
```

- **`snippets`** (default em mudança incremental): snippet **completo** + comando + output esperado.
- **`contracts`** (greenfield / bootstrap): assinaturas (Interfaces) + artefato que trava comportamento (teste completo ou scaffold verificável) + comando + output esperado — **sem** exigir corpo completo de todo módulo no Plan.

(Quando Context pack + Steps forem obrigatórios para o `tipo` — ver [`references/plan-task-format.md`](./references/plan-task-format.md) e [`references/plan-depth.md`](./references/plan-depth.md).)

## Contexto do projeto

Consultar o `AGENTS.md` para: gate iterativo, feature flags, integrações, subsistemas e restrições padrão.

Se o plano incluir schema, migrations ou indexes **PostgreSQL** → invocar **`postgresql-table-design`** ao detalhar Steps de DDL (tipos, FK+index, evolução segura).

## Entregável

- Análise de consequências intencionais e não intencionais
- Feature flag já decidida no Specify, detalhada em task (sem editar `AGENTS.md`)
- `tasks.md` se ≥ 5 tarefas **com fases de implementação**; senão, tasks em `spec.md` §5
- **Global Constraints**, **Mapa de arquivos**, **`plan_depth`**, tasks com **Interfaces** + Context pack + Steps (quando exigido)
- Dependências e paralelismo explícitos
- `executions.md` inicializado
- Plan em ondas só quando [`references/plan-waves.md`](./references/plan-waves.md) exigir

Ao final: `/sdd-05-review` antes de `/sdd-06-execute`.

## Escopo do SDD

Aplica-se a **qualquer mudança** rastreável em spec. Ajustar a profundidade do plano ao `tipo` no frontmatter de `spec.md`.

## Pré-requisitos

- `spec.md` com To Be confirmado (`status: specified`).
- Dev confirmou entendimento na fase Specify.

## Postura do agente (obrigatório)

- Seja **detalhista**: aponte arquivos, classes e métodos; **mostre trechos de código** quando isso tornar o plano mais claro.
- Assuma executor **habilidoso** mas **sem contexto** do chat/domínio/tooling e com gosto de teste/design **a orientar** (Steps mostram o como).
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

### 2.1. TDD

`tdd` e `tdd_integracao` já foram decididos no `/sdd-03-specify`. Não reabrir.

- `tdd: tbd` → **parar** e voltar ao 03.
- `tdd: true` → skill **`tdd`**. DoD e Steps na ordem teste falhando → implementação mínima → refactor. Integração com `tdd_integracao: fora` não exige test-first.
- `tdd: false` → não impor test-first. O gate do `AGENTS.md` continua.

### 3. Feature flags

Ler `feature_flag` do frontmatter. A decisão é do `/sdd-03-specify`. Este passo só detalha a task. Não editar `AGENTS.md` (isso é pergunta do `/sdd-08-docs`).

| Valor | Ação |
|-------|------|
| `sim` | Task de flag conforme `AGENTS.md` § Feature flags (mecanismo, nome, default, path). Se o § estiver vazio, documentar o combinado no 03 em `tasks.md` e seguir. |
| `nao` | **"Feature flag: N/A"** em `tasks.md`, com a justificativa do Specify. |
| `tbd` ou ausente | **Parar** e voltar ao 03. Spec legada sem o campo: tratar como `nao` e anotar. |

### 4. Quebra em tasks

**Antes** de listar as tasks (nesta ordem):

1. **Global Constraints** — bullets com valores **verbatim** da spec §2 (restrições) + restrições padrão do `AGENTS.md` que se aplicam a **todas** as tasks. O Context pack referencia; não redescobre.
2. **Mapa de arquivos** — tabela path → responsabilidade (criar/modificar/teste). Trava o corte das tasks: arquivos que mudam juntos ficam na mesma task ou com Interfaces explícitas; preferir arquivos focados.
3. **`plan_depth`** — decidir e registrar conforme [`references/plan-depth.md`](./references/plan-depth.md) **antes** de escrever Steps.
4. Só então decompor em tasks.

- Cada task: entregável verificável (classe, endpoint, teste, flag, doc) — menor unidade com ciclo de teste + review próprio.
- Campos: **Onde**, **Depende de**, **Bloqueia**, **Interfaces**, **DoD**, RF/US vinculada; opcional **Profundidade** (override de `plan_depth`).
- O DoD padrão inclui o gate iterativo de `AGENTS.md`.
- Tasks alinhadas à **abordagem escolhida** em `spec.md` §2 (Abordagens consideradas).
- O DoD pode referenciar os **critérios de sucesso** da spec quando aplicável.
- Toda task rastreável a um goal ou US da spec.

**Quantidade:**

| Tasks | Onde documentar |
|-------|-----------------|
| < 5 | `spec.md` §5 |
| ≥ 5 | `tasks.md` (`specs/templates/tasks-template.md`) + referência em §5 |

**Mais de 5 tasks:** organizar em **fases de implementação** (Fase 1, Fase 2, …) respeitando dependências. Cada fase = conjunto executável via `/sdd-06-execute`. Fase não liga onda. Onda só pelos gatilhos de [`references/plan-waves.md`](./references/plan-waves.md).

### 4.0 a 4.4 — ler a referência e seguir

Não escrever Steps, não abrir onda e não rodar o gate de memória. Ler o arquivo e seguir integralmente.

| Passo | Arquivo |
|-------|---------|
| `plan_depth` e a frase permitida de `contracts` | [`references/plan-depth.md`](./references/plan-depth.md) |
| Formato da task (Context pack, Interfaces, Steps) | [`references/plan-task-format.md`](./references/plan-task-format.md) |
| Ondas (só se um gatilho de lá casar) | [`references/plan-waves.md`](./references/plan-waves.md) |
| Self-review + compliance | [`references/plan-review.md`](./references/plan-review.md) |

Prompts de subagente: [`prompt-plan-phase.md`](./prompt-plan-phase.md), [`prompt-plan-compliance.md`](./prompt-plan-compliance.md).

**Se ondas aplicarem:** nesta etapa, só o skeleton (Constraints + Mapa + `plan_depth` + tabela de Fases). O detalhe das tasks segue `plan-waves.md`.

### 5. Plano de execução

- Grafo de dependências (texto ou mermaid).
- O que pode rodar em **paralelo** — skill `parallel-execution` quando **Paralelo? = sim** e **Onde** disjunto.
- Ordem sugerida de `/sdd-06-execute` ou `parallel-execution` por fase.

### 6. Finalização

1. Gate de [`references/plan-review.md`](./references/plan-review.md) ✅ no escopo final (`cross` se ondas; senão o review monólito) — ou escalado ao dev (aí **não** avançar sozinho).
2. Criar/atualizar `executions.md` (tasks `pending`, coluna Fase se ≥ 5 tasks).
3. Preencher a seção **Plan compliance** de `executions.md`: ✅ por escopo (`skeleton` / `fase-N` / `cross` / monólito) + iters, ou `escalado`.
4. Atualizar § Progresso do Plan → todas as ondas ✅ (se ondas estiverem desligadas, a tabela pode ficar ausente).
5. `status` → `planned` **somente** após o gate de `plan-review.md` ✅ no escopo final.
6. Sugerir `/sdd-05-review`.

## Desvios e shadow code

Se o plano exigir algo **fora** dos goals/non-goals da spec ou que **viole restrições** (ver `specs/templates/sdd-restricoes.md` e `AGENTS.md`): **parar**, explicar ao dev e só incluir após **consenso** e atualização de `spec.md` (voltar a Specify se necessário).

## Saída esperada

Plano com self-review + gate plan-compliance por escopo (ondas quando aplicável); `tasks.md` ou §5 + `executions.md`; pronto para review **humano** (`/sdd-05-review`).