# Contrato do `AGENTS.md` do projeto-alvo

As skills SDD são genéricas. O específico do projeto vive no `AGENTS.md` na **raiz do repositório**. Para o fluxo SDD funcionar bem, o `AGENTS.md` deve conter (adapte os títulos ao seu projeto):

## Seções recomendadas

| Seção | Para que serve | Usada por |
|---|---|---|
| **Stack** | Linguagem, framework, gerenciador de build | research, plan, execute |
| **Gate de qualidade** | Comandos exatos de lint/compile, teste e build (iterativo) e o gate completo (antes de merge) | `verification`, sdd-06, sdd-07, sdd-08 |
| **Issue tracker** | Nome, URL base e como ler issues (ex.: Jira, GitHub Issues) | sdd-01, sdd-09, commit-message |
| **Branches Git** | Convenção de nome, branch base padrão, plataforma de MR/PR | sdd-01, sdd-09 |
| **Integrações externas** | Quais integrações existem e quais ficam **fora do TDD por padrão** | sdd-02/03/04/06, debugging, parallel-execution |
| **Restrições padrão** | Limites que nenhuma spec pode violar (contratos, segurança, dados); opcionalmente a **disciplina de implementação** do projeto (reforço das 4 regras em `using-sdd`) | sdd-03/04/05/07/08, debugging |
| **Convenção de pastas (specs)** | Onde ficam as specs e templates | todas as fases |
| **Mapa de research (As Is)** | Onde procurar código por área | sdd-02 |
| **Mapa de documentação** | Onde documentar mudanças públicas | sdd-09 |
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
├── implementation-log.md      # log global
└── YYYY-MM-{ISSUE-KEY}-slug/
    ├── spec.md
    ├── design.md          # opcional
    ├── tasks.md           # opcional (≥ 5 tasks)
    ├── executions.md
    ├── mr-template.md     # preenchido em /sdd-09-docs
    └── issue-summary.md
```

> Sem issue tracker? Use um identificador curto no lugar de `{ISSUE-KEY}` (ex.: o slug) e marque os campos de issue como `N/A`.
