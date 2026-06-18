# {nome-do-projeto}

> Contrato do projeto para o fluxo SDD. Gerado/atualizado por `/sdd-init`.
> Referência do contrato: `skills/using-sdd/references/agents-md-contract.md` (no plugin).

## Stack

<!-- Linguagem, framework, gerenciador de build -->
- **Linguagem:** {linguagem}
- **Framework:** {framework}
- **Build/package:** {gerenciador}

## Gate de qualidade

### Gate iterativo (por task)

- lint/compile: `{comando-lint}`
- testes: `{comando-test}`
- build: `{comando-build}`

### Gate completo (antes de merge)

- `{comando-gate-completo}`

### Teste único (debug)

- `{comando-teste-unico}` <!-- ex.: npm test -- path/to/file.test.ts -->

## Issue tracker

<!-- Nome, URL base, como ler issues. Sem tracker? Marque N/A. -->
- **Plataforma:** {GitHub Issues | Jira | Linear | N/A}
- **URL base:** {url-ou-NA}
- **Como ler:** {ferramenta-ou-comando}

## Branches Git

- **Branch base:** `{main | master | develop}`
- **Convenção:** `{tipo}/{ISSUE-KEY}` ou `{tipo}/{slug}`
- **Plataforma de MR/PR:** {GitHub | GitLab | ...}
- **Título MR/PR:** `{ISSUE-KEY}-{slug}`

## Integrações externas

<!-- Quais integrações existem e quais ficam fora do TDD por padrão -->
| Integração | TDD por padrão? | Notas |
|------------|-----------------|-------|
| {integracao} | {sim \| fora} | {notas} |

## Restrições padrão

<!-- Limites que nenhuma spec pode violar -->
- <!-- TODO: preencher -->

## Convenção de pastas (specs)

```
specs/
├── templates/                 # scaffoldado pelo /sdd-01-new
├── implementation-log.md      # log global
└── YYYY-MM-{ISSUE-KEY}-slug/
    ├── spec.md
    ├── design.md              # opcional
    ├── tasks.md               # opcional (≥ 5 tasks)
    ├── executions.md
    ├── mr-template.md         # preenchido em /sdd-09-docs
    └── issue-summary.md
```

## Mapa de research (As Is)

<!-- Onde procurar código por área -->
| Área | Caminhos |
|------|----------|
| {area} | {paths} |

## Mapa de documentação

<!-- Onde documentar mudanças públicas -->
- {paths-docs}

## Feature flags

<!-- Padrão de flags do projeto; N/A se não usar -->
- {padrao-ou-NA}

## ADR (opcional)

<!-- Path para Architecture Decision Records; N/A se não usar -->
- **Path:** {path-adr-ou-NA}
