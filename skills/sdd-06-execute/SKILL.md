---
name: sdd-06-execute
description: >-
  Fase Execute do SDD: implementa a task/fase via subagente, roda o gate e o loop de
  revisão (spec compliance → code quality) até aprovar ou escalar. Use com /sdd-06-execute.
---

# SDD — Execute (+ revisão de task)

## Objetivo

Implementar **apenas** o plano aprovado (task única ou **fase**) e **concluir a revisão por task** no mesmo passo — loop implement → review → fix até aprovar ou escalar ao dev.

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

## Subagentes (padrão)

**Subagentes são o padrão** quando a plataforma tiver `Task` (ou equivalente — ver `using-sdd/references/*-tools.md`).

| Papel | Prompt | Modo |
|-------|--------|------|
| Implementador | [`prompt-implement.md`](./prompt-implement.md) | escreve código |
| Revisor Estágio 1 | [`prompt-spec-compliance.md`](./prompt-spec-compliance.md) | **readonly** — não altera código |
| Revisor Estágio 2 | [`prompt-code-quality.md`](./prompt-code-quality.md) (+ agente `code-reviewer` se existir) | **readonly** |
| Fix de apontamentos | [`prompt-fix.md`](./prompt-fix.md) | escreve código |

O **orquestrador** (sessão principal) **não** escreve código salvo degradação.

**Degradar para mesma sessão** somente se:

1. A plataforma **não** tiver subagentes, ou
2. O dev pedir explicitamente (“sem subagente” / “na mesma sessão”).

Avisar uma vez ao degradar; anotar o modo **só no registro final** em `executions.md`.

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
3. **Dispatch implementador** (`prompt-implement.md`) — pai não escreve código (salvo degradação).
4. Se teste/build falhar no report → invocar **`debugging`** antes de fix ad hoc; re-dispatch fix se necessário.
5. **Gate iterativo** — invocar **`verification`** (pai). Se falhar: corrigir (via `debugging` / fix); **não** iniciar o loop de revisão.
6. **Loop de revisão** (abaixo).
7. **Só ao concluir** (aprovada, ressalvas aceitas pelo dev, ou escalada): registrar em `executions.md` e marcar `done` se aprovada.

Em **fase** sequencial: gate iterativo ao final da fase ou por task (conforme o plano); revisão **sempre por task**.

## Loop de revisão (por task)

**Ordem obrigatória em cada iteração:**

```
Estágio 1 — Spec compliance  →  só se ✅  →  Estágio 2 — Code quality
```

**Nunca** iniciar o Estágio 2 com o Estágio 1 reprovado.

`iter` começa em 1; **máximo 5 iterações**.

### Estágio 1 — Spec compliance

**Foco:** entregou o pedido? Nada a mais, nada a menos.

Checklist:

- [ ] DoD / entregável corresponde ao plano (tasks.md, Steps se houver)
- [ ] Critérios de aceite da US / RF cobertos
- [ ] Sem shadow code (desvio documentado + spec atualizada **antes** do código)
- [ ] Sem escopo **extra** (non-goals, features não pedidas)
- [ ] Sem código **especulativo** (refator “de brinde”, abstração antecipada, feature futura)
- [ ] Sem alterações **fora do escopo** da task (arquivos/trechos não listados em **Onde** ou Steps)
- [ ] Sem escopo **faltante** (requisitos omitidos)
- [ ] Steps executados conforme o plano

Dispatch: [`prompt-spec-compliance.md`](./prompt-spec-compliance.md). Ler o diff em **Onde** — não confiar só no report do implementador.

- Se ❌ → dispatch fix (`prompt-fix.md`) com apontamentos → `iter++` → recomeçar no Estágio 1 (**não** ir ao Estágio 2).

### Estágio 2 — Code quality

**Só após o Estágio 1 ✅.**

Checklist:

- [ ] Restrições da spec + `specs/templates/sdd-restricoes.md` + `AGENTS.md`
- [ ] Gate iterativo verificado via skill **`verification`** (output fresco ou válido nesta conclusão)
- [ ] Testes cobrem o comportamento da task
- [ ] Edge cases da spec considerados
- [ ] Sem regressão óbvia (usos alterados, integrações adjacentes)
- [ ] TDD ok ou N/A justificado (`tdd`, `tdd_integracao`)

Dispatch: [`prompt-code-quality.md`](./prompt-code-quality.md) (preferir subagente `code-reviewer` se a plataforma tiver).

- Se **Reprovada** → fix (`prompt-fix.md`) → `iter++` → voltar ao **Estágio 1**.
- Se **Aprovada** → concluir; marcar task `done`.
- Se **Aprovada com ressalvas** → **escalar ao dev** (não auto-aprovar).

### Limite de iterações e escalação

| Situação | Ação |
|----------|------|
| `iter` 1..5 com crítico (E1 ❌ ou E2 Reprovada) | Fix + re-review desde Estágio 1 |
| `iter == 5` e ainda crítico | **Parar**; mostrar apontamentos; pedir decisão do dev |
| Estágio 2 com ressalvas | **Parar**; dev aceita ressalvas (`done`) ou pede mais uma rodada |

**Não** gravar cada iteração em `executions.md` — só o resultado final (ver abaixo).

### Registro final em `executions.md`

Somente ao concluir (ou escalar):

```markdown
**Modo:** subagentes | mesma sessão (degradação: …)
**Plano de execução:** aprovado em {data} | dispensado
**Verificação:** … (comando, exit code, evidência)
**Revisão Estágio 1 (spec compliance):** ✅ | ❌
- Missing: ...
- Extra: ...
**Revisão Estágio 2 (code quality):** Aprovada | Aprovada com ressalvas | Reprovada
- Crítico: ...
- Sugestão: ...
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

`/sdd-07-spec-review` → `/sdd-08-docs` → `implementation-log.md` → MR/PR conforme `AGENTS.md`.

## TDD (se `tdd: true` no frontmatter)

Seguir `specs/templates/sdd-tdd.md` e as integrações em `AGENTS.md`:

- Seguir os Steps test-first quando aplicável.
- Ciclo por task: red → green → refactor.
- Respeitar `tdd_integracao`: integrações excluídas → **não impor** test-first.
- No registro final: "TDD: sim" ou "TDD: N/A (integração fora do escopo)".
- Estágio 1: comportamento pedido coberto pelos testes previstos no plano.
- Estágio 2: diff mostra teste + produção; integrações excluídas conforme `tdd_integracao`.

## Regras

- O agente **não** alterna de modo sozinho — usa o recurso da plataforma e o dev aprova.
- Commits apenas se o dev pedir.
- Nunca declarar gate verde sem a skill **`verification`**.
- **Disciplina (Execute):** código **mínimo** — só o que a task/Steps exigem; nada especulativo (refator extra, feature futura, abstração antecipada).
- **Disciplina (Execute):** tocar **só** arquivos/trechos do escopo (**Onde**, Steps, micro-plano). Limpar ou refatorar código adjacente só se **alterado nesta task** e for necessário para o DoD.
- A task só avança após **Revisão de task (final)** aprovada (ou ressalvas aceitas pelo dev).

## Saída esperada

Micro-plano oferecido (se sequencial); código alinhado à spec; gate + revisão de task concluídos; `executions.md` atualizado **uma vez** ao final; próxima task ou `/sdd-07-spec-review`.
