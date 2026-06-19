# Tasks: Perguntar feature flag ao criar spec SDD

> Spec: [spec.md](./spec.md) · Issue: [1](https://github.com/guskuma/sdd-workflow/issues/1)

## Plano de execução

### Fases

| Fase | Tasks | Depende de | Paralelo? | Modo execução |
|------|-------|------------|-----------|---------------|
| 1 | T01, T02, T06 | — | sim | `parallel-execution` ou `/sdd-06-execute` sequencial |
| 2 | T07, T03, T04 | Fase 1 (T06 antes de T07) | sim (T03∥T04 após T07) | `/sdd-06-execute` |
| 3 | T05 | Fase 2 | — | `/sdd-06-execute` |

> **Paralelo? = sim** — paths disjuntos dentro de cada fase. T07 depende de T06 (template/contrato). T03 depende de T01 + T06 + T07.

### Feature flag

**N/A** — esta spec altera skills/templates Markdown do plugin; sem comportamento em runtime. Decisão no New desta spec: `feature_flag: nao`.

### Impactos (resumo)

| Mudança | Intencional | Risco não intencional |
|---------|-------------|----------------------|
| Pergunta no `/sdd-01-new` (todos os tipos) | Intenção cedo | +1 pergunta por spec |
| § Feature flags estruturado no template/contrato | Padrão claro no projeto-alvo | Template mais longo |
| `/sdd-init` detecta/pergunta padrão | Bootstrap completo | Falso positivo na detecção — confirmar com dev |
| Plan: pergunta padrão se § vazio + opt-in `AGENTS.md` | Dev controla o contrato | Interação extra; agente não deve gravar sem confirmação |
| Bump minor + CHANGELOG | SemVer | Esquecer manifesto |

### Grafo de dependências

```
T06 ──> T07 ──> T03 ──┐
T01 ─────────────> T03 ├──> T05
T02 ──────────────────┤
T04 ──────────────────┘
```

---

## T01: Pergunta feature flag em `sdd-01-new`

| Campo | Valor |
|-------|-------|
| **Entregável** | Skill `sdd-01-new` com passo de pergunta + registro no frontmatter |
| **Onde** | `skills/sdd-01-new/SKILL.md` |
| **Depende de** | — |
| **Bloqueia** | T03, T05 |
| **Paralelo com** | T02, T06 |
| **Requisitos** | RF-01, RF-02, G1, US-01 |

### Steps

- [ ] **Step 1:** Atualizar `description` e **Objetivo** (mencionar TDD + feature flag + branch).
- [ ] **Step 2:** Inserir **§3.1 Perguntar feature flag** após TDD — pergunta para **qualquer** `tipo`; registrar `feature_flag: sim | nao | tbd`; referenciar `AGENTS.md` § Feature flags para padrão de implementação.
- [ ] **Step 3:** Passo 4 — incluir `feature_flag` na lista de campos do frontmatter.

### Definição de pronto (DoD)

- [ ] Passo 3.1 incondicional por tipo
- [ ] Referência ao `AGENTS.md` (não hardcodar ferramenta)
- [ ] `/sdd-07-task-review` aprovado

---

## T02: `feature_flag` no `spec-template.md`

| Campo | Valor |
|-------|-------|
| **Entregável** | Template spec com frontmatter e metadados |
| **Onde** | `skills/sdd-01-new/templates/spec-template.md`, `specs/templates/spec-template.md` |
| **Depende de** | — |
| **Bloqueia** | T05 |
| **Paralelo com** | T01, T06 |
| **Requisitos** | RF-03, G2, CS2 |

### Steps

- [ ] **Step 1:** Frontmatter `feature_flag: nao`
- [ ] **Step 2:** Tabela Metadados — linha `Feature flag | nao (ver AGENTS.md)`
- [ ] **Step 3:** Espelhar em `specs/templates/spec-template.md`

### Definição de pronto (DoD)

- [ ] Ambos os paths idênticos na parte alterada
- [ ] `/sdd-07-task-review` aprovado

---

## T06: Contrato + template `AGENTS.md` § Feature flags

| Campo | Valor |
|-------|-------|
| **Entregável** | Seção Feature flags estruturada no template e documentada no contrato |
| **Onde** | `skills/sdd-init/templates/agents-md-template.md`, `skills/using-sdd/references/agents-md-contract.md` |
| **Depende de** | — |
| **Bloqueia** | T07, T03 |
| **Paralelo com** | T01, T02 |
| **Requisitos** | RF-06, G4, CS5, US-03 |

### Steps

- [ ] **Step 1: `agents-md-template.md`** — substituir placeholder único por:

```markdown
## Feature flags

<!-- N/A se o projeto não usar feature flags -->

| Campo | Valor |
|-------|-------|
| **Mecanismo** | {env-var \| arquivo-config \| servico-externo \| N/A} <!-- ex.: variável de ambiente, config/app.yaml, LaunchDarkly, GitLab Feature Flags --> |
| **Convenção de nome** | {prefixo.flag.nome} |
| **Default seguro** | {false / off} |
| **Path / registro no código** | {path-ou-N/A} |
```

- [ ] **Step 2: `agents-md-contract.md`** — expandir linha Feature flags:

```markdown
| **Feature flags** | Mecanismo (env, arquivo, serviço), convenção de nome, default seguro, path no código | sdd-init, sdd-04-plan |
```

Adicionar subseção **Exemplo mínimo de Feature flags** (bloco markdown genérico, sem hardcodar uma ferramenta).

- [ ] **Step 3:** Validar — nenhuma ferramenta como única opção obrigatória.

### Definição de pronto (DoD)

- [ ] Template estruturado; contrato atualizado
- [ ] `/sdd-07-task-review` aprovado

---

## T07: Detecção/pergunta em `sdd-init`

| Campo | Valor |
|-------|-------|
| **Entregável** | Skill init detecta ou pergunta padrão de feature flags |
| **Onde** | `skills/sdd-init/SKILL.md` |
| **Depende de** | T06 |
| **Bloqueia** | T03 |
| **Paralelo com** | — (sequencial após T06) |
| **Requisitos** | RF-05, G4, CS4, US-03 |

### Steps

- [ ] **Step 1: Passo 1 — tabela de detecção**

Adicionar linha:

```markdown
| **Feature flags** | `package.json`/deps (LaunchDarkly, Unleash, Flagsmith), `.gitlab-ci.yml`, configs (`config/*.yml`, `.env.example`), código (`featureFlag`, `FEATURE_`) |
```

- [ ] **Step 2: Passo 2 — questões típicas**

Adicionar bullets:

```markdown
   - "O projeto usa feature flags? Se sim, qual o **mecanismo** (env var, arquivo, serviço externo)?"
   - "Qual a **convenção de nome** e o **default seguro**?"
   - "Onde ficam registradas no código (**path**)?"
```

- [ ] **Step 3: Passo 3 — preenchimento**

Instruir: preencher § Feature flags com tabela do template (T06); modo **update** não sobrescreve conteúdo real; confirmação se conflito detecção vs manual.

- [ ] **Step 4:** Resumo no passo 2 inclui feature flags quando detectado/perguntado.

### Definição de pronto (DoD)

- [ ] Detecção + pergunta documentadas
- [ ] Idempotência preservada
- [ ] `/sdd-07-task-review` aprovado

---

## T03: Reavaliação + opt-in `AGENTS.md` em `sdd-04-plan`

| Campo | Valor |
|-------|-------|
| **Entregável** | Skill Plan: reavaliação + fluxo § Feature flags vazio com confirmação expressa |
| **Onde** | `skills/sdd-04-plan/SKILL.md` |
| **Depende de** | T01, T06, T07 |
| **Bloqueia** | T05 |
| **Paralelo com** | T04 |
| **Requisitos** | RF-04, G3, CS3, US-02, US-04 |

### Steps

- [ ] **Step 1: Substituir §3 Feature flags**

```markdown
### 3. Feature flags

Ler `feature_flag` do frontmatter de `spec.md`:

| Valor | Ação |
|-------|------|
| `sim` | **Reavaliar** com o dev: impactos, complexidade adicional, consequências intencionais e não intencionais. Confirmar ou ajustar antes de detalhar flag. |
| `nao` | Registrar **"Feature flag: N/A"** em `tasks.md` com justificativa (decisão do New). |
| `tbd` | Conduzir decisão com a mesma análise; atualizar frontmatter após alinhamento. |
| ausente (legado) | Avaliar "quando condizente" (comportamento legado). |

**Consultar `AGENTS.md` § Feature flags** (mecanismo, convenção, default, path).

**Se § Feature flags vazio, placeholder ou `N/A` genérico** e a spec confirmar uso de flag (`sim`/`tbd`):

1. **Perguntar** ao dev: mecanismo, convenção de nome, default seguro, path/registro no código.
2. **Perguntar explicitamente:** "Deseja que eu **atualize o `AGENTS.md`** com esse padrão?"
3. **Só alterar `AGENTS.md`** após **confirmação expressa** do dev.
4. Se o dev **recusar** atualizar: documentar o padrão apenas em `tasks.md` § Feature flag (spec corrente); **não** modificar `AGENTS.md`.

Quando confirmado `sim`:

- Propor nome/default/task conforme padrão do `AGENTS.md` (ou o informado no passo 1).
- Documentar em `tasks.md` § Feature flag.
- Atualizar frontmatter se decisão mudar após reavaliação.
```

- [ ] **Step 2:** Entregável no topo — mencionar reavaliação + opt-in `AGENTS.md`.

- [ ] **Step 3:** Revisão — proibir escrita em `AGENTS.md` sem confirmação expressa.

### Definição de pronto (DoD)

- [ ] Fluxo vazio → pergunta → opt-in → só grava com confirmação
- [ ] Recusa documentada em `tasks.md` only
- [ ] `/sdd-07-task-review` aprovado

---

## T04: Comando + README

| Campo | Valor |
|-------|-------|
| **Entregável** | Slash command e README alinhados |
| **Onde** | `commands/sdd-01-new.md`, `README.md` |
| **Depende de** | T01 |
| **Bloqueia** | T05 |
| **Paralelo com** | T03 |
| **Requisitos** | RF-07, CS7 |

### Steps

- [ ] **Step 1:** `commands/sdd-01-new.md` — description com TDD + feature flag.
- [ ] **Step 2:** `README.md` — linha skills: "TDD e feature flag decididos no `01-new`; padrão de implementação no `AGENTS.md` (`/sdd-init`)."

### Definição de pronto (DoD)

- [ ] Command + README atualizados
- [ ] `/sdd-07-task-review` aprovado

---

## T05: Versionamento SemVer + CHANGELOG

| Campo | Valor |
|-------|-------|
| **Entregável** | Versão `0.4.0` + CHANGELOG |
| **Onde** | `package.json`, `plugin.json`, `.cursor-plugin/plugin.json`, `.claude-plugin/plugin.json`, `gemini-extension.json`, `.github/plugin/marketplace.json`, `.claude-plugin/marketplace.json`, `CHANGELOG.md` |
| **Depende de** | T01–T04, T06, T07 |
| **Requisitos** | RF-08, G6, CS8 |

### Steps

- [ ] **Step 1:** Bump `0.4.0` em todos os manifestos.
- [ ] **Step 2:** Validar JSONs (`python3 -m json.tool`).
- [ ] **Step 3:** `CHANGELOG.md`:

```markdown
## [0.4.0] - 2026-06-19

### Added

- `/sdd-01-new` pergunta feature flag (qualquer tipo) e registra `feature_flag` no frontmatter.
- `/sdd-04-plan` reavalia feature flag; se § Feature flags do `AGENTS.md` vazio, pergunta padrão e opt-in para atualizar o arquivo (só com confirmação expressa).
- `/sdd-init` detecta ou pergunta padrão de feature flags no bootstrap.
- § Feature flags estruturado em `agents-md-template.md` e `agents-md-contract.md`.
- Campo `feature_flag` em `spec-template.md`.
```

### Definição de pronto (DoD)

- [ ] Todos manifestos `0.4.0`; JSONs válidos; CHANGELOG ok
- [ ] `/sdd-07-task-review` aprovado
