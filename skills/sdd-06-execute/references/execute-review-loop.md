# Loop de revisão (por task)

Ler e seguir antes de dispatch de revisor ou de fix. Papéis separados: o implementador não revisa o próprio código; o revisor não escreve o fix. Um revisor por task.

Prompts: [`../prompt-spec-compliance.md`](../prompt-spec-compliance.md), [`../prompt-code-quality.md`](../prompt-code-quality.md), [`../prompt-receiving-review.md`](../prompt-receiving-review.md), [`../prompt-fix.md`](../prompt-fix.md). Skill **`receiving-review`**.

## Ordem

```
Estágio 1 — Spec compliance (Task novo na 1ª vez; retomada + delta se iter > 1)
  → se ❌: receiving-review
       → aceitos? fix → iter++ → Estágio 1 no mesmo revisor
       → só rejeitados? tratar E1 como ✅
  → se ✅: Estágio 2 — mesmo revisor
       → Reprovada: receiving-review → (aceitos? fix → iter++ → Estágio 1)
       → Aprovada: concluir
       → Ressalvas: escalar ao dev
```

Não iniciar o Estágio 2 com finding **aceito** de E1 ainda aberto.

Não enviar `prompt-fix` sem `receiving-review` naquela reprovação.

`iter` começa em 1. Sobe só quando houve fix com findings aceitos.

## Estágio 1 — entregou o pedido?

- DoD / Steps
- Interfaces Consumes/Produces
- Critérios da US / RF
- Sem shadow code, sem escopo extra, sem código especulativo, sem arquivo fora de **Onde**
- Sem requisito omitido

`iter == 1`: Task novo. `iter > 1`: retomar com delta. Ler o diff em **Onde**.

## Estágio 2 — qualidade

Só com Estágio 1 ✅, inclusive quando todos os findings de E1 foram rejeitados.

Checklist: restrições da spec + `AGENTS.md`; gate iterativo via **`verification`**; testes e edge cases; regressão óbvia; TDD ok ou N/A (`tdd`, `tdd_integracao`).

Retomar o mesmo revisor. No handoff, colar os findings **rejeitados** do Estágio 1 como fechados, com o motivo. O revisor não reabre esses itens como problema de qualidade.

Fallback (Task novo): o retorno segue [`../prompt-code-quality.md`](../prompt-code-quality.md) (`Aprovada` | `Aprovada com ressalvas` | `Reprovada`; `Crítico` | `Sugestão`). O agente `code-reviewer` usa esse formato. Ele não refaz o Estágio 1 e não fala com o implementador.

- **Reprovada** → receiving-review com Crítico. Sugestão não vai para o fix.
- **Aprovada** → task `done`.
- **Aprovada com ressalvas** → escalar ao dev. Sem fix automático.

## Receiving-review

| Veredito | Ação |
|----------|------|
| **Aceito** | Entra no fix |
| **Rejeitado** | Não corrigir. Registrar motivo. Não sobe `iter`. |
| **Ambíguo** | Parar. Perguntar ao dev. Não fixar até esclarecer. |

1. O fix recebe só Aceitos.
2. Nenhum Aceito e nenhum Ambíguo → o estágio segue como ✅.
3. Há Aceitos → um dispatch de `prompt-fix` com **todos** os Aceitos desta reprovação → `iter++` → Estágio 1 no mesmo revisor, modo delta, com os rejeitados listados como fechados.
4. O orquestrador lê o diff. Não confia só no texto do revisor.

No execute o fix é o lote. Fora do execute, a skill **`receiving-review`** manda um Aceito por vez.

## Limite

| Situação | Ação |
|----------|------|
| `iter` 1..4 com Aceitos | Fix + re-review desde o Estágio 1 |
| `iter` == 5 e ainda há Aceito crítico | **Parar.** Mostrar aceitos e rejeitados. O dev decide. Sem sexto fix. |
| Estágio 2 com ressalvas | **Parar.** Dev aceita (`done`) ou pede mais uma rodada |
| Ambíguo | **Parar** |

Não gravar cada iteração. No fim, preencher a seção **Revisão de task** de `specs/templates/executions-template.md`. Não inventar outro bloco.
