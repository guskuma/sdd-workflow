# Formato da task (zero-context / bite-sized)

Cada task permite execução por engenheiro sem contexto do chat.

**Obrigatório** para: `feat`, `refactor`, `perf`; `fix` com mais de 1 arquivo.
**Opcional** (só DoD + checklist curto): `chore`, `docs`, `fix` pontual em 1 arquivo.

`plan_depth` e a frase permitida de `contracts`: [`plan-depth.md`](./plan-depth.md).

| Seção | Conteúdo |
|-------|----------|
| **Context pack** | Spec (goal/US), link às Global Constraints, padrão do repo, arquivos vizinhos, **Não fazer** |
| **Interfaces** | **Consumes:** o que esta task usa de tasks anteriores (nomes/assinaturas exatos). **Produces:** o que tasks seguintes dependem. O implementador da task N **não** lê a task N−1. |
| **Steps** | **Uma ação por step**, alvo **2–5 min**. Paths exatos; artefato conforme `plan_depth`; comando + output esperado em todo step de verificação |

## Bite-size

- Step = 1 ação.
- **2–5 min** é o alvo. **2–10 min** só com justificativa numa linha no próprio step.
- Setup/scaffold da task entra no step do entregável que precisa deles. Não criar task só de “preparar ambiente”.

## Iron Law

Step de código ou de verificação **sem** artefato suficiente para o `plan_depth` vigente = falha de plano. Corrigir antes de `/sdd-05-review`.

## Proibido nos Steps

- TBD, TODO, "implementar depois"
- "Adicionar validação" / "tratar edge cases" sem código **ou** sem regras/assinaturas no Interfaces
- "Similar à T02" sem repetir o artefato
- Steps que descrevem o quê sem mostrar o como
- Tipos/funções não definidos em Interfaces desta task, nem em Global Constraints, nem no Mapa
- Em **`contracts`**: prosa que não seja a frase permitida de [`plan-depth.md`](./plan-depth.md)

**Commits:** sem step de commit automático.

**TDD (`tdd: true`):** ordem red → green → refactor, skill **`tdd`**. Não reabrir `tdd` nem `tdd_integracao` (decisão do `/sdd-03-specify`). Em `contracts`, o RED exige teste completo; o GREEN pode ser a frase permitida.

**Paralelismo:** **Paralelo com** só se **Onde** for disjunto. Tasks paralelas ainda precisam de **Interfaces** se houver contrato compartilhado.
