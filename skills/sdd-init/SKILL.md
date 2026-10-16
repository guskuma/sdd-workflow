---
name: sdd-init
description: >-
  Bootstrap do projeto para o fluxo SDD: analisa o repositório e gera
  AGENTS.md, CLAUDE.md e GEMINI.md. Idempotente — em repositório já
  inicializado, audita desalinhamentos com o contrato atual, lista o que
  mudaria e só atualiza com confirmação. Use com /sdd-init.
---

# SDD — Init (bootstrap do projeto)

## Objetivo

Analisar o repositório-alvo, gerar ou atualizar `AGENTS.md` com o que for detectável, e criar `CLAUDE.md` e `GEMINI.md` apontando para ele — reduzindo a barreira de entrada no fluxo SDD.

Em repo **já** com SDD: verificar o que está ausente ou desatualizado frente ao contrato atual do plugin, **listar** as mudanças propostas e **só aplicar** o que o dev confirmar.

## Templates e referências

| Artefato | Destino / uso |
|----------|----------------|
| `skills/sdd-init/templates/agents-md-template.md` | `AGENTS.md` (raiz) |
| `skills/sdd-init/templates/claude-md-template.md` | `CLAUDE.md` (raiz) |
| `skills/sdd-init/templates/gemini-md-template.md` | `GEMINI.md` (raiz) |
| `skills/sdd-init/references/agents-md-audit.md` | Checklist de audit (modo update) |
| `skills/using-sdd/references/agents-md-contract.md` | Contrato de referência (não copiar direto) |

## Iron Law

```
EM MODO UPDATE: NENHUM UPGRADE ESTRUTURAL SEM LISTA SUCINTA + CONFIRMAÇÃO DO DEV
```

Preencher placeholder óbvio (`{...}`, `<!-- TODO -->`) nas seções já existentes **pode** seguir após o resumo do audit — mas inserir seções novas, reescrever árvore de specs, normalizar tabelas ou editar `CLAUDE.md`/`GEMINI.md` existentes exige confirmação explícita dos itens listados.

## Passo 0 — Verificar estado atual

1. Verificar se `AGENTS.md` existe na raiz do repositório.
2. Definir modo:
   - **create** — `AGENTS.md` ausente; gerar arquivo novo.
   - **update** — `AGENTS.md` presente; seguir Passo 0b (audit) antes de escrever.
3. Informar o dev qual modo será usado.

## Passo 0b — Audit de alinhamento (somente modo update)

**Obrigatório** quando `AGENTS.md` já existe. Ler a checklist em `skills/sdd-init/references/agents-md-audit.md` e aplicar contra `AGENTS.md`, `CLAUDE.md` e `GEMINI.md`.

1. Classificar cada finding: `lacuna` | `desatualizado` | `relacionado` (definições na checklist).
2. Se **não** houver findings: informar “alinhado ao contrato atual” e seguir para Passo 1 só se ainda faltarem valores detectáveis em placeholders; senão ir ao Passo 6.
3. Se houver findings: apresentar lista **sucinta** (uma linha por item: `[ID] (tag) o quê — por quê`), sem dump do arquivo inteiro.
4. Oferecer opções (múltipla escolha):
   - **Atualizar tudo** listado
   - **Escolher itens** (dev indica IDs)
   - **Só lacunas** (seções/campos ausentes ou placeholder; sem reescrita estrutural)
   - **Nada agora** (encerrar sem escrever, ou só reportar)
5. **Não escrever** upgrades até a resposta. Conteúdo específico do projeto (comandos, URLs, paths reais) permanece intocado salvo pedido explícito.
6. Guardar o conjunto confirmado para o Passo 3.

### Red flags (audit)

| Racionalização | Realidade |
|----------------|-----------|
| "Já tem AGENTS.md, init é no-op" | Audit obrigatório — contrato do plugin pode ter evolução |
| "Vou modernizar tudo sem perguntar" | Viola Iron Law; listar + confirmar |
| "Árvore de specs diferente = errada" | Só flagar se faltar artefato do contrato; não julgar layout de código |
| "CLAUDE.md grande → reescrever" | Só acrescentar referência ao `AGENTS.md` com confirmação |

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
| **Feature flags** | `package.json`/deps (LaunchDarkly, Unleash, Flagsmith), `.gitlab-ci.yml`, configs (`config/*.yml`, `.env.example`), código (`featureFlag`, `FEATURE_`) |
| **Nome/descrição do projeto** | `package.json` (`name`, `description`), `pyproject.toml`, `README.md` (primeiro parágrafo) |

**Não inventar valores.** Se não conseguir detectar com confiança, marcar como incerto e perguntar no passo 2.

## Passo 2 — Apresentar descobertas e confirmar

1. Resumir no chat: stack, gates sugeridos, issue tracker, branch base, estrutura de pastas, integrações, feature flags (quando detectado ou perguntado).
2. Perguntar o que falta ou precisa de ajuste — **uma pergunta por mensagem**, preferindo múltipla escolha.
3. Questões típicas:
   - "O gate iterativo é `{comandos detectados}`?"
   - "O issue tracker é GitHub Issues em `{url}`?"
   - "A branch base é `{branch}`?"
   - "Integração `{X}` fica fora do TDD por padrão?"
   - "O projeto usa feature flags? Se sim, qual o **mecanismo** (env var, arquivo, serviço externo)?"
   - "Qual a **convenção de nome** e o **default seguro**?"
   - "Onde ficam registradas no código (**path**)?"
4. Se o dev dispensar confirmações (modo rápido), prosseguir com o que foi detectado e deixar placeholders onde faltar.
5. Em modo update: não repetir perguntas já respondidas no Passo 0b; só perguntar valores necessários para os itens confirmados.

## Passo 3 — Gerar ou atualizar `AGENTS.md`

### Modo create

1. Usar `skills/sdd-init/templates/agents-md-template.md` como base.
2. Substituir placeholders `{...}` com valores detectados e confirmados.
3. Seções sem dados: manter `<!-- TODO: preencher -->` ou equivalente explícito.
4. Escrever `AGENTS.md` na raiz do repositório.

### Modo update

1. Ler o `AGENTS.md` existente por seção (`## Stack`, `## Gate de qualidade`, etc.).
2. Aplicar **somente** o conjunto confirmado no Passo 0b (e valores confirmados no Passo 2):
   - **lacuna** — inserir seções/campos ausentes; preencher placeholders/`TODO`/`{...}`.
   - **desatualizado** — alinhar forma ao template/contrato (ex.: subseções do Gate, colunas da tabela de integrações, árvore de specs, § Feature flags); **preservar** valores reais já preenchidos.
   - Remoções (A7) — só com ID explicitamente confirmado.
3. **Não alterar** seções com conteúdo real fora da lista confirmada.
4. Se houver conflito (detecção difere do manual), **perguntar** antes de sobrescrever.
5. Preencher § **Feature flags** com a tabela do template quando o item correspondente foi confirmado e o valor detectado/confirmado pelo dev.

### Seções obrigatórias (conforme contrato)

Stack, Gate de qualidade, Issue tracker, Branches Git, Integrações externas, Restrições padrão, Convenção de pastas (specs), Mapa de research, Mapa de documentação, Feature flags.

## Passo 4 — Gerar ou ajustar `CLAUDE.md`

1. Se **não existir**: criar a partir de `skills/sdd-init/templates/claude-md-template.md`.
   - Preencher `{nome-do-projeto}` e `{descricao-breve-do-projeto}`.
   - Manter referência ao `AGENTS.md`.
2. Se **já existir**:
   - **Não** sobrescrever o arquivo inteiro.
   - Se R1 foi confirmado no Passo 0b e falta referência ao `AGENTS.md`: acrescentar o parágrafo do template (ou equivalente mínimo).
   - Se R1 não foi confirmado: apenas avisar.

## Passo 5 — Gerar ou ajustar `GEMINI.md`

1. Se **não existir**: criar a partir de `skills/sdd-init/templates/gemini-md-template.md` (`@./AGENTS.md`).
2. Se **já existir**:
   - **Não** sobrescrever o arquivo inteiro.
   - Se R2 foi confirmado e falta import: acrescentar `@./AGENTS.md`.
   - Se R2 não foi confirmado: apenas avisar.

## Passo 6 — Resumo e próximo passo

1. Listar arquivos criados ou atualizados e, em modo update, os **IDs do audit** aplicados.
2. Indicar placeholders / `TODO` restantes no `AGENTS.md`.
3. Findings **não** aplicados (dev escolheu pular): mencionar em uma linha.
4. Sugerir `/sdd-01-new` como próximo passo se ainda não houver spec em andamento.

## Restrições

- Não alterar código de produção.
- Não commitar nem fazer push.
- Não aplicar upgrade estrutural sem lista + confirmação (Iron Law).
- Não inventar valores — perguntar ou deixar placeholder.
- Não remover seções existentes sem ID de audit confirmado (A7).
- Não tratar conteúdo específico do projeto como “errado” só por diferir do template.

## Saída esperada

`AGENTS.md` criado ou atualizado na raiz; `CLAUDE.md` e `GEMINI.md` criados se ausentes (apontando para `AGENTS.md`). Em modo update: audit listado, upgrades só com confirmação. Dev informado sobre lacunas restantes e próximo passo (`/sdd-01-new`).
