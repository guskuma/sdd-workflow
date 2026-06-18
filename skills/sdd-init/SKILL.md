---
name: sdd-init
description: >-
  Bootstrap do projeto para o fluxo SDD: analisa o repositório e gera
  AGENTS.md, CLAUDE.md e GEMINI.md. Idempotente — preserva edições
  manuais e preenche lacunas. Use com /sdd-init.
---

# SDD — Init (bootstrap do projeto)

## Objetivo

Analisar o repositório-alvo, gerar ou atualizar `AGENTS.md` com o que for detectável, e criar `CLAUDE.md` e `GEMINI.md` apontando para ele — reduzindo a barreira de entrada no fluxo SDD.

## Templates empacotados

| Template | Destino no projeto-alvo |
|----------|-------------------------|
| `skills/sdd-init/templates/agents-md-template.md` | `AGENTS.md` (raiz) |
| `skills/sdd-init/templates/claude-md-template.md` | `CLAUDE.md` (raiz) |
| `skills/sdd-init/templates/gemini-md-template.md` | `GEMINI.md` (raiz) |

Contrato de referência (não copiar diretamente): `skills/using-sdd/references/agents-md-contract.md`.

## Passo 0 — Verificar estado atual

1. Verificar se `AGENTS.md` existe na raiz do repositório.
2. Definir modo:
   - **create** — `AGENTS.md` ausente; gerar arquivo novo.
   - **update** — `AGENTS.md` presente; preservar seções já preenchidas pelo dev; preencher apenas lacunas, placeholders (`{...}`, `<!-- TODO -->`, `N/A` genérico) ou seções ausentes.
3. Informar o dev qual modo será usado.

## Passo 1 — Análise automática do repositório

Explorar o projeto **antes** de perguntar. Fontes de detecção:

| O que detectar | Onde procurar |
|----------------|---------------|
| **Linguagem/framework** | `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `pom.xml`, `build.gradle(.kts)`, `Gemfile`, `*.csproj`/`*.sln`, `composer.json`, `Makefile`, `CMakeLists.txt` |
| **Comandos lint/test/build** | Scripts em `package.json`, targets de `Makefile`, `[tool.*]` em `pyproject.toml`, CI (`.github/workflows/*.yml`, `.gitlab-ci.yml`), `Cargo.toml` |
| **Issue tracker** | `.github/` (GitHub Issues), remote GitLab, prefixos em commits recentes (ex.: `PROJ-1234`), configs de CI |
| **Branch base** | `git symbolic-ref refs/remotes/origin/HEAD`, branch padrão do remote |
| **Convenção de branches** | `git branch -r` — padrões `feat/`, `fix/`, etc. |
| **Estrutura de pastas** | Diretórios top-level e primeiro nível (`src/`, `lib/`, `app/`, `tests/`, `docs/`, etc.) |
| **Integrações externas** | Docker/docker-compose, configs de DB, clients HTTP, SDKs de serviços |
| **Docs existentes** | `README.md`, `docs/`, `CONTRIBUTING.md`, OpenAPI/Swagger |
| **Nome/descrição do projeto** | `package.json` (`name`, `description`), `pyproject.toml`, `README.md` (primeiro parágrafo) |

**Não inventar valores.** Se não conseguir detectar com confiança, marcar como incerto e perguntar no passo 2.

## Passo 2 — Apresentar descobertas e confirmar

1. Resumir no chat: stack, gates sugeridos, issue tracker, branch base, estrutura de pastas, integrações.
2. Perguntar o que falta ou precisa de ajuste — **uma pergunta por mensagem**, preferindo múltipla escolha.
3. Questões típicas:
   - "O gate iterativo é `{comandos detectados}`?"
   - "O issue tracker é GitHub Issues em `{url}`?"
   - "A branch base é `{branch}`?"
   - "Integração `{X}` fica fora do TDD por padrão?"
4. Se o dev dispensar confirmações (modo rápido), prosseguir com o que foi detectado e deixar placeholders onde faltar.

## Passo 3 — Gerar ou atualizar `AGENTS.md`

### Modo create

1. Usar `skills/sdd-init/templates/agents-md-template.md` como base.
2. Substituir placeholders `{...}` com valores detectados e confirmados.
3. Seções sem dados: manter `<!-- TODO: preencher -->` ou equivalente explícito.
4. Escrever `AGENTS.md` na raiz do repositório.

### Modo update

1. Ler o `AGENTS.md` existente por seção (`## Stack`, `## Gate de qualidade`, etc.).
2. **Não alterar** seções com conteúdo real preenchido pelo dev.
3. Inserir seções ausentes a partir do template.
4. Atualizar apenas linhas com placeholder, `TODO`, `{...}` ou valores claramente genéricos.
5. Se houver conflito (detecção difere do manual), **perguntar** antes de sobrescrever.

### Seções obrigatórias (conforme contrato)

Stack, Gate de qualidade, Issue tracker, Branches Git, Integrações externas, Restrições padrão, Convenção de pastas (specs), Mapa de research, Mapa de documentação, Feature flags.

## Passo 4 — Gerar `CLAUDE.md`

1. Se **não existir**: criar a partir de `skills/sdd-init/templates/claude-md-template.md`.
   - Preencher `{nome-do-projeto}` e `{descricao-breve-do-projeto}`.
   - Manter referência ao `AGENTS.md`.
2. Se **já existir**: **não sobrescrever**.
   - Avisar o dev.
   - Se não houver referência ao `AGENTS.md`, sugerir adicionar o parágrafo do template (não editar sem confirmação).

## Passo 5 — Gerar `GEMINI.md`

1. Se **não existir**: criar a partir de `skills/sdd-init/templates/gemini-md-template.md` (`@./AGENTS.md`).
2. Se **já existir**: **não sobrescrever**.
   - Avisar o dev.
   - Se não importar `AGENTS.md`, sugerir `@./AGENTS.md` (não editar sem confirmação).

## Passo 6 — Resumo e próximo passo

1. Listar arquivos criados ou atualizados.
2. Indicar placeholders / `TODO` restantes no `AGENTS.md`.
3. Sugerir `/sdd-01-new` como próximo passo para iniciar a primeira spec.

## Restrições

- Não alterar código de produção.
- Não commitar nem fazer push.
- Não sobrescrever conteúdo já preenchido pelo dev (modo update).
- Não inventar valores — perguntar ou deixar placeholder.
- Não remover seções existentes no modo update.

## Saída esperada

`AGENTS.md` criado ou atualizado na raiz; `CLAUDE.md` e `GEMINI.md` criados se ausentes (apontando para `AGENTS.md`). Dev informado sobre lacunas e próximo passo (`/sdd-01-new`).
