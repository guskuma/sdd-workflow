# TDD no SDD — Convenção centralizada

Fonte única para regras de TDD no fluxo SDD (genérico). **Áreas de integração excluídas por padrão** neste repositório: ver a seção **Integrações** / **TDD** em [`AGENTS.md`](../../AGENTS.md).

Disciplina operacional (Iron Law, red/green, red flags): skill **`tdd`**.

## Opt-in

`/sdd-01-new` grava `tdd: tbd` e `tdd_integracao: tbd`. A decisão é do `/sdd-03-specify` (seção Decisões vinculantes).

- `tdd: tbd` no Plan ou no Execute → parar e voltar ao 03.
- `tdd: false` → gate do `AGENTS.md` obrigatório; skill **`tdd`** não se aplica.
- `tdd: true` → skill **`tdd`** obrigatória no plan e no execute.
- Campo ausente (legado) → tratar como `tdd: false`.

## Ciclo

Red → green → refactor: skill **`tdd`**. O plan põe essa ordem nos Steps. O execute invoca a skill. Não copiar o ciclo para outras skills.

## Exclusão padrão de integrações

Quando o escopo da spec incluir integrações pesadas listadas em `AGENTS.md`, TDD nessas áreas fica **fora do escopo por padrão**.

### Quem decide

Só o `/sdd-03-specify` grava `tdd_integracao`. O research anota a integração em Lacunas. O plan não altera o frontmatter.

### Opt-in de integração

```yaml
tdd_integracao: incluir: area1,area2   # conforme a nomenclatura em AGENTS.md
```

## Escopo TDD padrão (sem restrição)

Camadas testáveis sem infra externa real — detalhar os paths no `AGENTS.md` do projeto.

## Legado

Specs anteriores a esta convenção podem não ter `tdd` no frontmatter; tratar como `tdd: false`.
