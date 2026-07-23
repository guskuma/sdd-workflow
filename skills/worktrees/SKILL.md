---
name: worktrees
description: >-
  Isola o trabalho da spec em git worktree (ou ferramenta nativa da plataforma). Opt-in
  no /sdd-06-execute — só após o dev aprovar. Detecta isolamento existente antes de criar.
---

# Git worktrees (opt-in)

## Objetivo

Executar a implementação da spec em workspace isolado, sem sujar o checkout principal.

**Iron Law:**

```
DETECTAR ISOLAMENTO EXISTENTE ANTES DE CRIAR; NUNCA LUTAR CONTRA O HARNESS
```

Preferir tool nativa da plataforma (`EnterWorktree`, `/worktree`, etc.) → fallback `git worktree`.

## Quando invocar

**Somente** quando o dev **aprovar** o opt-in em `/sdd-06-execute`:

> "Deseja isolar o trabalho em um git worktree? (protege a branch/checkout atual)"

- **Sim** → esta skill
- **Não** → continuar no workspace atual; registrar "Worktree: dispensado"
- Preferência já declarada no chat/`AGENTS.md` → honrar sem perguntar de novo

Também: se `finish-branch` precisar limpar worktree criado aqui.

## Passo 0 — Já está isolado?

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
# Submodule? Se retornar path, NÃO é worktree — tratar como repo normal
git rev-parse --show-superproject-working-tree 2>/dev/null
```

| Resultado | Ação |
|-----------|------|
| `GIT_DIR != GIT_COMMON` e não é submodule | Já isolado — **não** criar outro; reportar path + branch |
| Repo normal / submodule | Seguir criação (se opt-in) |

## Passo 1 — Criar workspace

### 1a. Tool nativa (preferida)

Se a plataforma expuser criação de worktree, usar **só** ela. `git worktree add` paralelo cria estado fantasma que o harness não gerencia.

### 1b. Fallback git

1. Diretório (prioridade): preferência do dev → `.worktrees/` → `worktrees/`.
2. **Obrigatório:** o diretório deve estar no `.gitignore`. Se não estiver, adicionar e pedir commit ao dev (ou commitar só se o dev pedir).
3. Branch: a da spec (já sugerida em `/sdd-01-new` / metadados) ou criar a partir da base (`AGENTS.md`).

```bash
git worktree add "$LOCATION/$BRANCH_NAME" -b "$BRANCH_NAME"   # nova branch
# ou, se a branch já existe:
git worktree add "$LOCATION/$BRANCH_NAME" "$BRANCH_NAME"
cd "$LOCATION/$BRANCH_NAME"
```

Se a sandbox bloquear → avisar; trabalhar no checkout atual; registrar degradação.

## Passo 2 — Setup do projeto

Rodar o setup mínimo do stack conforme `AGENTS.md` / arquivos do repo (`npm install`, etc.) — sem inventar stack.

## Passo 3 — Baseline (opcional mas recomendado)

Se o `AGENTS.md` tiver gate iterativo barato, rodar uma vez para confirmar workspace limpo. Falha de baseline → reportar antes de implementar (pode ser ambiente, não a spec).

## Registro

No registro final de `executions.md` (via 06):

```markdown
**Worktree:** {path} (branch {nome}) | dispensado | degradação: working tree atual
```

## Cleanup

Não remover worktree no meio do execute. Cleanup fica em **`finish-branch`** após merge/PR/discard, com confirmação se necessário:

```bash
git worktree remove "$PATH"
# se branch já mergeada e o dev pedir:
git branch -d "$BRANCH_NAME"
```

## Red flags

- Criar worktree sem opt-in do dev
- Segundo worktree quando já está isolado
- Diretório de worktrees **não** ignorado pelo git
- Assumir stack de setup (sempre `AGENTS.md` / manifests do repo)

## Saída esperada

CWD no workspace isolado (ou confirmação de isolamento existente); branch da spec pronta; registro no execute.
