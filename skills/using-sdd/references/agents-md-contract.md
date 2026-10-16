# Contrato do `AGENTS.md` do projeto-alvo

As skills SDD são genéricas. O específico do projeto vive no `AGENTS.md` na **raiz do repositório**. Para o fluxo SDD funcionar bem, o `AGENTS.md` deve conter (adapte os títulos ao seu projeto).

O `/sdd-init` em modo update audita este contrato (checklist em `skills/sdd-init/references/agents-md-audit.md`), lista desalinhamentos e só aplica upgrades com confirmação.

## Seções recomendadas

| Seção | Para que serve | Usada por |
|---|---|---|
| **Stack** | Linguagem, framework, gerenciador de build | research, plan, execute |
| **Gate de qualidade** | Comandos exatos de lint/compile, teste e build (iterativo) e o gate completo (antes de merge) | `verification`, `finish-branch`, sdd-06, sdd-07, sdd-08 |
| **Issue tracker** | Nome, URL base e como ler issues (ex.: Jira, GitHub Issues) | sdd-01, sdd-08, `finish-branch`, commit-message |
| **Branches Git** | Branch base, convenção de nomes, plataforma de MR/PR | sdd-01, sdd-08, `worktrees`, `finish-branch` |
| **Integrações externas** | Quais integrações existem e quais ficam **fora do TDD por padrão** | sdd-02/03/04/06, `tdd`, debugging, parallel-execution |
| **Restrições padrão** | Limites que nenhuma spec pode violar (contratos, segurança, dados); opcionalmente a **disciplina de implementação** do projeto (reforço das 4 regras em `using-sdd`) | sdd-03/04/05/06/07, debugging, `receiving-review` |
| **Convenção de pastas (specs)** | Onde ficam as specs e templates | todas as fases |
| **Mapa de research (As Is)** | Onde procurar código por área | sdd-02 |
| **Mapa de documentação** | Onde documentar mudanças públicas | sdd-08 |
| **Feature flags** | Mecanismo (env, arquivo, serviço), convenção de nome, default seguro, path no código | sdd-init, sdd-04-plan |

## Exemplo mínimo de Feature flags

```markdown
## Feature flags

| Campo | Valor |
|-------|-------|
| **Mecanismo** | env-var |
| **Convenção de nome** | FEATURE_{NOME} |
| **Default seguro** | false |
| **Path / registro no código** | src/config/feature-flags.ts |
```

> Adapte ao projeto. Se não usar feature flags, marque **Mecanismo** como `N/A`.

## Exemplo mínimo de "Gate de qualidade"

```markdown
## Gate de qualidade

### Gate iterativo (por task)
- lint/compile: `<comando do projeto>`
- testes: `<comando do projeto>`
- build: `<comando do projeto>`

### Gate completo (antes de merge)
- `<comando do projeto>`
```

## Convenção de pastas das specs (padrão SDD)

```
specs/
├── templates/                 # scaffoldado pelo /sdd-01-new (cópia dos templates do plugin)
└── YYYY-MM-{ISSUE-KEY}-slug/
    ├── spec.md
    ├── design.md          # opcional
    ├── tasks.md           # opcional (≥ 5 tasks)
    ├── executions.md
    ├── mr-template.md     # preenchido em /sdd-08-docs
    ├── issue-summary.md
    └── closure.md         # preenchido no finish-branch (histórico da entrega)
```

> Sem issue tracker? Use um identificador curto no lugar de `{ISSUE-KEY}` (ex.: o slug) e marque os campos de issue como `N/A`.

### Histórico de implementações

Não há índice global editável. Para saber o que foi implementado e quando:

1. Listar `specs/*/spec.md` com frontmatter `status: done`.
2. Ordenar por `concluido` (desc).
3. Ler `closure.md` na mesma pasta (entrega, issue, PR/MR, decisões, desvios).

Campos de fechamento no frontmatter de `spec.md`: `status: done`, `concluido: YYYY-MM-DD`, `pr:` (url, `#N`, `!N` ou `merged-local`).

`finish-branch` grava esses campos e o `closure.md` só depois de merge local ou de MR/PR com URL. `/sdd-08-docs` para em `status: documented` e deixa `pr` vazio.

Ciclo de `status`: `draft` → `research` → `specified` → `planned` → `approved` → `executing` → `reviewed` → `documented` → `done`. O Execute exige `approved` (ou `executing` na retomada).

**Legado:** se existir `specs/implementation-log.md`, tratá-lo como **congelado** (não criar em projetos novos; não escrever mais nele).
