---
name: sdd-07-task-review
description: >-
  Revisão de código após cada task do SDD em dois estágios: spec compliance, depois code
  quality. Use com /sdd-07-task-review após /sdd-06-execute de uma task.
---

# SDD — Revisão de task (dois estágios)

## Objetivo

Verificar se **uma task** foi concluída corretamente antes de passar à próxima.

**Ordem obrigatória:**

```
Estágio 1 — Spec compliance  →  só se ✅  →  Estágio 2 — Code quality
```

**Nunca** iniciar o Estágio 2 com o Estágio 1 reprovado ou pendente.

## Contexto do projeto

Gates e convenções: `AGENTS.md` (e as rules/convenções do projeto).

Skills transversais: [`verification`](../verification/SKILL.md), [`debugging`](../debugging/SKILL.md) (se a reprovação exigir fix).

## Quando rodar

Obrigatório após cada implementação via `/sdd-06-execute` (por **task**; após execução paralela, revisar **cada** task sequencialmente).

## Entrada

| Forma | Exemplo |
|-------|---------|
| Task única | `T01` |
| Conjunto após fase | `T01,T02` (alinhado ao `/sdd-06-execute` anterior) |

## Passos gerais

1. Identificar a task em `tasks.md` / `spec.md` §5 e o registro em `executions.md`.
2. Executar o **Estágio 1** (spec compliance).
3. Se o Estágio 1 ❌ → reprovar a task; voltar `/sdd-06-execute`; **não** executar o Estágio 2.
4. Executar o **Estágio 2** (code quality).
5. Consolidar o resultado final e atualizar `executions.md`.

---

## Estágio 1 — Spec compliance

**Foco:** entregou o pedido? Nada a mais, nada a menos.

### Checklist

- [ ] DoD / entregável corresponde ao plano (tasks.md, Steps se houver)
- [ ] Critérios de aceite da US / RF cobertos
- [ ] Sem shadow code (desvio documentado + spec atualizada **antes** do código)
- [ ] Sem escopo **extra** (non-goals, features não pedidas)
- [ ] Sem escopo **faltante** (requisitos omitidos)
- [ ] Steps executados conforme o plano

### Como executar

- Ler o diff nos arquivos de **Onde** — não confiar só no report do implementador.
- Prompt opcional: [`prompt-spec-compliance.md`](./prompt-spec-compliance.md) (subagente readonly ou mesma sessão).

### Registrar em `executions.md`

```markdown
**Revisão Estágio 1 (spec compliance):** ✅ | ❌
- Missing: ...
- Extra: ...
```

---

## Estágio 2 — Code quality

**Só após o Estágio 1 ✅.**

**Foco:** código bem construído, testes, convenções, gates com evidência.

### Checklist

- [ ] Restrições da spec + `specs/templates/sdd-restricoes.md` + `AGENTS.md`
- [ ] Gate iterativo verificado via skill **`verification`** (output fresco ou registro válido)
- [ ] Testes cobrem o comportamento da task
- [ ] Edge cases da spec considerados
- [ ] Sem regressão óbvia (usos alterados, integrações adjacentes)
- [ ] TDD ok ou N/A justificado (`tdd`, `tdd_integracao`)

### Como executar

- Invocar **`verification`** se `executions.md` não tiver um bloco Verificação recente para esta task.
- Falha de teste/build → **`debugging`** antes de reprovar definitivamente.
- Prompt opcional: [`prompt-code-quality.md`](./prompt-code-quality.md).

### Registrar em `executions.md`

```markdown
**Revisão Estágio 2 (code quality):** Aprovada | Aprovada com ressalvas | Reprovada
- Crítico: ...
- Sugestão: ...

**Revisão de task (final):** Aprovada | Aprovada com ressalvas | Reprovada
```

---

## Decisão final

| Resultado | Ação |
|-----------|------|
| Ambos estágios OK | Marcar task `done`; sugerir próxima ou `/sdd-08-spec-review` |
| Estágio 1 ❌ | Reprovada; `/sdd-06-execute` |
| Estágio 2 Reprovada | Reprovada; `/sdd-06-execute` |
| Estágio 2 com ressalvas | Dev decide; registrar ressalvas; pode marcar `done` se aceitas |

## TDD (se `tdd: true` no frontmatter)

Seguir `specs/templates/sdd-tdd.md`:

- Estágio 1: comportamento pedido coberto pelos testes previstos no plano.
- Estágio 2: diff mostra teste + produção; integrações excluídas conforme `tdd_integracao`.

## Modo de execução

| Complexidade | Modo |
|--------------|------|
| Task simples (1–2 arquivos) | Mesma sessão, duas passagens |
| Task complexa | Subagente readonly por estágio (prompts acima), se a plataforma suportar |

## Saída esperada

Relatório no chat (Estágio 1 → Estágio 2 → final) + `executions.md` atualizado. A task só avança após **Revisão de task (final)** aprovada.
