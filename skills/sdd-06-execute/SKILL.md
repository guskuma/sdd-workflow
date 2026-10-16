---
name: sdd-06-execute
description: >-
  Fase Execute do SDD: implementa a task/fase via subagente, roda o gate e o loop de
  revisão (spec compliance → code quality → receiving-review → fix) até aprovar ou escalar.
  Use com /sdd-06-execute.
---

# SDD — Execute (+ revisão de task)

## Objetivo

Implementar **apenas** o plano aprovado (task única ou **fase**) e **concluir a revisão por task** no mesmo passo — loop implement → review → **receiving-review** → fix até aprovar ou escalar ao dev.

**Iron Law (review interno):**

```
NENHUM FIX DE APONTAMENTO DE REVIEW SEM PASSAR POR receiving-review
```

Findings do Estágio 1/2 são hipóteses — verificar antes de alterar código.

## Contexto do projeto

Gates, convenções de código e integrações: `AGENTS.md` (e as rules/convenções do projeto).

Skills transversais: [`debugging`](../debugging/SKILL.md), [`verification`](../verification/SKILL.md), [`parallel-execution`](../parallel-execution/SKILL.md), [`tdd`](../tdd/SKILL.md) (se `tdd: true`), [`worktrees`](../worktrees/SKILL.md) (opt-in), [`receiving-review`](../receiving-review/SKILL.md) (gate antes do fix), [`postgresql-table-design`](../postgresql-table-design/SKILL.md) (schema/migrations Postgres).

## Escopo do SDD

Válido para features, bugs (`fix`), mudanças de comportamento, refactors planejados, etc., conforme `tipo` em `spec.md`.

## Pré-requisitos

- `spec.md` com `status: approved` ou `executing` (retomada).
- `executions.md` existe.
- Branch da spec criada (se aplicável), registrada nos metadados.
- Tasks com **Context pack** + **Interfaces** + **Steps** quando exigido em `/sdd-04-plan`.

## Status da spec

Grave no frontmatter de `spec.md`. Ciclo: `draft` → `research` → `specified` → `planned` → `approved` → `executing` → `reviewed` → `documented` → `done`.

- `planned` ou anterior → **parar**. Pedir `/sdd-05-review`. Não implementar.
- `in-review` (legado) → tratar como `approved` e reescrever o frontmatter para `approved` antes de seguir.
- Imediatamente antes da primeira linha de código desta spec: `status` → `executing` se ainda estiver `approved`. Vale para o dispatch de implementador (sequencial ou paralelo) e para a degradação na mesma sessão.
- Retomada com `executing`: não altere o status.
- Esta fase não grava `reviewed`, `documented` nem `done`.

## Entrada

| Forma | Exemplo |
|-------|---------|
| Task única | `T03` |
| Fase / conjunto | `Fase 1`, `T01,T02,T03` |
| Automático | próxima `pending` em `executions.md` |

## Subagentes (padrão)

**Subagentes são o padrão** quando a plataforma tiver `Task` (ou equivalente — ver `using-sdd/references/*-tools.md`).

| Papel | Prompt | Modo |
|-------|--------|------|
| Implementador | [`prompt-implement.md`](./prompt-implement.md) | escreve código — **Task novo** na 1ª vez |
| Revisor (Estágios 1 e 2) | [`prompt-spec-compliance.md`](./prompt-spec-compliance.md) → [`prompt-code-quality.md`](./prompt-code-quality.md) | **readonly** — **mesmo** subagente na task; `code-reviewer` só se Task novo |
| Gate receiving-review | skill [`receiving-review`](../receiving-review/SKILL.md) (+ [`prompt-receiving-review.md`](./prompt-receiving-review.md)) | **readonly** — filtra findings (orquestrador) |
| Fix de apontamentos | [`prompt-fix.md`](./prompt-fix.md) | escreve código — **retoma** o implementador; **só** findings Aceitos |

### Retomada (mesmo subagente)

Quando a plataforma puder **continuar** um subagente (ver `using-sdd/references/*-tools.md`), o orquestrador **retoma** em vez de abrir Task novo:

| Situação | Quem | O que enviar |
|----------|------|----------------|
| Fix após receiving-review | **Mesmo implementador** da task | Bloco curto de [`prompt-fix.md`](./prompt-fix.md) (Aceitos + iter) |
| Estágio 1 ✅ → Estágio 2 | **Mesmo revisor** da task | Checklist de [`prompt-code-quality.md`](./prompt-code-quality.md) |
| Após fix → Estágio 1 de novo (`iter` > 1) | **Mesmo revisor** da task | Modo **delta** nos prompts de review (veredito anterior fechado + diff novo) |

**Task novo** (fallback) quando:

1. A plataforma **não** retoma subagente, ou
2. O implementador retornou `NEEDS_CONTEXT` / `BLOCKED` (sem diff estável para reaproveitar), ou
3. O revisor da task já não estiver disponível.

Nesses casos: pacote integral do prompt; Estágio 2 pode usar o agente `code-reviewer` se existir.

O **orquestrador** (sessão principal) **não** escreve código salvo degradação. O gate **`receiving-review`** preferencialmente roda no **orquestrador** (tem o contexto); subagente readonly só se ajudar a preservar contexto.

**Degradar para mesma sessão** somente se:

1. A plataforma **não** tiver subagentes, ou
2. O dev pedir explicitamente (“sem subagente” / “na mesma sessão”).

Avisar uma vez ao degradar; anotar o modo **só no registro final** em `executions.md`. Antes da primeira linha de código, gravar `executing` se o status ainda for `approved`.

## Worktree (opt-in — perguntar uma vez por sessão de execute)

**Antes** do planejamento/implementação da primeira task desta invocação de `/sdd-06-execute`, perguntar:

> "Deseja isolar o trabalho em um git worktree? (protege o checkout atual)"

| Resposta | Ação |
|----------|------|
| **Sim** | Invocar skill **`worktrees`**; só então seguir |
| **Não** | Continuar no workspace atual; no registro final: `Worktree: dispensado` |
| Preferência já declarada | Honrar sem perguntar de novo |

Não criar worktree sem opt-in. Cleanup fica em **`finish-branch`** ao fechar a spec.

## Modo de execução por fase

1. Ler `tasks.md` — coluna **Paralelo?** e **Paralelo com** / **Onde** de cada task.
2. Validar elegibilidade paralela: **Onde** disjunto; sem build files/migrations compartilhadas.
3. Se a fase tiver **Paralelo? = sim** e for elegível:
   - Perguntar: "Executar {T01 ∥ T02} em paralelo (subagentes isolados)?"
   - **Sim** → skill **`parallel-execution`**
   - **Não** → sequencial (fluxo abaixo, uma task por vez)
4. Se **Paralelo? = não** ou overlap de arquivos → sequencial.

Após o paralelo: gate da fase + **loop de revisão por task** (seção abaixo), sequencial.

## Planejar antes de codar

Perguntar **uma vez por fase**, e só se **alguma** task dessa fase não tem Steps executáveis (formato curto: `chore`, `docs`, `fix` de 1 arquivo, ou Steps ausentes).

> "Deseja **planejar a execução** das tasks sem Steps desta fase antes de implementar?"

O sim cobre só essas tasks. Task com Context pack + Interfaces + Steps: não entra na pergunta. Seguir os Steps. Registrar "Plano de execução: dispensado — Steps do plano".

Fase em que toda task tem Steps: não perguntar.

### Se o dev responder **sim**

1. Se a plataforma tiver **Plan mode**, solicitar a troca (o dev aprova na UI). Sem Plan mode, não editar código ainda.
2. Micro-plano no chat, só das tasks sem Steps: arquivos, ordem, testes, riscos, o que não será feito.
3. Aguardar aprovação explícita.
4. Voltar ao modo de implementação se trocou de modo.
5. Registrar "Plano de execução: aprovado em {data}".
6. Só então o dispatch.

### Se o dev responder **não**

Registrar "Plano de execução: dispensado" nas tasks sem Steps e seguir DoD + spec.

### Se o dev não responder ainda

Não implementar até a resposta, quando a pergunta tiver sido feita.

## Fluxo por task (sequencial)

1. Identificar a task em `tasks.md` / `spec.md` §5 e a fase (se houver).
2. Se alguma task da fase não tem Steps, perguntar o micro-plano **uma vez** (seção acima), antes da primeira dessas tasks. Task com Steps: seguir os Steps.
3. Se `tdd: tbd` → parar e voltar ao `/sdd-03-specify`. Se `tdd: true` → a skill **`tdd`** aplica-se ao implementador.
4. **Dispatch implementador** (`prompt-implement.md`) — Task novo; pai não escreve código (salvo degradação). Guardar o handle/id do subagente para retomada.
5. Se teste/build falhar no report → invocar **`debugging`** antes de fix ad hoc; **retomar** o implementador (ou Task novo se `NEEDS_CONTEXT`/`BLOCKED` / sem retomada).
6. **Gate iterativo** — invocar **`verification`** (pai). Se falhar: corrigir (via `debugging` / fix); **não** iniciar o loop de revisão.
7. **Loop de revisão** (abaixo).
8. **Só ao concluir** (aprovada, ressalvas aceitas pelo dev, ou escalada): registrar em `executions.md` e marcar `done` se aprovada.

Em **fase** sequencial: gate iterativo ao final da fase ou por task (conforme o plano); revisão **sempre por task**.

## Loop de revisão (por task)

Ler e seguir integralmente [`references/execute-review-loop.md`](./references/execute-review-loop.md) antes de dispatch de revisor ou de fix. Não improvisar o loop de memória.

Iron Law: nenhum fix sem `receiving-review`. `iter` 1..4 pode corrigir. No `iter` 5 com Aceito crítico, parar e escalar. Sem sexto fix.

No handoff do Estágio 1 para o Estágio 2, colar os findings rejeitados como fechados.

Ao concluir a task, preencher a seção **Revisão de task** de `specs/templates/executions-template.md`. Não inventar outro bloco.

## Desvios e shadow code (obrigatório)

Se surgir desvio durante a implementação ou implementação que **viole restrições** (ver `specs/templates/sdd-restricoes.md` e `AGENTS.md`):

1. **Parar** o código do desvio.
2. Explicar e **perguntar como resolver**.
3. Opcional: usar Plan mode (se houver) para alinhar a abordagem antes de atualizar a spec.
4. Com consenso, atualizar `spec.md` / `tasks.md` **antes** de codar o desvio (incl. ajuste de **Restrições** se o limite mudar).
5. Incluir no registro final em `executions.md`.

## Ao concluir todas as tasks

`/sdd-07-spec-review` (`reviewed`) → `/sdd-08-docs` (`documented`) → skill **`finish-branch`**. `done`, `concluido`, `pr` e `closure.md` só no `finish-branch`, depois de merge local ou de MR/PR com URL.

## TDD

`tdd: tbd` → parar e voltar ao `/sdd-03-specify`. `tdd: true` → skill **`tdd`** (não repetir o ciclo aqui). `tdd: false` → não impor test-first. No registro da task: "TDD: sim (skill tdd)" ou "TDD: N/A (…)".

## Regras

- O agente **não** alterna de modo sozinho — usa o recurso da plataforma e o dev aprova.
- Commits apenas se o dev pedir.
- Nunca declarar gate verde sem a skill **`verification`**.
- Nunca enviar `prompt-fix` sem skill **`receiving-review`** nos apontamentos (só Aceitos vão ao fix).
- Preferir **retomada** do implementador (fix) e do revisor (E1→E2 e delta pós-fix); Task novo só no fallback.
- Se a task criar/alterar tabelas, indexes ou migrations **PostgreSQL** → invocar **`postgresql-table-design`** antes do DDL.
- **Disciplina (Execute):** código **mínimo** — só o que a task/Steps exigem; nada especulativo (refator extra, feature futura, abstração antecipada).
- **Disciplina (Execute):** tocar **só** arquivos/trechos do escopo (**Onde**, Steps, micro-plano). Limpar ou refatorar código adjacente só se **alterado nesta task** e for necessário para o DoD.
- A task só avança após **Revisão de task (final)** aprovada (ou ressalvas aceitas pelo dev).

## Red flags

| Racionalização | Realidade |
|----------------|-----------|
| "O implementador já sabe o review — ele mesmo revisa" | Papéis separados; retomada **não** funde autor e revisor |
| "Um revisor para a fase inteira economiza Task" | Um revisor **por task**; achado de uma task não vaza para outra |
| "Receiving-review é opcional se o implementador lembra" | Gate no orquestrador **antes** de qualquer fix |
| "Sempre Task novo no fix" | Retomar o implementador é o padrão; Task novo só no fallback |
| "O dev já aprovou no chat" | Sem `status: approved` ou `executing`, não implementar |
| "Task pronta inclui a doc pública" | Doc pública é `/sdd-08-docs`, no checklist da spec — não é DoD da task |

## Saída esperada

Micro-plano oferecido (se sequencial); código alinhado à spec; gate + receiving-review + revisão de task concluídos; `executions.md` atualizado **uma vez** ao final; próxima task ou `/sdd-07-spec-review`.
