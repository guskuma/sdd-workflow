---
issue: "1"
tipo: feat
titulo: Perguntar feature flag ao criar spec SDD
branch: feat/1-feature-flag-spec-question
tdd: false
tdd_integracao: fora
status: done
criado: 2026-06-19
autor: @guskuma
---

# Spec: Perguntar feature flag ao criar spec SDD

## Metadados

| Campo | Valor |
|-------|-------|
| Issue | [1](https://github.com/guskuma/sdd-workflow/issues/1) |
| Tipo | feat |
| Branch | `feat/1-feature-flag-spec-question` |
| TDD | `false` · integrações: `fora` (ver [sdd-tdd.md](../templates/sdd-tdd.md) e [AGENTS.md](../../AGENTS.md)) |
| Pasta | `specs/2026-06-1-feature-flag-spec-question/` |
| Status | done |

**Tipos:** `feat` (feature/comportamento novo), `fix` (bug), `refactor`, `perf`, `chore`, `docs`.

## Por quê?

O fluxo SDD hoje só trata feature flags na fase **Plan** (`sdd-04-plan`), quando o agente propõe flag “quando condizente”. A [issue #1](https://github.com/guskuma/sdd-workflow/issues/1) pede que, **ao iniciar uma spec**, o plugin pergunte se a mudança usará feature flag — ou seja, se deve permitir habilitar/desabilitar o comportamento sem impactar outras partes do sistema.

**Análise inicial (New):**

1. **Tipos além de `feat`:** feature flag não é exclusiva de features. `fix` (kill switch / rollout gradual), `refactor` (strangler: caminho antigo vs novo) e `perf` (A/B ou rollout) podem usar flag. `chore`/`docs` em geral N/A. A pergunta deve ser **condicional por `tipo`**, não limitada a `feat`.
2. **Onde padronizar:** separar responsabilidades — **como/onde no código** do projeto-alvo → `AGENTS.md` (já previsto no contrato); **quando perguntar e o que registrar na spec** → skills/templates genéricos do plugin (`sdd-01-new`, `spec-template`, encadeamento em `sdd-04-plan`).
3. **Impactos:** evitar pergunta duplicada sem propósito (New = intenção; Plan = detalhe); frontmatter na spec; critérios de aceite e DoD em Execute; revisão em Spec review; versionamento SemVer do plugin; template `AGENTS.md` do `sdd-init` já tem seção Feature flags.

## 1. As Is (Research)

### Contexto

O **SDD Plugin** é um pacote multiplataforma (Cursor, Claude, Codex, Copilot, Gemini, OpenCode) de skills Markdown que guiam o fluxo Spec-Driven Development. A fonte única de skills fica em `skills/`; templates SDD empacotados em `skills/sdd-01-new/templates/` são copiados para `specs/templates/` no projeto-alvo na primeira spec (`/sdd-01-new`).

Decisões **genéricas** (quando perguntar, o que registrar na spec) vivem nas skills/templates. Decisões **específicas do projeto-alvo** (ferramenta de flags, convenção de nome, path no código) vivem no `AGENTS.md` — seção **Feature flags**, prevista no [contrato](skills/using-sdd/references/agents-md-contract.md) e scaffoldada pelo `sdd-init`.

Neste repositório (plugin), `AGENTS.md` § Feature flags = `N/A` (correto — o plugin não usa flags em runtime).

A [issue #1](https://github.com/guskuma/sdd-workflow/issues/1) pede capturar a **intenção de feature flag cedo**, no fluxo de criação de spec — análogo ao que já existe para TDD.

### Comportamento atual

**Fase New (`sdd-01-new`)** — única pergunta de opt-in antecipada hoje é **TDD** (passo 3):

```63:70:skills/sdd-01-new/SKILL.md
### 3. Perguntar TDD

Perguntar ao dev:

> "Esta spec usará **TDD** (red → green → refactor por task)?"

- Registrar a resposta no frontmatter de `spec.md`: `tdd: true | false`.
- Seguir as convenções de `specs/templates/sdd-tdd.md` e as integrações em `AGENTS.md`.
```

Não há passo equivalente para feature flag. O frontmatter de `spec-template.md` inclui `tdd` e `tdd_integracao`, mas **não** campo de feature flag. A tabela de metadados em `spec.md` exibe TDD, sem linha para flag.

**Convenção centralizada TDD** — existe `sdd-tdd.md` (bundled + scaffoldado) documentando opt-in no New, ciclo por fase e legado. **Não existe** `sdd-feature-flag.md` equivalente.

**Fase Plan (`sdd-04-plan`)** — feature flag tratada **tardiamente e reativamente** (passo 3):

```72:78:skills/sdd-04-plan/SKILL.md
### 3. Feature flags (quando condizente)

Se a spec envolver comportamento novo em produção, risco de rollback ou ativação gradual:

- Propor **feature flag** conforme o padrão em `AGENTS.md`.
- Incluir task para a flag + default seguro + documentar em spec/design.
- Se não aplicável, registrar **"Feature flag: N/A"** com justificativa.
```

O `tasks-template.md` já prevê seção **Feature flag** (tabela nome/default/task ou N/A + link ao `AGENTS.md`).

**Demais fases** — sem menção explícita a feature flag:

| Fase | Skill | Feature flag |
|------|-------|--------------|
| Research | `sdd-02-research` | — |
| Specify | `sdd-03-specify` | — (só reavalia TDD/integrações) |
| Execute | `sdd-06-execute` | — (só TDD) |
| Task review | `sdd-07-task-review` | — (só TDD) |
| Spec review | `sdd-08-spec-review` | — |
| Docs | `sdd-09-docs` | — |

**Restrições** — `sdd-restricoes.md` cita feature flags na categoria **Dados / deploy** (migrations, ordem de deploy, flags), mas sem fluxo de captura no New.

**Documentação pública** — `README.md` menciona TDD decidido no `01-new`; não menciona feature flag na fase New.

**Comando espelho** — `commands/sdd-01-new.md` descreve apenas “pergunta TDD, sugere branch”.

**Versionamento** — versão atual `0.3.0` (`package.json`); mudança de comportamento exige bump em todos os manifestos (`plugin.json`, `.cursor-plugin/`, `.claude-plugin/`, `gemini-extension.json`, `marketplace.json`) + `CHANGELOG.md`.

### Arquivos e componentes relevantes

| Área | Caminho / componente | Papel hoje |
|------|----------------------|------------|
| New (skill) | `skills/sdd-01-new/SKILL.md` | Cria spec; pergunta TDD; sem feature flag |
| New (command) | `commands/sdd-01-new.md` | Aponta para skill; descrição desatualizada p/ flag |
| Spec template | `skills/sdd-01-new/templates/spec-template.md` | Frontmatter sem `feature_flag`; metadados sem linha flag |
| TDD convention (modelo) | `skills/sdd-01-new/templates/sdd-tdd.md` | Padrão a espelhar para convenção de flag |
| Plan | `skills/sdd-04-plan/SKILL.md` | Propõe flag “quando condizente”; consulta `AGENTS.md` |
| Plan (command) | `commands/sdd-04-plan.md` | Já cita feature flags na descrição |
| Tasks template | `skills/sdd-01-new/templates/tasks-template.md` | Seção Feature flag (detalhe técnico no Plan) |
| Restrições | `skills/sdd-01-new/templates/sdd-restricoes.md` | Categoria Dados/deploy inclui flags |
| AGENTS contract | `skills/using-sdd/references/agents-md-contract.md` | Seção Feature flags → usada por sdd-04 |
| Init template | `skills/sdd-init/templates/agents-md-template.md` | Placeholder `{padrao-ou-NA}` para flags do projeto |
| Init skill | `skills/sdd-init/SKILL.md` | Feature flags = seção obrigatória no bootstrap |
| Docs | `README.md` | Fluxo SDD; TDD no 01-new; sem flag no 01-new |
| Manifestos | `plugin.json`, `.cursor-plugin/plugin.json`, etc. | Versão SemVer sincronizada |
| Spec local (scaffold) | `specs/templates/` | Cópia dos templates bundled (primeira spec deste repo) |

### Lacunas do research — resolvidas (Specify)

| # | Decisão |
|---|---------|
| 1 | Manter na skill `sdd-01-new`; extrair para `.md` separado só se crescer |
| 2 | Frontmatter `feature_flag: sim \| nao \| tbd` |
| 3 | Perguntar em **todos** os tipos (`feat`, `fix`, `refactor`, `perf`, `chore`, `docs`); sem skip automático |
| 4 | Plan **reavalia** com impactos, complexidade e consequências intencionais/não intencionais |
| 5 | Escopo concentrado em **New + Plan** (sem estender Execute/Review/Docs) |

### Restrições observadas (rascunho para Specify)

- Skills permanecem **genéricas** — padrão de implementação de flag no `AGENTS.md` do projeto-alvo, nunca hardcoded na skill.
- **Fonte única:** alterar `skills/sdd-01-new/templates/`; repos com `specs/templates/` já scaffoldado precisam atualizar manualmente ou re-scaffoldar.
- Mudança de comportamento → **SemVer minor** + todos os manifestos + `CHANGELOG.md`.
- Gate iterativo deste repo: revisão manual de skills/commands/templates (sem testes automatizados).

---

## 2. To Be (Specify)

### Resumo

O fluxo SDD passará a capturar a **intenção de feature flag** na fase New (`sdd-01-new`) para **qualquer tipo** de spec, registrando `feature_flag: sim | nao | tbd` no frontmatter. O **padrão de implementação** (env var, arquivo de config, serviço externo, etc.) vive no `AGENTS.md` — scaffoldado/perguntado no `sdd-init`. Na fase Plan (`sdd-04-plan`), o agente **reavalia** a decisão com o dev; se `feature_flag: sim`/`tbd` e § Feature flags vazio, **pergunta o padrão** e **pergunta se deve atualizar o `AGENTS.md`** — só escreve no arquivo com **confirmação expressa**.

### Goals

- [x] G1 — Perguntar ao dev sobre feature flag no `/sdd-01-new` para **qualquer** `tipo` de spec
- [x] G2 — Registrar `feature_flag` no frontmatter de `spec.md` e na tabela de metadados do template
- [x] G3 — Atualizar `sdd-04-plan`: reavaliar decisão, confirmar padrão do `AGENTS.md`; se vazio, perguntar padrão + perguntar se atualiza `AGENTS.md` (só com confirmação expressa)
- [x] G4 — Atualizar `sdd-init` + template/contrato do `AGENTS.md` para detectar ou perguntar padrão de feature flags no bootstrap
- [x] G5 — Manter skills genéricas; detalhes de stack/ferramenta só no `AGENTS.md` do projeto-alvo
- [x] G6 — Versionar bump minor + `CHANGELOG.md` + todos os manifestos

### Critérios de sucesso

- [x] CS1 — `/sdd-01-new` pergunta feature flag (qualquer `tipo`) e registra `feature_flag` no frontmatter
- [x] CS2 — `spec-template.md` inclui `feature_flag` no frontmatter e na tabela de metadados
- [x] CS3 — `/sdd-04-plan` reavalia `sim`/`tbd`; se § Feature flags vazio/inútil, pergunta padrão ao dev e pergunta se deve atualizar `AGENTS.md`; **não** altera `AGENTS.md` sem confirmação expressa
- [x] CS4 — `/sdd-init` tenta detectar padrão de flags e/ou pergunta ao dev; preenche § Feature flags no bootstrap (com confirmação, idempotente)
- [x] CS5 — `agents-md-template.md` e `agents-md-contract.md` documentam campos esperados (mecanismo, convenção de nome, default, path)
- [x] CS6 — Nenhuma skill hardcoda ferramenta como única opção — referência ao `AGENTS.md`
- [x] CS7 — `commands/sdd-01-new.md` e `README.md` refletem a nova pergunta
- [x] CS8 — Versão incrementada em todos os manifestos

### Non-goals

- Não criar `sdd-feature-flag.md` nesta entrega (só se a convenção crescer além do que cabe nas skills)
- Não alterar fases Execute, Task review, Spec review ou Docs para tratar feature flag
- Não implementar feature flags no runtime do plugin (continua `N/A` no `AGENTS.md` deste repo)
- Não migrar specs legadas sem o campo `feature_flag` (tratar como ausente / legado)
- Não atualizar `AGENTS.md` do projeto-alvo sem confirmação expressa do dev (init ou plan)

### Restrições

- Skills permanecem **genéricas** — convenção de nome, ferramenta e path de flags no `AGENTS.md` do projeto-alvo (`skills/using-sdd/references/agents-md-contract.md`)
- **Fonte única de templates:** `skills/sdd-01-new/templates/`; alterações espelhadas manualmente em `specs/templates/` deste repo
- Mudança de comportamento → SemVer **minor** + todos os manifestos + `CHANGELOG.md`
- Gate iterativo: revisão manual de skills, commands e templates (sem testes automatizados)
- Nenhuma restrição adicional além das padrão do repositório para compatibilidade/stack/segurança

### Abordagens consideradas

| Opção | Prós | Contras | Escolha |
|-------|------|---------|---------|
| **A — New + Plan + Init** | Intenção cedo; padrão no `AGENTS.md`; Plan confirma/preenche com opt-in | Escopo maior (init + contract) | **Escolhida** (ampliada) |
| **A′ — New + Plan only** | Menor diff | `AGENTS.md` vazio → fricção no Plan | Subsumida em A |
| **B — Só Plan** (status quo ampliado) | Uma fase só | Tarde demais; dev não pensa em flag desde o início | |
| **C — `sdd-feature-flag.md` dedicado** (como TDD) | Convenção centralizada extensível | Overhead para informação pequena hoje | Reservada se crescer |

**Recomendação do agente:** Opção A, alinhada às decisões do dev. Convenção embutida na skill; extrair para `.md` só se o conteúdo ultrapassar ~30 linhas ou precisar de encadeamento multi-fase.

### Escopo da entrega

- **Decisão:** Uma spec
- **Justificativa:** Mudança coesa em skills/templates/commands do plugin; um subsistema (fluxo New + Plan); sem entregáveis desacoplados.

- **Decisão:** Uma spec (escopo ampliado — opção A)
- **Justificativa:** Fluxo coeso: init define padrão do projeto → New captura intenção da spec → Plan reavalia e, se necessário, preenche `AGENTS.md` com confirmação expressa.

### Requisitos funcionais

1. **RF-01 — Pergunta no New (todos os tipos):** Em `skills/sdd-01-new/SKILL.md`, após TDD, perguntar ao dev **independentemente do `tipo`**:
   > "Esta spec usará **feature flag** (habilitar/desabilitar o comportamento sem impactar outras partes do sistema)?"

2. **RF-02 — Registro no frontmatter:** Preencher `feature_flag: sim | nao | tbd` em `spec.md` ao criar a pasta.

3. **RF-03 — Template spec:** Atualizar `spec-template.md` — frontmatter `feature_flag: nao` + linha na tabela Metadados.

4. **RF-04 — Reavaliação no Plan:** Em `skills/sdd-04-plan/SKILL.md`, passo Feature flags:
   - Ler `feature_flag` do frontmatter
   - Se `sim`/`tbd`: reavaliar impactos, complexidade, consequências; confirmar ou ajustar
   - Consultar `AGENTS.md` § **Feature flags**
   - Se § **vazio**, placeholder (`{padrao-ou-NA}`, `N/A`, TODO) ou inexistente **e** spec precisa de flag:
     1. **Perguntar** ao dev qual o padrão (mecanismo: env var, arquivo, tabela, serviço externo; convenção de nome; default; path no código)
     2. **Perguntar** explicitamente: "Deseja que eu **atualize o `AGENTS.md`** com esse padrão?"
     3. **Só escrever** no `AGENTS.md` após **confirmação expressa**; se recusar, registrar padrão apenas no plano (`tasks.md`) para a spec corrente
   - Se `nao`: registrar "Feature flag: N/A" com justificativa
   - Atualizar frontmatter se decisão mudar após reavaliação

5. **RF-05 — Bootstrap (`sdd-init`):**
   - Tentar **detectar** padrão de flags (deps SDK, configs, `.gitlab-ci.yml`, env vars documentadas, etc.)
   - Se não detectar ou incerto: **perguntar** ao dev no passo 2 (mecanismo, convenção, default, path)
   - Preencher § Feature flags no `AGENTS.md` gerado/atualizado — respeitando modo idempotente (não sobrescrever conteúdo real do dev)
   - Mesma regra: alteração substancial só com confirmação se já existir conteúdo manual

6. **RF-06 — Contrato e template `AGENTS.md`:**
   - `agents-md-template.md`: substituir placeholder único por subcampos estruturados (mecanismo, convenção de nome, default seguro, path/registro)
   - `agents-md-contract.md`: descrever o que a seção Feature flags deve conter + usada por `sdd-init`, `sdd-04-plan`

7. **RF-07 — Comando e docs:** Atualizar `commands/sdd-01-new.md` e `README.md`.

8. **RF-08 — Versionamento:** Bump minor + todos os manifestos + `CHANGELOG.md`.

### Edge cases

| Cenário | Comportamento esperado |
|---------|------------------------|
| Qualquer `tipo`, dev responde "sim" | `feature_flag: sim`; Plan reavalia e detalha conforme `AGENTS.md` |
| `feature_flag: sim` + § Feature flags vazio | Plan pergunta padrão → pergunta se atualiza `AGENTS.md` → só escreve com confirmação |
| Dev informa padrão mas **recusa** atualizar `AGENTS.md` | Padrão documentado em `tasks.md` § Feature flag desta spec; `AGENTS.md` intacto |
| Dev **confirma** atualizar `AGENTS.md` no Plan | Escrever § Feature flags; registrar em `executions.md` |
| `/sdd-init` detecta LaunchDarkly/Unleash/etc. no repo | Sugerir preenchimento; confirmar com dev antes de gravar |
| `/sdd-init` sem sinais de flags | Perguntar se projeto usa flags; se sim, perguntar padrão; se não, `N/A` |
| `AGENTS.md` já preenchido manualmente | Init/plan **não sobrescreve** (modo update / só consulta) |
| Spec legada sem `feature_flag` | Plan: comportamento legado ("quando condizente") |
| Dev muda `sim` → `nao` no Plan | Atualizar frontmatter + tasks N/A |

### Revisão da spec (Specify)

- [x] Sem TBD / placeholders vagos em §2 e §4
- [x] Goals ↔ critérios de sucesso ↔ RF ↔ US alinhados
- [x] Restrições e non-goals sem contradição
- [x] Abordagem escolhida refletida no To Be
- [x] Escopo da entrega adequado (uma spec, subsistema único)

### Confirmação de entendimento

**Agente entendeu como:** New pergunta **se** usará flag (qualquer tipo). **Onde/como** fica no `AGENTS.md` — init detecta/pergunta no bootstrap; Plan confirma padrão e, se § vazio, pergunta padrão + **pergunta se deve atualizar `AGENTS.md`** (só escreve com confirmação expressa). Demais fases SDD inalteradas.

**Dev confirmou:** [x] Sim  [x] Ajuste opção A ampliada (init + Plan com opt-in para `AGENTS.md`)  [ ] Ajustes: ...

---

## 3. Design

Decisões de design registradas inline (complexidade baixa — sem `design.md`).

### Decisões

| Decisão | Alternativas | Motivo |
|---------|--------------|--------|
| Convenção na skill `sdd-01-new` | `sdd-feature-flag.md` separado | Informação pequena; extrair só se crescer |
| Pergunta para **todos** os tipos | Só `feat`/`perf`; skip automático | Dev ajustou: independente do tipo |
| Plan reavalia (não só detalha) | Plan só lê frontmatter | Dev quer análise de impactos antes de fechar |
| Plan + `AGENTS.md` vazio | Pergunta padrão; pergunta se atualiza; só grava com confirmação | Dev pode recusar — padrão fica só na spec |
| Init detecta/pergunta padrão | Bootstrap completo | Não sobrescrever conteúdo manual existente |

---

## 4. User stories

### US-01: Opt-in de feature flag no New (qualquer tipo)

**Como** dev iniciando qualquer spec SDD **quero** ser perguntado se usarei feature flag **para** registrar a intenção cedo e orientar o plano de implementação.

**Critérios de aceite:**

- [x] `/sdd-01-new` com qualquer `tipo` exibe pergunta sobre feature flag
- [x] Resposta registrada como `feature_flag: sim | nao | tbd` no frontmatter
- [x] Tabela de metadados em `spec.md` exibe o valor

### US-02: Reavaliação informada no Plan

**Como** dev na fase Plan **quero** que o agente reavalie minha decisão de feature flag com impactos e complexidade **para** confirmar ou ajustar antes de detalhar tasks.

**Critérios de aceite:**

- [x] `/sdd-04-plan` lê `feature_flag` do frontmatter
- [x] Se `sim` ou `tbd`, agente apresenta impactos, complexidade adicional e consequências intencionais/não intencionais antes de propor flag
- [x] Se `nao`, registra N/A em `tasks.md` / §5 sem re-perguntar
- [x] Mudança de decisão após reavaliação atualiza frontmatter

### US-03: Padrão de flags no bootstrap (`sdd-init`)

**Como** dev configurando um projeto **quero** que o `/sdd-init` detecte ou pergunte como o projeto usa feature flags **para** ter o padrão documentado no `AGENTS.md` antes das specs.

**Critérios de aceite:**

- [x] Init tenta detectar sinais de flags no repositório
- [x] Se incerto, pergunta mecanismo/convenção/default/path
- [x] Não sobrescreve § Feature flags já preenchido pelo dev

### US-04: Plan confirma padrão e opt-in para `AGENTS.md`

**Como** dev com `feature_flag: sim` e § Feature flags vazio **quero** ser perguntado sobre o padrão e se devo atualizar o `AGENTS.md` **para** controlar o que entra no contrato do projeto.

**Critérios de aceite:**

- [x] Plan pergunta padrão (mecanismo, nome, default, path) quando § vazio
- [x] Plan pergunta explicitamente se deve atualizar `AGENTS.md`
- [x] `AGENTS.md` só é alterado com confirmação expressa
- [x] Se recusar, padrão fica documentado em `tasks.md` da spec

### US-05: Manter genericidade do plugin

**Como** mantenedor do plugin SDD **quero** que skills referenciem `AGENTS.md` para padrão de flags **para** não acoplar a stack de nenhum projeto.

**Critérios de aceite:**

- [x] Nenhuma skill menciona ferramenta específica de flags como opção única (LaunchDarkly/Unleash citados só como sinais de detecção em `sdd-init`, conforme RF-05/T07)
- [x] Plan consulta `AGENTS.md` § Feature flags para nome/default/path

---

## 5. Tasks

Backlog detalhado em [`tasks.md`](./tasks.md) (7 tasks, 3 fases).

| Task | Título | Fase |
|------|--------|------|
| T01 | Pergunta feature flag em `sdd-01-new` | 1 |
| T02 | `feature_flag` no `spec-template.md` | 1 |
| T06 | Contrato + template `AGENTS.md` § Feature flags | 1 |
| T07 | Detecção/pergunta em `sdd-init` | 2 |
| T03 | Reavaliação + opt-in `AGENTS.md` em `sdd-04-plan` | 2 |
| T04 | Comando + README | 2 |
| T05 | Versionamento SemVer + CHANGELOG | 3 |

---

## 6. Referências

- Issue: 1
- Issue summary: `specs/2026-06-1-feature-flag-spec-question/issue-summary.md`
- Anexos versionados: apenas `.md` (demais formatos apenas referenciados no `issue-summary.md`)
- Docs: ver mapa em `AGENTS.md`
