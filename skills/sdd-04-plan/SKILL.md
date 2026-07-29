---
name: sdd-04-plan
description: >-
  Fase Plan do SDD: backlog detalhado com dependências, fases, impactos, feature flags
  e boas práticas. Plan em ondas (checkpoints + nova sessão) com subagente planejador
  sequencial (escreve em tasks.md) e review de compliance por escopo em specs grandes.
  Use com /sdd-04-plan.
---

# SDD — Plan

## Objetivo

Backlog executável e **bem fundamentado**: 1 task = 1 entregável, dependências explícitas, fases quando necessário. Premissa **zero-context / bite-sized**: o executor (subagente ou dev) implementa só com a task — sem histórico do chat.

**Iron Law (Steps de código):**

```
NENHUM STEP DE CÓDIGO SEM ARTEFATO EXECUTÁVEL SUFICIENTE PARA O plan_depth
```

- **`snippets`** (default em mudança incremental): snippet **completo** + comando + output esperado.
- **`contracts`** (greenfield / bootstrap): assinaturas (Interfaces) + artefato que trava comportamento (teste completo ou scaffold verificável) + comando + output esperado — **sem** exigir corpo completo de todo módulo no Plan.

(Quando Context pack + Steps forem obrigatórios para o `tipo` — ver 4.1 e 4.0.)

## Contexto do projeto

Consultar o `AGENTS.md` para: gate iterativo, feature flags, integrações, subsistemas e restrições padrão.

Se o plano incluir schema, migrations ou indexes **PostgreSQL** → invocar **`postgresql-table-design`** ao detalhar Steps de DDL (tipos, FK+index, evolução segura).

## Entregável

- Análise de consequências intencionais e não intencionais
- Reavaliação de feature flag (ou N/A justificado); opt-in para atualizar `AGENTS.md` quando § Feature flags vazio
- `tasks.md` se ≥ 5 tarefas **com fases de implementação**; senão, tasks em `spec.md` §5
- **Global Constraints**, **Mapa de arquivos**, **`plan_depth`**, tasks com **Interfaces** + Context pack + Steps (quando exigido)
- Dependências e paralelismo explícitos
- `executions.md` inicializado
- Em specs grandes: **Plan em ondas** (§4.2) com planejador/revisor por fase e checkpoints

Ao final: `/sdd-05-review` antes de `/sdd-06-execute`.

## Escopo do SDD

Aplica-se a **qualquer mudança** rastreável em spec. Ajustar a profundidade do plano ao `tipo` no frontmatter de `spec.md`.

## Pré-requisitos

- `spec.md` com To Be confirmado (`status: specified`).
- Dev confirmou entendimento na fase Specify.

## Postura do agente (obrigatório)

- Seja **detalhista**: aponte arquivos, classes e métodos; **mostre trechos de código** quando isso tornar o plano mais claro.
- Assuma executor **habilidoso** mas **sem contexto** do chat/domínio/tooling e com gosto de teste/design **a orientar** (Steps mostram o como).
- Se houver **dúvidas**, **pergunte ao dev antes** de fechar o plano.
- **Não tenha pressa**: analise o código e a spec com calma.
- **Revise** achados e propostas antes de entregar.
- Não implementar código nesta fase.

## Passos

### 1. Análise de impacto

Para cada mudança proposta, documentar no chat e em `tasks.md` / §5:

| Mudança | Consequências intencionais | Consequências não intencionais (riscos) |
|---------|---------------------------|----------------------------------------|
| ... | ... | ... |

Considerar dependências externas e subsistemas listados em `AGENTS.md` (integrações, persistência, deploy, rollback).

### 2. Boas práticas de engenharia

- Responsabilidade única, SOLID quando pertinente, sem over-engineering.
- Tratamento de erros e edge cases da spec.
- Tarefas possíveis de **paralelizar** só quando **não houver dependência** real.

### 2.1. TDD (se `tdd: true` no frontmatter)

Seguir a skill **`tdd`**, `specs/templates/sdd-tdd.md` e as integrações em `AGENTS.md`:

- O DoD das tasks deve incluir a ordem explícita: **teste falhando → implementação mínima → refactor**.
- **Iron Law** (na execução): nenhum código de produção sem teste falhando pelo motivo certo.
- Respeitar `tdd_integracao`: integrações excluídas em `AGENTS.md` → **avisar o dev** e não exigir test-first nessas áreas.
- Se o dev optar por incluir integrações no TDD durante o plan, atualizar `spec.md` antes de fechar as tasks.

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

### 4. Quebra em tasks

**Antes** de listar as tasks (nesta ordem):

1. **Global Constraints** — bullets com valores **verbatim** da spec §2 (restrições) + restrições padrão do `AGENTS.md` que se aplicam a **todas** as tasks. O Context pack referencia; não redescobre.
2. **Mapa de arquivos** — tabela path → responsabilidade (criar/modificar/teste). Trava o corte das tasks: arquivos que mudam juntos ficam na mesma task ou com Interfaces explícitas; preferir arquivos focados.
3. **`plan_depth`** — decidir e registrar (seção 4.0) **antes** de escrever Steps.
4. Só então decompor em tasks.

- Cada task: entregável verificável (classe, endpoint, teste, flag, doc) — menor unidade com ciclo de teste + review próprio.
- Campos: **Onde**, **Depende de**, **Bloqueia**, **Interfaces**, **DoD**, RF/US vinculada; opcional **Profundidade** (override de `plan_depth`).
- O DoD padrão inclui o gate iterativo de `AGENTS.md`.
- Tasks alinhadas à **abordagem escolhida** em `spec.md` §2 (Abordagens consideradas).
- O DoD pode referenciar os **critérios de sucesso** da spec quando aplicável.
- Toda task rastreável a um goal ou US da spec.

**Quantidade:**

| Tasks | Onde documentar |
|-------|-----------------|
| < 5 | `spec.md` §5 |
| ≥ 5 | `tasks.md` (`specs/templates/tasks-template.md`) + referência em §5 |

**Mais de 5 tasks:** organizar em **fases de implementação** (Fase 1, Fase 2, …) respeitando dependências. Cada fase = conjunto executável via `/sdd-06-execute`.

**Se Plan em ondas (4.2) aplicar:** nesta etapa escrever só o **skeleton** (Constraints + Mapa + `plan_depth` + tabela de Fases com IDs/títulos/deps — sem Context pack/Steps ainda). Detalhe das tasks → §4.2.

### 4.0 Profundidade do plano (`plan_depth`)

Registrar no topo de `tasks.md` / §5 (obrigatório quando o formato completo de 4.1 se aplica):

| Campo | Valor |
|-------|-------|
| **plan_depth** | `snippets` \| `contracts` |
| **Critério** | {regra disparada — ver árvore abaixo} |
| **Override do dev?** | não \| sim (pedido explícito) |

#### Árvore de decisão (nesta ordem — primeira que casar vence)

1. **Override do dev** — se o dev pediu `snippets` ou `contracts` explicitamente → usar esse valor; anotar “override do dev”.
2. **`contracts`** se **qualquer** um for verdadeiro após o Mapa de arquivos / spec:
   - **Maioria criar:** contagem de paths com Ação `criar` ≥ 50% dos paths do mapa **ou** ≥ **8** paths `criar`;
   - **Sistema / subsistema novo:** Escopo da entrega ou goals descrevem bootstrap de sistema/serviço novo **e** existe (ou será criado) `design.md`;
   - **Fase só de scaffold:** a fase corrente é explicitamente bootstrap/skeleton/scaffolding sem fatia vertical de negócio ainda.
3. Caso contrário → **`snippets`** (default).

#### Mix por fase ou task (recomendado em greenfield)

- Greenfield típico: **Fase 1** `contracts` (scaffold + Interfaces + 1 thin slice com teste completo); **fases seguintes** de fatia vertical → preferir **`snippets`** naquela fase/task.
- Override por task: campo **Profundidade:** `snippets` \| `contracts` na tabela da task (vence o default do plano **só** naquela task).
- Se a fase misturar: declarar `plan_depth` da fase na tabela de Fases (coluna opcional) ou no Critério.

#### O que cada modo exige nos Steps

| Modo | Step de código / produção | Step de verificação | Ainda obrigatório |
|------|---------------------------|---------------------|-------------------|
| **`snippets`** | Snippet **completo** (corpo) do que será escrito | Comando + output esperado (FAIL/PASS) | Interfaces; paths exatos; bite-size |
| **`contracts`** | **Assinaturas** / esqueleto alinhado a **Produces** + regras em bullets; corpo completo **só** se couber num step de 2–5 min (ex.: thin slice). Proibido “implementar FooService” sem contrato. | Pelo menos um artefato que **trava comportamento**: teste **completo** que fixa o contrato **ou** comando de scaffold com output esperado | Interfaces ricas; Mapa; Constraints; bite-size |

**Thin slice (sempre `snippets` na prática daquele entregável):** mesmo em plano `contracts`, a task que entrega o **primeiro caminho feliz de negócio** deve ter teste completo (e implementação mínima no Step) — não só assinaturas.

#### Ambíguo?

Se o mapa estiver no limiar (ex.: 45–55% criar) ou o escopo for híbrido → **perguntar ao dev** uma vez: "`plan_depth`: snippets (código completo nos Steps) ou contracts (contratos + scaffold)?" — não assumir.

### 4.1 Formato executável (zero-context / bite-sized)

Cada task deve permitir execução por **engenheiro sem contexto do chat** (agente, subagente ou dev novo no repo).

**Obrigatório** (formato completo abaixo) para: `feat`, `refactor`, `perf`; `fix` com >1 arquivo.
**Opcional** (só DoD + checklist curto): `chore`, `docs`, `fix` pontual em 1 arquivo.

Por task em `tasks.md` (ou §5 se < 5 tasks):

| Seção | Conteúdo |
|-------|----------|
| **Context pack** | Spec (goal/US), link às Global Constraints, padrão do repo, arquivos vizinhos, **Não fazer** |
| **Interfaces** | **Consumes:** o que esta task usa de tasks anteriores (nomes/assinaturas exatos). **Produces:** o que tasks seguintes dependem (nomes, params, retornos). O implementador da task N **não** lê a task N−1 — este bloco é o contrato. |
| **Steps** | **Uma ação por step**, duração alvo **2–5 min**. Paths exatos; artefato conforme **`plan_depth`** / **Profundidade** da task; comando + output esperado em todo step de verificação |

**Bite-size:**

- Step = 1 ação (ex.: “escrever o teste”, “rodar e ver FAIL”, “código mínimo”, “rodar PASS”, “gate”).
- **2–5 min** é o alvo. **2–10 min** só com justificativa numa linha no próprio step (ex.: “exceção: migrate + smoke — inseparáveis”).
- Setup/scaffold/docs da task: **dobrar** no step do entregável que precisa deles; não criar task só de “preparar ambiente” sem entregável testável.

**Iron Law** (quando o formato completo for obrigatório): step de código ou de verificação **sem** artefato suficiente para o `plan_depth` vigente = **falha de plano** — corrigir antes de `/sdd-05-review`.

**Proibido nos Steps** (falha de plano — nos dois modos):

- TBD, TODO, "implementar depois"
- "Adicionar validação" / "tratar edge cases" sem código **ou** sem regras/assinaturas no Interfaces
- "Similar à T02" sem repetir o artefato (tasks podem ser lidas fora de ordem)
- Steps que descrevem o quê sem mostrar o como
- Referências a tipos/funções/métodos **não** definidos em Interfaces desta task nem em Global Constraints / Mapa
- Em **`contracts`**: Step de produção só com prosa (“criar o módulo X”) sem Produces/assinaturas/teste

**Commits:** não colocar step de commit automático — commits só se o dev pedir (política SDD).

**TDD (`tdd: true`):** os Steps devem incluir a ordem red → green → refactor por task; respeitar `tdd_integracao` em `AGENTS.md`. Em `contracts`, o RED ainda exige **teste completo** que falha pelo motivo certo; o GREEN pode ser “mínimo que satisfaz o teste + Produces” sem dump de todo o bounded context.

**Paralelismo:** coluna **Paralelo com** só se **Onde** for disjunto; marcar **Paralelo? = sim** na tabela de fases. Tasks paralelas ainda precisam de **Interfaces** se houver contrato compartilhado via tipos já existentes (Consumes do repo As Is).

### 4.2 Plan em ondas (contexto / specs grandes)

Evita saturar a janela de contexto ao detalhar um sistema/subsistema grande. **Arquivos em disco = memória**; o chat é scratchpad.

#### Quando obrigatório (primeira que casar)

1. Tabela de Fases com **≥ 2 fases**, ou  
2. Mapa com **≥ 8** paths `criar`, ou  
3. Greenfield / sistema novo com `design.md`, ou  
4. Dev pediu plan por fase / ondas, ou  
5. Sinais de pressão de contexto (plano já longo, inconsistências, placeholders)

Plano pequeno (formato curto, < 5 tasks, 1 fase): fluxo monólito (detalhar tudo → 4.3 → 4.4 `cross` ou fase única) — ondas **opcionais**.

#### Papéis

| Papel | Quem | Edita `tasks.md`? | Escopo |
|-------|------|-------------------|--------|
| Orquestrador | Sessão `/sdd-04-plan` | **Sim** (skeleton, Progresso, correções pós-review) | Skeleton, material A–F, perguntas ao dev, checkpoints |
| Planejador | Subagente `Task` + [`prompt-plan-phase.md`](./prompt-plan-phase.md) | **Sim** — só blocos T0X da fase | **Uma** fase por dispatch (escreve no arquivo) |
| Revisor | Subagente `Task` + [`prompt-plan-compliance.md`](./prompt-plan-compliance.md) | **Não** | `skeleton` \| `fase-N` \| `cross` |

**Sequencial obrigatório:** um planejador por vez; **nunca** disparar dois `Task` de plan em paralelo. (A coluna **Paralelo?** nas tasks é só para o *Execute* depois.)

Sem `Task`: orquestrador executa o mesmo fluxo em ondas (detalha uma fase por vez no arquivo; “segunda passagem” no lugar do revisor).

#### Fluxo

```
Onda 0 — Skeleton (orquestrador)
  Constraints + Mapa + plan_depth + Fases (IDs/títulos) + Progresso do Plan
  → review escopo=skeleton (4.4)
  → checkpoint + lembrete de nova sessão

Onda 1..N — Detalhe Fase N (sequencial)
  → orquestrador monta material A–F (prompt-plan-phase) — amostras As Is + gate AGENTS obrigatórios
  → dispatch **um** planejador → escreve T0X da fase em tasks.md
  → orquestrador relê tasks.md (fase) → self-review 4.3
  → review escopo=fase-N (4.4, máx. 2 iters)
  → checkpoint + lembrete de nova sessão

Onda final
  → review escopo=cross (cobertura RF + Interfaces entre fases)
  → Finalização (6) — só então status: planned
```

#### Material do planejador (qualidade)

Antes do dispatch, o orquestrador **deve** preencher o checklist A–F de [`prompt-plan-phase.md`](./prompt-plan-phase.md). Sem **amostras As Is** (ou padrão design/AGENTS) e sem **comandos de gate**, o subagente tende a inventar APIs/comandos — tratar como falha de preparação, não do planejador.

Se retorno `NEEDS_CONTEXT`: completar material e re-dispatch (**sem** o planejador ter editado). Após `DONE`, o orquestrador **relê** `tasks.md` — não confiar só no summary do chat. Não “completar de memória” o plano na sessão inchada.

#### Checkpoint (obrigatório ao fechar cada onda)

Gravar progresso em `tasks.md` § Progresso do Plan (e opcionalmente `executions.md`). No chat, **sempre**:

> **Checkpoint Onda {n} gravado** em `tasks.md` ({escopo fechado}).  
> Contexto desta sessão pode estar cheio. **Recomendado:** abrir **nova sessão** e rodar `/sdd-04-plan` na mesma pasta da spec para a **Onda {n+1}**.  
> Para seguir aqui: diga “continuar nesta sessão”.

**Não** iniciar a próxima onda sem escolha explícita do dev (continuar vs nova sessão).

#### Retomada (início de `/sdd-04-plan`)

Ler `tasks.md` § Progresso do Plan / estado das fases:

| Estado | Ação |
|--------|------|
| Sem skeleton | Onda 0 |
| Skeleton ok, Fase k sem Context pack/Steps | Onda k (planejador) |
| Fase k detalhada, compliance pendente | Só revisor `fase-k` + correção |
| Todas fases ✅ compliance, cross pendente | Onda final `cross` |
| Tudo ✅ | Sugerir `/sdd-05-review` (já `planned`) |

Não reler o histórico do chat antigo — só disco + material filtrado da onda.

#### Red flags (ondas)

| Racionalização | Realidade |
|----------------|-----------|
| "Cabe tudo numa sessão" | ≥2 fases ou ≥8 criar → ondas obrigatórias |
| "Dois planejadores em paralelo" | Sempre sequencial — um `Task` de plan por vez |
| "Devolver markdown no chat para colar" | Planejador **escreve** em `tasks.md`; summary só com IDs |
| "Dispatch sem amostras de código" | NEEDS_CONTEXT / falha de preparação |
| "`planned` após Fase 1" | Só após cross da onda final |
| "Revisor lê tasks.md inteiro sempre" | Escopo `skeleton` / `fase-N` / `cross` |
| "Confiar no summary sem reler o arquivo" | Orquestrador relê `tasks.md` após DONE |

### 4.3 Self-review do plano

Antes do gate automático (4.4). Em modo ondas: aplicar **só ao escopo da onda** (skeleton ou Fase N).

1. **Cobertura da spec:** cada RF/US do escopo tem task (e Step, se detalhe) correspondente?
2. **Scan de placeholders:** nenhum item da lista proibida acima?
3. **Consistência:** nomes/assinaturas em **Interfaces** / Steps iguais entre tasks (ex.: `clearLayers` vs `clearFullLayers` = bug)?
4. **Executabilidade zero-context:** alguém só com Global Constraints + Mapa + **uma** task (Context pack + Interfaces + Steps) implementa sem abrir o chat? (N/A no skeleton)
5. **Bite-size:** steps com mais de uma ação ou >5 min sem justificativa?
6. **`plan_depth`:** registrado com critério? Artefatos dos Steps batem com o modo (e thin slice com teste completo)?
7. **Iron Law:** todo step de código/verificação tem artefato suficiente para o modo vigente?
8. **Material do planejador (se usou Task):** A–F estavam completos? Snippets imitam As Is?

Corrigir inline; gaps óbvios não devem chegar ao subagente revisor.

### 4.4 Gate automático — plan compliance (readonly, máx. 2 iterações)

**Objetivo:** segundo olhar **antes** do humano (`/sdd-05-review`). Não substitui o 05. Não é o loop do 06 (sem Estágio 2 de “code quality”, sem receiving-review, sem 5 iterações).

Em **Plan em ondas**, rodar o gate **por escopo** ao fim de cada onda (`skeleton` → cada `fase-N` → `cross`). Em plano monólito, um único review com escopo `cross` (ou `fase-1` se só uma fase detalhada).

```
Self-review (4.3) do escopo
  → Dispatch revisor readonly (prompt-plan-compliance.md + escopo)
  → ✅ → checkpoint / próxima onda / Finalização (6) se cross
  → ❌ → orquestrador corrige tasks.md/§5 → iter++
  → no máx. 2 ciclos de review; se ainda ❌ → escalar ao dev (não marcar planned; não avançar de onda)
```

| Papel | Quem | Modo |
|-------|------|------|
| Revisor plan compliance | Subagente `Task` (ou orquestrador em modo readonly se não houver `Task`) | **readonly** — não edita arquivos |
| Correção | Orquestrador (sessão do `/sdd-04-plan`) | edita só o plano (`tasks.md` / §5; spec só se o finding exigir consenso de desvio) |

**Regras:**

1. Dispatch com [`prompt-plan-compliance.md`](./prompt-plan-compliance.md) e `{escopo}` correto. Preferir subagente fresco (não herdar o raciocínio de quem escreveu o plano / da onda).
2. Tratar só itens **Crítico** como bloqueio. **Melhoria** → anotar no chat / opcional corrigir; não força nova iteração sozinha.
3. `iter` = 1..2 conta **pares** (review → correção) **por escopo/onda**. Após correção da iteração 2, rodar **um** review final; se ainda ❌ Crítico → **escalar ao dev** com o relatório (não `status: planned`).
4. Se o revisor marcar `plan_depth: questionável` sem override do dev → tratar como Crítico **ou** perguntar ao dev na hora (uma pergunta).
5. Formato curto (`chore` / `docs` / `fix` 1 arquivo sem Context pack): gate **opcional** — se rodar, adaptar o checklist (só cobertura + placeholders + DoD).
6. Degradação: sem `Task` → orquestrador executa o checklist do prompt em modo “segunda passagem” (relê o plano do zero no escopo, sem editar até terminar o checklist); mesma regra de 2 iterações.
7. Escopo `cross` **não** re-audita cada Step já ✅ em `fase-N` — foco em cobertura global e Interfaces entre fases.

**Não fazer neste gate:** implementar código; abrir `/sdd-06-execute`; aprovar o plano no lugar do dev; marcar `planned` antes do `cross` quando ondas estão ativas.

### 5. Plano de execução

- Grafo de dependências (texto ou mermaid).
- O que pode rodar em **paralelo** — skill `parallel-execution` quando **Paralelo? = sim** e **Onde** disjunto.
- Ordem sugerida de `/sdd-06-execute` ou `parallel-execution` por fase.

### 6. Finalização

1. Gate 4.4 ✅ no escopo final (`cross` se ondas; senão o review monólito) — ou escalado ao dev (aí **não** avançar sozinho).
2. Criar/atualizar `executions.md` (tasks `pending`, coluna Fase se ≥ 5 tasks).
3. Registrar em `executions.md` (ou no chat se ainda não houver seção): `Plan compliance: ✅` por escopo (`skeleton` / `fase-N` / `cross`) + iters; ou `escalado`.
4. Atualizar § Progresso do Plan → todas as ondas ✅.
5. `status` → `planned` **somente** após 4.4 ✅ do escopo final.
6. Sugerir `/sdd-05-review`.

## Desvios e shadow code

Se o plano exigir algo **fora** dos goals/non-goals da spec ou que **viole restrições** (ver `specs/templates/sdd-restricoes.md` e `AGENTS.md`): **parar**, explicar ao dev e só incluir após **consenso** e atualização de `spec.md` (voltar a Specify se necessário).

## Saída esperada

Plano com self-review + gate plan-compliance por escopo (ondas quando aplicável); `tasks.md` ou §5 + `executions.md`; pronto para review **humano** (`/sdd-05-review`).