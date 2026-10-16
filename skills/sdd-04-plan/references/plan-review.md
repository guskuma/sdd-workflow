# Review do plano (self-review + compliance)

Segundo olhar **antes** do humano (`/sdd-05-review`). Não substitui o 05. Não é o loop do 06.

Prompt do revisor: [`../prompt-plan-compliance.md`](../prompt-plan-compliance.md).

## 1. Self-review

Em ondas, só o escopo da onda (skeleton ou Fase N).

1. Cada RF/US do escopo tem task (e Step, se detalhe)?
2. Nenhum placeholder da lista proibida em [`plan-task-format.md`](./plan-task-format.md)?
3. Nomes/assinaturas iguais entre Interfaces e Steps?
4. Uma task sozinha (Constraints + Mapa + Context pack + Interfaces + Steps) basta para implementar? (N/A no skeleton)
5. Steps com uma ação e ≤5 min, ou justificativa?
6. `plan_depth` com critério, artefatos no modo certo, thin slice com teste completo?
7. Todo step de código/verificação tem artefato suficiente, ou a frase permitida de [`plan-depth.md`](./plan-depth.md)?
8. Se usou Task: material A–F completo e snippets imitam o As Is?

Corrigir inline. Gap óbvio não chega ao revisor.

## 2. Gate automático (readonly, máx. 2 iterações)

Ondas: `skeleton` → cada `fase-N` → `cross`. Plano monólito: um review com escopo `cross` (ou `fase-1` se só uma fase).

```
Self-review do escopo
  → revisor readonly
  → ✅ → checkpoint / próxima onda / finalização se cross
  → ❌ → orquestrador corrige → iter++
  → no máximo 2 ciclos; se ainda ❌ → escalar ao dev (não marcar planned)
```

| Papel | Quem | Modo |
|-------|------|------|
| Revisor | Subagente `Task`, ou orquestrador em segunda passagem se não houver `Task` | readonly |
| Correção | Orquestrador | só o plano (`tasks.md` / §5; spec só com consenso de desvio) |

1. 1ª passada: subagente fresco. 2ª passada: retomar o mesmo revisor no delta. Sem continuação → Task novo com prompt integral.
2. Só **Crítico** bloqueia. **Melhoria** não força iteração.
3. `iter` 1..2 = pares review → correção por escopo. Depois da correção da iteração 2, um review final. Ainda ❌ → escalar. Não `status: planned`.
4. `plan_depth: questionável` sem override do dev → Crítico, ou uma pergunta ao dev.
5. Formato curto: gate opcional (cobertura + placeholders + DoD).
6. Sem `Task`: segunda passagem readonly, mesma regra de 2 iterações.
7. `cross` não re-audita Step já ✅ em `fase-N`.
8. Quem corrigiu não é o revisor da passada seguinte.

Não implementar código. Não abrir `/sdd-06-execute`. Não aprovar no lugar do dev. Não marcar `planned` antes do `cross` quando ondas estão ativas.

## 3. Reedição depois do `/sdd-05-review`

Se o 05 alterar Steps, Interfaces, Mapa de arquivos ou `plan_depth`, este gate roda de novo no escopo tocado antes de `status: approved`.
