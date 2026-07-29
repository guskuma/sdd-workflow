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

- Plano aprovado via `/sdd-05-review`.
- `executions.md` existe.
- Branch da spec criada (se aplicável), registrada nos metadados.
- Tasks com **Context pack** + **Interfaces** + **Steps** quando exigido em `/sdd-04-plan`.

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
| Implementador | [`prompt-implement.md`](./prompt-implement.md) | escreve código |
| Revisor Estágio 1 | [`prompt-spec-compliance.md`](./prompt-spec-compliance.md) | **readonly** — não altera código |
| Revisor Estágio 2 | [`prompt-code-quality.md`](./prompt-code-quality.md) (+ agente `code-reviewer` se existir) | **readonly** |
| Gate receiving-review | skill [`receiving-review`](../receiving-review/SKILL.md) (+ [`prompt-receiving-review.md`](./prompt-receiving-review.md)) | **readonly** — filtra findings |
| Fix de apontamentos | [`prompt-fix.md`](./prompt-fix.md) | escreve código — **só** findings aceitos |

O **orquestrador** (sessão principal) **não** escreve código salvo degradação. O gate **`receiving-review`** preferencialmente roda no **orquestrador** (tem o contexto); subagente readonly só se ajudar a preservar contexto.

**Degradar para mesma sessão** somente se:

1. A plataforma **não** tiver subagentes, ou
2. O dev pedir explicitamente (“sem subagente” / “na mesma sessão”).

Avisar uma vez ao degradar; anotar o modo **só no registro final** em `executions.md`.

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

## Planejar antes de codar (obrigatório perguntar)

**Antes de alterar código** (modo sequencial), o orquestrador deve **perguntar ao dev**:

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
5. Incluir no registro final: "Plano de execução: aprovado em {data}".
6. Só então dispatch do implementador.

### Se o dev responder **não**

1. Incluir no registro final: "Plano de execução: dispensado".
2. Seguir os **Steps** de `tasks.md` quando existirem; senão, DoD + spec.
3. Para task **trivial** (ex.: ajuste pontual em 1 arquivo), aceitável; para task complexa, **recomendar** planejar, sem insistir após recusa.

### Se o dev não responder ainda

Não implementar código até a pergunta ser respondida (ou o dev pedir para seguir sem planejar).

## Fluxo por task (sequencial)

1. Identificar a task em `tasks.md` / `spec.md` §5 e a fase (se houver).
2. **Perguntar** sobre o planejamento + seguir o fluxo acima.
3. Se `tdd: true` → a skill **`tdd`** aplica-se ao implementador (Iron Law: teste vermelho antes da produção).
4. **Dispatch implementador** (`prompt-implement.md`) — pai não escreve código (salvo degradação).
5. Se teste/build falhar no report → invocar **`debugging`** antes de fix ad hoc; re-dispatch fix se necessário.
6. **Gate iterativo** — invocar **`verification`** (pai). Se falhar: corrigir (via `debugging` / fix); **não** iniciar o loop de revisão.
7. **Loop de revisão** (abaixo).
8. **Só ao concluir** (aprovada, ressalvas aceitas pelo dev, ou escalada): registrar em `executions.md` e marcar `done` se aprovada.

Em **fase** sequencial: gate iterativo ao final da fase ou por task (conforme o plano); revisão **sempre por task**.

## Loop de revisão (por task)

**Ordem obrigatória em cada iteração:**

```
Estágio 1 — Spec compliance
  → se ❌: receiving-review → (aceitos? fix → iter++ → Estágio 1) | (só rejeitados? tratar E1 como ✅)
  → se ✅: Estágio 2 — Code quality
       → se Reprovada: receiving-review → (aceitos? fix → iter++ → Estágio 1)
       → se Aprovada: concluir
       → se Ressalvas: escalar ao dev
```

**Nunca** iniciar o Estágio 2 com o Estágio 1 reprovado (após receiving-review: só avança se não restar finding **aceito** de E1).

**Nunca** dispatch `prompt-fix` sem **`receiving-review`** nos apontamentos daquela reprovação.

`iter` começa em 1; **máximo 5 iterações** (só incrementa quando houve **fix** com findings aceitos).

### Estágio 1 — Spec compliance

**Foco:** entregou o pedido? Nada a mais, nada a menos.

Checklist:

- [ ] DoD / entregável corresponde ao plano (tasks.md, Steps se houver)
- [ ] **Interfaces** Consumes/Produces respeitadas (assinaturas/nomes), se existirem no plano
- [ ] Critérios de aceite da US / RF cobertos
- [ ] Sem shadow code (desvio documentado + spec atualizada **antes** do código)
- [ ] Sem escopo **extra** (non-goals, features não pedidas)
- [ ] Sem código **especulativo** (refator “de brinde”, abstração antecipada, feature futura)
- [ ] Sem alterações **fora do escopo** da task (arquivos/trechos não listados em **Onde** ou Steps)
- [ ] Sem escopo **faltante** (requisitos omitidos)
- [ ] Steps executados conforme o plano

Dispatch: [`prompt-spec-compliance.md`](./prompt-spec-compliance.md). Ler o diff em **Onde** — não confiar só no report do implementador.

- Se ❌ → **Gate receiving-review** (abaixo) com os apontamentos Missing/Extra → só então fix ou reclassificar.

### Estágio 2 — Code quality

**Só após o Estágio 1 ✅** (incluindo o caso em que E1 ❌ foi anulado porque todos os findings foram rejeitados no receiving-review).

Checklist:

- [ ] Restrições da spec + `specs/templates/sdd-restricoes.md` + `AGENTS.md`
- [ ] Gate iterativo verificado via skill **`verification`** (output fresco ou válido nesta conclusão)
- [ ] Testes cobrem o comportamento da task
- [ ] Edge cases da spec considerados
- [ ] Sem regressão óbvia (usos alterados, integrações adjacentes)
- [ ] TDD ok ou N/A justificado (`tdd`, `tdd_integracao`)

Dispatch: [`prompt-code-quality.md`](./prompt-code-quality.md) (preferir subagente `code-reviewer` se a plataforma tiver).

- Se **Reprovada** → **Gate receiving-review** com Crítico (e Importante se o revisor exigir fix) → só então fix ou reclassificar.
- Se **Aprovada** → concluir; marcar task `done`.
- Se **Aprovada com ressalvas** → **escalar ao dev** (não auto-aprovar). Ressalvas **não** passam por fix automático; o dev decide.

### Gate receiving-review (obrigatório antes de qualquer fix)

Invocar a skill **[`receiving-review`](../receiving-review/SKILL.md)** (template: [`prompt-receiving-review.md`](./prompt-receiving-review.md)) sobre a lista de apontamentos do estágio que reprovou.

Para **cada** finding:

| Veredito | Ação |
|----------|------|
| **Aceito** | Entra no lote do `prompt-fix.md` |
| **Rejeitado** (falso positivo / fora de escopo / incorreto) | **Não** corrigir; registrar motivo (não conta como desobediência ao revisor) |
| **Ambíguo** | **Parar** o loop; perguntar ao dev (receiving-review). Não fixar o lote até esclarecer |

Regras:

1. `prompt-fix` recebe **apenas** findings **Aceitos** (texto integral + motivo do aceito se útil).
2. Se **nenhum** Aceito e nenhum Ambíguo → estágio tratado como ✅ para esse conjunto; seguir o fluxo (E1 → E2, ou E2 → concluir).
3. Se há Aceitos → dispatch fix → `iter++` → **sempre** voltar ao **Estágio 1**.
4. Rejeitar finding **não** incrementa `iter`.
5. Orquestrador (ou subagente readonly) **lê o diff/spec** — não confiar só no texto do revisor.

### Limite de iterações e escalação

| Situação | Ação |
|----------|------|
| `iter` 1..5 com findings Aceitos após receiving-review | Fix + re-review desde Estágio 1 |
| `iter == 5` e ainda crítico Aceito | **Parar**; mostrar apontamentos (+ rejeitados); pedir decisão do dev |
| Estágio 2 com ressalvas | **Parar**; dev aceita ressalvas (`done`) ou pede mais uma rodada |
| Ambíguo no receiving-review | **Parar**; esclarecer com o dev antes de fix |

**Não** gravar cada iteração em `executions.md` — só o resultado final (ver abaixo).

### Registro final em `executions.md`

Somente ao concluir (ou escalar):

```markdown
**Modo:** subagentes | mesma sessão (degradação: …)
**Worktree:** {path} (branch …) | dispensado | degradação: …
**Plano de execução:** aprovado em {data} | dispensado
**TDD:** sim (skill tdd) | N/A (tdd: false | integração fora)
**Verificação:** … (comando, exit code, evidência)
**Revisão Estágio 1 (spec compliance):** ✅ | ❌
- Missing: ...
- Extra: ...
**Revisão Estágio 2 (code quality):** Aprovada | Aprovada com ressalvas | Reprovada
- Crítico: ...
- Sugestão: ...
**Receiving-review (gate pré-fix):** Aceitos: … | Rejeitados: … | Ambíguos: …
**Revisão de task (final):** Aprovada | Aprovada com ressalvas | Reprovada | Escalada ao dev
```

## Desvios e shadow code (obrigatório)

Se surgir desvio durante a implementação ou implementação que **viole restrições** (ver `specs/templates/sdd-restricoes.md` e `AGENTS.md`):

1. **Parar** o código do desvio.
2. Explicar e **perguntar como resolver**.
3. Opcional: usar Plan mode (se houver) para alinhar a abordagem antes de atualizar a spec.
4. Com consenso, atualizar `spec.md` / `tasks.md` **antes** de codar o desvio (incl. ajuste de **Restrições** se o limite mudar).
5. Incluir no registro final em `executions.md`.

## Ao concluir todas as tasks

`/sdd-07-spec-review` → `/sdd-08-docs` → skill **`finish-branch`** (menu merge/MR) → `implementation-log.md` conforme `AGENTS.md`.

## TDD (se `tdd: true` no frontmatter)

Invocar e seguir a skill **`tdd`** + `specs/templates/sdd-tdd.md` e integrações em `AGENTS.md`:

- **Iron Law:** nenhum código de produção sem teste falhando pelo motivo certo primeiro; violação → apagar produção e recomeçar.
- Seguir os Steps test-first quando aplicável.
- Ciclo por task: red → green → refactor.
- Respeitar `tdd_integracao`: integrações excluídas → **não impor** test-first.
- No registro final: "TDD: sim (skill tdd)" ou "TDD: N/A (… )".
- Estágio 1: comportamento pedido coberto pelos testes previstos no plano.
- Estágio 2: diff mostra teste + produção; integrações excluídas conforme `tdd_integracao`.

## Regras

- O agente **não** alterna de modo sozinho — usa o recurso da plataforma e o dev aprova.
- Commits apenas se o dev pedir.
- Nunca declarar gate verde sem a skill **`verification`**.
- Nunca dispatch `prompt-fix` sem skill **`receiving-review`** nos apontamentos (só Aceitos vão ao fix).
- Se a task criar/alterar tabelas, indexes ou migrations **PostgreSQL** → invocar **`postgresql-table-design`** antes do DDL.
- **Disciplina (Execute):** código **mínimo** — só o que a task/Steps exigem; nada especulativo (refator extra, feature futura, abstração antecipada).
- **Disciplina (Execute):** tocar **só** arquivos/trechos do escopo (**Onde**, Steps, micro-plano). Limpar ou refatorar código adjacente só se **alterado nesta task** e for necessário para o DoD.
- A task só avança após **Revisão de task (final)** aprovada (ou ressalvas aceitas pelo dev).

## Saída esperada

Micro-plano oferecido (se sequencial); código alinhado à spec; gate + receiving-review + revisão de task concluídos; `executions.md` atualizado **uma vez** ao final; próxima task ou `/sdd-07-spec-review`.
