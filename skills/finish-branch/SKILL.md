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

- Ao concluir `/sdd-08-docs` (`status: documented`; docs + `mr-template.md` prontos)
- Quando o dev pedir merge, PR, ou “fechar a feature”
- Após `/sdd-07-spec-review` (`status: reviewed`) se o dev quiser pular docs — avisar uma vez e seguir; preferir o 08 antes

Não gravar `done` com status anterior a `reviewed`.

## Fluxo

### 1. Verificar

Invocar skill **`verification`** com o **gate de merge**: o comando de gate completo do `AGENTS.md`. Output fresco nesta sessão. A validação da spec no `/sdd-07-spec-review` não substitui este passo.

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

No detached HEAD, a opção 1 segue **Push + MR/PR** (fechar a spec só com URL). Manter e descartar não fecham a spec.

### 4. Executar a escolha

#### 1 — Merge local

1. Checkout da branch base; pull se o projeto usar remote tracking.
2. Merge da branch da feature (ff-only se o time preferir — perguntar se incerto).
3. Confirmar com `git log` / status.
4. Não apagar a branch feature sem perguntar.
5. Fechar a spec (`pr: merged-local`) e pedir o commit na branch base.

#### 2 — Push + MR/PR

1. `git push -u` conforme remoto do projeto (só com pedido implícito nesta opção).
2. Abrir MR/PR com corpo de `mr-template.md` da pasta da spec (ferramenta em `AGENTS.md`: `gh`, etc.).
3. Título conforme convenção em `AGENTS.md`.
4. Reportar URL do MR/PR.
5. Com a URL em mãos, fechar a spec (`pr:` = essa URL, `#N` ou `!N`) e pedir o commit na branch da feature, com um segundo push. Sem URL → não fechar; pedir o link ou outra opção.

#### 3 — Manter

Registrar no chat: branch e próximo passo sugerido. Sem push/merge. Não alterar `status`, `concluido`, `pr` nem `closure.md`.

#### 4 — Descartar

**Confirmar de novo** (“Tem certeza? Trabalho não mergeado será perdido.”).

Só então: checkout base; apagar branch local se seguro; se worktree, remover worktree (ver skill **`worktrees`**). Nunca `push --force` na base. Nunca discard sem confirmação explícita. Não gravar `done` nem criar `closure.md`.

### 5. Cleanup de worktree

Se o trabalho estava em worktree criado via skill **`worktrees`**: depois do pedido de commit do fechamento (ou do discard), oferecer remoção do worktree e voltar ao checkout principal. Não remover se a opção foi “manter”. Não remover com `spec.md` / `closure.md` ainda sujos.

### Fechar a spec

Só depois de merge local concluído ou de MR/PR aberto **com URL**.

1. Não editar `specs/implementation-log.md` (legado congelado, se existir).
2. Criar/preencher `closure.md` a partir de `specs/templates/closure-template.md` (entrega, issue, decisões, desvios — a partir de `spec.md` e `executions.md`).
3. No `closure.md`, campo PR: a URL (`#N` / `!N`) ou `merged-local`.
4. Em `spec.md`: `status: done`, `concluido: YYYY-MM-DD`, `pr:` igual ao campo PR do closure.
5. Marcar o checklist final em `executions.md`.
6. Pedir o commit do fechamento. Sem um sim explícito, não commitar. Mensagem pela skill **`commit-message`**. Incluir só o que o fechamento alterou nesta pasta: `spec.md`, `closure.md`, `executions.md`.
   - **Merge local:** o checkout já é a branch base. Commit ali. Não fazer push.
   - **MR/PR:** o checkout ainda é a branch da feature. Commit ali e `git push` (sem force), para o MR aberto incluir `done` e `closure.md`.
   - **Recusa:** deixar os arquivos sujos e dizer que o merge, ou o MR, ainda não contém o fechamento.

Não fechar em manter, descartar, gate vermelho, ou MR/PR sem URL. Não usar `pr: pending`.

### 6. Registro

Atualizar `executions.md` (seção Fechamento) em qualquer opção:

```markdown
### Fechamento — {data}
- **Gate:** … (verification)
- **Opção:** merge local | MR/PR | manter | descartar
- **Resultado:** … (URL do MR/PR, ou merged-local, ou spec não fechada)
```

## Red flags

- Apresentar menu com testes vermelhos
- Merge/PR sem `mr-template.md` quando a opção 2 foi escolhida — avisar e oferecer `/sdd-08-docs`
- Force push na branch base
- Descartar sem segunda confirmação
- Gravar `done` ou `closure.md` antes do merge ou da URL
- Gravar `done` em manter ou descartar
- Fechar com `pr: pending`
- Commitar o fechamento sem sim explícito
- Incluir nesse commit arquivo fora da pasta da spec
- No merge local, fazer push da branch base junto com esse commit
- No MR/PR, encerrar no primeiro push e deixar `done` / `closure.md` só no working tree

## Saída esperada

Gate verde; escolha do dev executada. Merge ou MR/PR com URL → `status: done`, `concluido`, `pr` e `closure.md`, e o commit desses arquivos pedido em seguida (na base, sem push; na feature, com segundo push). Recusa do commit → fechamento só no working tree, dito no chat. Manter ou descartar → spec não fechada. Worktree limpo se aplicável.
