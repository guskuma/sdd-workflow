---
name: finish-branch
description: >-
  Fecha o ciclo após implementação: verifica gates, apresenta opções (merge local, abrir
  MR/PR, manter branch, descartar) e executa a escolha. Use após /sdd-08-docs ou quando
  o dev pedir para finalizar a branch da spec.
---

# Finalizar branch de desenvolvimento

## Objetivo

Conduzir o fechamento da mudança de forma explícita: evidência → menu → execução → cleanup.

**Iron Law:**

```
NENHUM MERGE OU MR/PR SEM VERIFICAÇÃO FRESCA DO GATE
```

## Quando invocar

- Ao concluir `/sdd-08-docs` (docs + `mr-template.md` prontos)
- Quando o dev pedir merge, PR, ou “fechar a feature”
- Após `/sdd-07-spec-review` se o dev quiser pular docs (ainda assim preferir 08 antes)

## Fluxo

### 1. Verificar

Invocar skill **`verification`** com o **gate completo** do `AGENTS.md` (ou o que a spec/review exigir).

Se falhar → **parar**; não apresentar menu. Corrigir (via `debugging` / execute) antes.

### 2. Detectar ambiente

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

| Estado | Menu |
|--------|------|
| `GIT_DIR == GIT_COMMON` (repo normal) | 4 opções |
| Worktree com branch nomeada | 4 opções + cleanup de worktree ao final |
| Detached HEAD (workspace externo) | 3 opções (sem merge local) |

Branch base: `AGENTS.md` (seção Branches Git). Confirmar se ambíguo.

### 3. Apresentar opções (exatas)

**Repo normal / worktree com branch:**

```
Implementação pronta (gate verde). O que deseja?

1. Merge local na branch base
2. Push e abrir MR/PR
3. Manter a branch como está (faço depois)
4. Descartar este trabalho

Qual opção?
```

**Detached HEAD:**

```
Workspace em detached HEAD (gerenciado externamente).

1. Push como branch nova e abrir MR/PR
2. Manter como está
3. Descartar este trabalho

Qual opção?
```

Sem enrolação — opções curtas; aguardar escolha explícita.

### 4. Executar a escolha

#### 1 — Merge local

1. Checkout da branch base; pull se o projeto usar remote tracking.
2. Merge da branch da feature (ff-only se o time preferir — perguntar se incerto).
3. Confirmar com `git log` / status.
4. Não apagar a branch feature sem perguntar.

#### 2 — Push + MR/PR

1. `git push -u` conforme remoto do projeto (só com pedido implícito nesta opção).
2. Abrir MR/PR com corpo de `mr-template.md` da pasta da spec (ferramenta em `AGENTS.md`: `gh`, etc.).
3. Título conforme convenção em `AGENTS.md`.
4. Reportar URL do MR/PR.

#### 3 — Manter

Registrar no chat: branch e próximo passo sugerido. Sem push/merge.

#### 4 — Descartar

**Confirmar de novo** (“Tem certeza? Trabalho não mergeado será perdido.”).

Só então: checkout base; apagar branch local se seguro; se worktree, remover worktree (ver skill **`worktrees`**). Nunca `push --force` na base. Nunca discard sem confirmação explícita.

### 5. Cleanup de worktree

Se o trabalho estava em worktree criado via skill **`worktrees`**: após merge/PR/discard bem-sucedido, oferecer remoção do worktree e voltar ao checkout principal. Não remover se a opção foi “manter”.

### 6. Registro

Atualizar `executions.md` (seção Fechamento) se a spec ainda estiver aberta:

```markdown
### Fechamento — {data}
- **Gate:** … (verification)
- **Opção:** merge local | MR/PR | manter | descartar
- **Resultado:** … (URL do MR/PR se houver)
```

Garantir `status: done` e entrada em `implementation-log.md` se `/sdd-08-docs` ainda não tiver feito.

## Red flags

- Apresentar menu com testes vermelhos
- Merge/PR sem `mr-template.md` quando a opção 2 foi escolhida — avisar e oferecer `/sdd-08-docs`
- Force push na branch base
- Descartar sem segunda confirmação

## Saída esperada

Gate verde; escolha do dev executada; MR/PR URL ou branch mergeada/mantida/descartada; worktree limpo se aplicável.
