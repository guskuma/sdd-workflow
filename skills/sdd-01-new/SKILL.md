---
name: sdd-01-new
description: >-
  Fase New do SDD: inicia uma mudança rastreável (feat, fix, refactor, etc.). Lê a issue,
  cria a pasta da spec, pergunta sobre TDD e feature flag, e sugere a branch. Use com
  /sdd-01-new ou ao começar qualquer mudança que deva ser registrada em spec.
---

# SDD — Nova spec

## Objetivo

Criar a pasta e os arquivos iniciais de uma spec SDD, coletar informações essenciais (incluindo a issue), e registrar decisões de TDD, feature flag e branch.

## Contexto do projeto

Consultar o `AGENTS.md` (raiz do repositório) para: issue tracker/MR, branch base, integrações excluídas de TDD por padrão, subsistemas do projeto.

## Escopo do SDD

Aplica-se a **qualquer mudança** rastreável em spec: feature, bug/fix, alteração de comportamento, refactor, performance, chore, docs.

## Entrada esperada do dev (perguntar se faltar)

- **Issue key** (ex.: `PROJ-1234`) — opcional se o projeto não usar issue tracker
- **Tipo** da mudança: `feat` | `fix` | `refactor` | `perf` | `chore` | `docs`
- **Slug curto** (ex.: `ajuste-api`)
- **Título e contexto** em 1–2 frases

## Passo 0 — Garantir o scaffold dos templates

Os templates do SDD ficam **empacotados no plugin** (`skills/sdd-01-new/templates/`). Na primeira spec do repositório:

1. Verificar se existe `specs/templates/` no projeto.
2. Se **não** existir, copiar os templates do plugin para `specs/templates/` do repositório:
   - `spec-template.md`, `executions-template.md`, `tasks-template.md`, `design-template.md`,
     `issue-summary-template.md`, `mr-template.md`, `sdd-tdd.md`, `sdd-restricoes.md`,
     `sdd-branch.md`, `implementation-log-entry.md`
3. Garantir que existe `specs/implementation-log.md` (criar vazio com cabeçalho se faltar).

> Onde a skill referencia `specs/templates/X.md`, é esse o local (já no repositório após o scaffold).

## Passos

### 1. Validar entrada e gate de decomposição

- Coletar issue key, `tipo`, slug, título e contexto (perguntar o que faltar).
- Ler a issue conforme `AGENTS.md` (ferramenta do projeto) para obter summary, descrição e anexos.
- Se conseguir ler a issue, usar essas informações para reduzir perguntas manuais ao dev.
- Se o pedido envolver **≥2 subsistemas independentes** (ver `AGENTS.md`), **avisar no chat antes de criar a pasta** e perguntar:
  - Uma spec para tudo
  - Dividir em várias specs (listar sugestões)
  - Uma spec com fases explícitas
- Se o dev optar por **várias specs**: criar pasta **apenas da primeira**; listar as demais sugeridas no chat.

### 2. Coletar "Por quê?"

- Usar primeiro o conteúdo da issue (summary + descrição) como base do **Por quê?**.
- Se as 1–2 frases **não deixarem claro** o quê e o porquê: **uma pergunta por mensagem** (preferir múltipla escolha).
- **Modo rápido:** se issue + contexto já estiverem completos, não insistir em perguntas sequenciais.
- O texto final vai para **Por quê?** em `spec.md` (passo 3).

### 3. Perguntar TDD

Perguntar ao dev:

> "Esta spec usará **TDD** (red → green → refactor por task)?"

- Registrar a resposta no frontmatter de `spec.md`: `tdd: true | false`.
- Seguir as convenções de `specs/templates/sdd-tdd.md` e as integrações em `AGENTS.md`.

### 3.1 Perguntar feature flag

Perguntar ao dev **independentemente do `tipo`**:

> "Esta spec usará **feature flag** (habilitar/desabilitar o comportamento sem impactar outras partes do sistema)?"

- Registrar a resposta no frontmatter de `spec.md`: `feature_flag: sim | nao | tbd`.
- Consultar `AGENTS.md` § **Feature flags** para o padrão de implementação do projeto-alvo (mecanismo, convenção, default, path) — **não** hardcodar ferramenta na skill.

### 4. Criar pasta e copiar templates

1. Pasta: `specs/{YYYY-MM}-{ISSUE-KEY-ou-slug}/`
2. Copiar `specs/templates/spec-template.md` → `spec.md`
   - Preencher frontmatter: `issue`, `tipo`, `titulo`, `branch`, `tdd`, `tdd_integracao`, `feature_flag`, `criado`, `autor`
   - Preencher o link da issue com a URL base de `AGENTS.md` (ou `N/A`)
   - Preencher a seção **Por quê?** com o contexto coletado no passo 2
3. Copiar `specs/templates/executions-template.md` → `executions.md`
4. Copiar `specs/templates/issue-summary-template.md` → `issue-summary.md` e preencher (se houver issue):
   - campos principais (summary, status, assignee, labels);
   - resumo do body;
   - anexos `.md` incorporados (quando aplicável);
   - anexos não `.md` apenas como referência (nome/link), sem versionar arquivo.
5. Resolver o template de MR/PR (esqueleto; preenchimento só no `/sdd-09-docs`) e copiar para `mr-template.md` na pasta da spec:
   1. Se existir `.gitlab/`, procurar em `.gitlab/merge_request_templates/`.
   2. Senão, se existir `.github/`, procurar em `.github/PULL_REQUEST_TEMPLATE.md` ou `.github/PULL_REQUEST_TEMPLATE/`.
   3. Senão, usar `specs/templates/mr-template.md` (template bundled do plugin).
   4. **Seleção entre múltiplos templates:** tentar deduzir pelo `tipo` da spec (ex.: `feat.md`, `fix.md`, `Default.md`). Se não houver correspondência clara, **perguntar ao dev**.
   5. Registrar em `executions.md` a origem do template escolhido (path do arquivo).

### 5. Branch Git

Seguir o fluxo completo em `specs/templates/sdd-branch.md` e a branch base em `AGENTS.md`:

- Comunicar a branch base padrão e perguntar se o dev prefere outra antes de criar.
- Criar a branch de trabalho `{tipo}/{ISSUE-KEY-ou-slug}` só após confirmação explícita.
- Registrar a branch de trabalho **e** a branch base usada em `spec.md` e `executions.md`.

### 6. TDD — escopo de integrações (se `tdd: true`)

Se o contexto inicial já indicar integrações excluídas do TDD em `AGENTS.md`:

1. **Avisar** o dev que TDD nessas integrações fica **fora do escopo por padrão**.
2. Perguntar se deseja incluir alguma integração no TDD.
3. Registrar em `spec.md` frontmatter: `tdd_integracao: fora` ou `incluir: area1,area2` (conforme opt-in).

## Restrições

- Não implementar código de produção.
- Não preencher To Be nem As Is (além do **Por quê?** inicial).
- Não criar branch sem confirmação explícita do dev.

## Saída esperada

Pasta da spec criada com `spec.md`, `executions.md`, `issue-summary.md` e `mr-template.md` (esqueleto). Branch sugerida ou criada. Próximo passo: `/sdd-02-research`.
