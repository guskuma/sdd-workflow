# Executions: {titulo}

> Spec: [spec.md](./spec.md) · Tasks: [tasks.md](./tasks.md)

**Branch:** `feat/PROJ-XXXX` · **Base:** conforme [sdd-branch.md](../templates/sdd-branch.md) e [AGENTS.md](../../AGENTS.md)

**Plano (`/sdd-05-review`):** [ ] aprovado em ___ (`status: approved`)

Legenda: `pending` · `in_progress` · `blocked` · `done` · `skipped`

## Resumo

| Task | Status | Início | Fim | Responsável |
|------|--------|--------|-----|-------------|
| T01 | pending | | | |

---

## Registro por task

### T01: {título}

- **Status:** pending
- **Plano de execução (passo 06):** [ ] Sim — aprovado em ___ | [ ] Dispensado
- **Branch / MR:**

#### O que foi feito

<!-- Lista objetiva de alterações -->

#### Desvios da spec

<!-- Se houve, exigir atualização de spec.md antes de merge -->

#### Gate de qualidade (iterativo — ver AGENTS.md)

| Comando | Resultado | Observação |
|---------|-----------|------------|
| gate iterativo (lint/compile) | | |
| gate iterativo (testes) | | |
| gate iterativo (build) | | |

#### Revisão de task (loop do `/sdd-06-execute`)

- **Modo:** subagentes | mesma sessão (degradação: …)
- **Retomada:** implementador + revisor | só implementador | só revisor | Task novo ({motivo})
- **Worktree:** {path} | dispensado
- **Plano de execução:** aprovado em {data} | dispensado | dispensado — Steps do plano
- **TDD:** sim (skill tdd) | N/A (tdd: false | integração fora)
- **Verificação:** comando, exit code, evidência
- **Estágio 1 (spec compliance):** ✅ | ❌
  - Missing: …
  - Extra: …
- **Estágio 2 (code quality):** Aprovada | Aprovada com ressalvas | Reprovada
  - Crítico: …
  - Sugestão: …
- **Receiving-review:** Aceitos: … | Rejeitados: … | Ambíguos: …
- **Resultado:** Aprovada | Aprovada com ressalvas | Reprovada | Escalada ao dev
- **Data:**

#### Notas

---

## Plan compliance (`/sdd-04-plan`)

| Escopo | Resultado | Iters |
|--------|-----------|-------|
| skeleton / fase-N / cross / monólito | ✅ \| escalado | |

## Validação final (validação da spec — `/sdd-07-spec-review`)

| Comando | Resultado |
|---------|-----------|
| gate completo (ver AGENTS.md) | |

## Revisão da spec (`/sdd-07-spec-review`)

- **Resultado:** Aprovada | Reprovada
- **Data:**
- **Goals:** ...
- **Gaps:** ...

## Documentação (`/sdd-08-docs`)

- **Arquivos de documentação alterados:** ...
- **N/A:** [ ] Sim — justificativa: ...

## MR/PR (`/sdd-08-docs`)

- **`mr-template.md` preenchido:** [ ] Sim | [ ] N/A — justificativa: ...
- **Título MR/PR:** `{ISSUE-KEY}-{slug}`

## Fechamento na issue (opcional)

- **Perguntado ao dev se deseja comentário final na issue:** [ ] Sim
- **Decisão do dev:** [ ] Publicar | [ ] Não publicar
- **Execução via ferramenta do projeto:** [ ] Sim | [ ] N/A
- **Link/comentário:** ...

## ADR (opcional, quando aplicável)

- **Perguntado ao dev se deseja ADR:** [ ] Sim
- **Aplicável para esta spec:** [ ] Sim | [ ] Não
- **Decisão do dev:** [ ] Criar ADR | [ ] Não criar ADR
- **Arquivo ADR:** path em `AGENTS.md` | N/A

## Fechamento (`finish-branch`)

- **Gate de merge:** comando, exit code, evidência
- **Opção:** merge local | MR/PR | manter | descartar
- **Resultado:** URL | `merged-local` | spec não fechada
- **status:** `done` só após merge ou URL

---

## Checklist final da feature

- [ ] Todas as tasks `done` com revisão do `/sdd-06-execute` aprovada (gate iterativo por task)
- [ ] Validação final: gate completo verde (`AGENTS.md`)
- [ ] Plano aprovado (`status: approved`) antes do Execute
- [ ] `/sdd-07-spec-review` aprovado (`status: reviewed`)
- [ ] `/sdd-08-docs` concluído (documentação + `mr-template.md`; `status: documented`)
- [ ] Fechamento na issue opcional registrado
- [ ] ADR opcional registrado (quando aplicável)
- [ ] `finish-branch`: merge local ou MR/PR com URL; `closure.md` + `status: done`, `concluido`, `pr`; commit do fechamento (base sem push, ou feature com segundo push)
- [ ] MR/PR: `{ISSUE-KEY}-{slug}` (ou `pr: merged-local`)
