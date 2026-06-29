---
name: sdd-06-execute
description: >-
  Fase Execute do SDD: pergunta se o dev quer planejar antes de codar (Plan mode, se a
  plataforma suportar), implementa a task/fase e roda o gate de qualidade. Use com
  /sdd-06-execute.
---

# SDD — Execute

## Objetivo

Implementar **apenas** o plano aprovado (task única ou **fase** com várias tasks).

## Contexto do projeto

Gates, convenções de código e integrações: `AGENTS.md` (e as rules/convenções do projeto).

Skills transversais: [`debugging`](../debugging/SKILL.md), [`verification`](../verification/SKILL.md), [`parallel-execution`](../parallel-execution/SKILL.md).

## Escopo do SDD

Válido para features, bugs (`fix`), mudanças de comportamento, refactors planejados, etc., conforme `tipo` em `spec.md`.

## Pré-requisitos

- Plano aprovado via `/sdd-05-review`.
- `executions.md` existe.
- Branch da spec criada (se aplicável), registrada nos metadados.
- Tasks com **Context pack** + **Steps** quando exigido em `/sdd-04-plan`.

## Entrada

| Forma | Exemplo |
|-------|---------|
| Task única | `T03` |
| Fase / conjunto | `Fase 1`, `T01,T02,T03` |
| Automático | próxima `pending` em `executions.md` |

## Modo de execução por fase

1. Ler `tasks.md` — coluna **Paralelo?** e **Paralelo com** / **Onde** de cada task.
2. Validar elegibilidade paralela: **Onde** disjunto; sem build files/migrations compartilhadas.
3. Se a fase tiver **Paralelo? = sim** e for elegível:
   - Perguntar: "Executar {T01 ∥ T02} em paralelo (subagentes isolados)?"
   - **Sim** → skill **`parallel-execution`** (se a plataforma suportar subagentes)
   - **Não** → sequencial (fluxo abaixo, uma task por vez)
4. Se **Paralelo? = não** ou overlap de arquivos → sequencial.

Após o paralelo: gate da fase + `/sdd-07-task-review` **por task** (sequencial).

## Planejar antes de codar (obrigatório perguntar)

**Antes de alterar código** (modo sequencial), o agente deve **perguntar ao dev**:

> "Deseja **planejar a execução** desta task/fase antes de implementar?"

### Se o dev responder **sim**

1. Se a plataforma tiver **Plan mode** (ex.: Cursor via `SwitchMode` → `plan`; Claude via plan mode), solicitar a troca (o dev aprova na UI). Se **não** tiver, apenas siga em modo somente-leitura mental: não edite código ainda.
2. Elaborar **micro-plano de execução** no chat:
   - Task(s) e entregáveis
   - Arquivos/classes a alterar (com trechos se útil)
   - Ordem dos passos, testes previstos, riscos
   - O que **não** será feito (escopo da task)
3. Aguardar **aprovação explícita** do micro-plano no chat.
4. Se trocou para Plan mode, voltar para o modo de implementação (o dev aprova).
5. Registrar em `executions.md`: "Plano de execução: aprovado em {data}".
6. Só então implementar.

### Se o dev responder **não**

1. Registrar em `executions.md`: "Plano de execução: dispensado".
2. Seguir os **Steps** de `tasks.md` quando existirem; senão, DoD + spec.
3. Para task **trivial** (ex.: ajuste pontual em 1 arquivo), aceitável; para task complexa, **recomendar** planejar, sem insistir após recusa.

### Se o dev não responder ainda

Não implementar código até a pergunta ser respondida (ou o dev pedir para seguir sem planejar).

## Fluxo de implementação (sequencial)

1. Identificar a(s) task(s) em `tasks.md` / `spec.md` §5 e a fase (se houver).
2. **Perguntar** sobre o planejamento + seguir o fluxo acima (salvo execução paralela já aprovada).
3. Implementar seguindo os **Steps**, as convenções de código e o `AGENTS.md`.
4. Atualizar `executions.md` por task.
5. Se teste/build falhar → invocar **`debugging`** antes de qualquer fix ad hoc.
6. **Gate iterativo** — invocar a skill **`verification`**; registrar evidência em `executions.md`. Se falhar: corrigir (via `debugging` se necessário); não ir para `/sdd-07-task-review`.
7. `/sdd-07-task-review` (por task; dois estágios).
8. Só marcar `done` após a revisão final aprovada.

Em **fase** sequencial: gate iterativo ao final da fase ou por task (conforme o plano); revisão **sempre por task**.

## Desvios e shadow code (obrigatório)

Se surgir desvio durante a implementação ou implementação que **viole restrições** (ver `specs/templates/sdd-restricoes.md` e `AGENTS.md`):

1. **Parar** o código do desvio.
2. Explicar e **perguntar como resolver**.
3. Opcional: usar Plan mode (se houver) para alinhar a abordagem antes de atualizar a spec.
4. Com consenso, atualizar `spec.md` / `tasks.md` **antes** de codar o desvio (incl. ajuste de **Restrições** se o limite mudar).
5. Registrar em `executions.md`.

## Ao concluir todas as tasks

`/sdd-08-spec-review` → `/sdd-09-docs` → `implementation-log.md` → MR/PR conforme `AGENTS.md`.

## TDD (se `tdd: true` no frontmatter)

Seguir `specs/templates/sdd-tdd.md` e as integrações em `AGENTS.md`:

- Seguir os Steps test-first quando aplicável.
- Ciclo por task: red → green → refactor.
- Respeitar `tdd_integracao`: integrações excluídas → **não impor** test-first.
- Registrar em `executions.md` por task: "TDD: sim" ou "TDD: N/A (integração fora do escopo)".

## Regras

- O agente **não** alterna de modo sozinho — usa o recurso da plataforma e o dev aprova.
- Commits apenas se o dev pedir.
- Nunca declarar gate verde sem a skill **`verification`**.
- **Disciplina (Execute):** código **mínimo** — só o que a task/Steps exigem; nada especulativo (refator extra, feature futura, abstração antecipada).
- **Disciplina (Execute):** tocar **só** arquivos/trechos do escopo (**Onde**, Steps, micro-plano). Limpar ou refatorar código adjacente só se **você** o alterou nesta task e for necessário para o DoD.

## Saída esperada

Micro-plano oferecido e registrado (se sequencial); código alinhado à spec; evidência de gate em `executions.md`; revisão de task pendente ou aprovada.
