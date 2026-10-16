# Prompt — Plan compliance (subagente readonly)

Usar no fim de cada **onda** de `/sdd-04-plan` (e na onda final `cross`), **antes** de `status: planned` e de sugerir `/sdd-05-review`. Subagente **não altera** `tasks.md` / `spec.md` — só revisa. O orquestrador aplica correções. Substituir `{...}`.

- **1ª passada** do escopo: Task **novo** (fresco) com o pacote integral abaixo.
- **2ª passada** (após correção do orquestrador): **preferir retomada** do mesmo revisor com o bloco **delta**; Task novo com pacote integral se não houver continuação.

## Modo delta (retomada — 2ª passada do mesmo escopo)

```
## Plan compliance — delta — escopo {skeleton | fase-N | cross}

NÃO edite arquivos. Você já revisou este escopo; Críticos da passada anterior estão FECHADOS salvo o que o orquestrador não corrigiu.

### Fechado / ainda aberto
{colar Críticos da 1ª passada + o que o orquestrador diz ter corrigido}

### O que mudou em tasks.md / §5
{trechos ou seções alteradas — só o delta}

### Verificar agora
1. Cada Crítico aberto foi resolvido no delta?
2. A correção introduziu placeholder, Interface quebrada ou Step sem artefato no escopo tocado?
3. (fase-N/cross) Nomes Consumes/Produces ainda consistentes no que mudou?

### Retornar (mesmo formato fixo)
**Escopo:** …
**Resultado:** ✅ | ❌
**Crítico:** … | "nenhum"
**Melhoria:** …
**plan_depth:** …
**Zero-context:** …
**Evidência:** paths/seções do delta
```

## Modo Task novo / 1ª passada (pacote integral)

```
Você revisa o PLANO SDD (não código). NÃO edite arquivos. NÃO implemente.

## Escopo desta review
{skeleton | fase-N | cross}

- skeleton → só Global Constraints, Mapa, plan_depth, tabela de Fases (títulos/IDs), impactos; NÃO exigir Steps
- fase-N → Constraints + Mapa + tasks **detalhadas da Fase {N}** + Interfaces/Produces das fases das quais {N} depende; NÃO reler Steps de outras fases
- cross → cobertura RF/US global + consistência de nomes Interfaces entre fases + grafo; NÃO re-auditar cada Step já ✅ em fase-N

## Material (ler de verdade — só o necessário ao escopo)
- Pasta da spec: {caminho-pasta-spec}
- tasks.md: seções do escopo acima
- spec.md: §2/§4 filtrados ao escopo (skeleton/cross: visão geral; fase-N: RF/US da fase)
- design.md se existir e for relevante ao escopo
- AGENTS.md (só gate / restrições padrão)

## Premissa
O executor no /sdd-06-execute será um subagente com ZERO contexto do chat.
plan_depth vigente no escopo: {snippets | contracts | N/A se formato curto}
tipo da spec: {feat|fix|…}

## Checklist (adaptar ao escopo)

### Cobertura (skeleton + cross + fase-N)
1. Cada RF / US / critério de sucesso do escopo tem task (e Step, se fase-N/cross) rastreável?
2. Non-goals e restrições não são violados?
3. Edge cases cobertos ou N/A justificado? (fase-N/cross)

### Estrutura zero-context
4. Global Constraints + Mapa presentes? (skeleton+)
5. plan_depth registrado com critério plausível (`references/plan-depth.md`)? Limiar/híbrido sem override → Ambíguo.
6. (fase-N) Cada task obrigatória tem Context pack + Interfaces + Steps?
7. (fase-N/cross) Interfaces: Produces de Tn = Consumes de Tn+1 (nomes idênticos)?

### Bite-size + Iron Law (fase-N only; cross só se spotting óbvio)
8. Steps = 1 ação, alvo 2–5 min?
9. Artefatos batem com plan_depth?
   - snippets → snippet completo + comando + esperado
   - contracts → assinaturas/Produces + teste (ou scaffold) completo; thin slice com teste completo; prosa só a frase permitida de `references/plan-depth.md`
10. Placeholders proibidos? (TBD, "similar à T0X", prosa que não seja a frase permitida de `references/plan-depth.md`)

### Executabilidade
11. (fase-N) Dá para implementar UMA task só com Constraints + Mapa + aquela task?
12. Paralelismo: Paralelo?=sim só com Onde disjunto?
13. TDD: se tdd:true, Steps red→green (respeitando tdd_integracao)?
14. (fase-N) Snippets/contratos parecem imitados do As Is / AGENTS — ou cheiram a API inventada?

## Retornar (formato fixo)

**Escopo:** {skeleton | fase-N | cross}
**Resultado:** ✅ | ❌

**Crítico:** (bloqueia avanço da onda / planned — lista; ou "nenhum")
- …

**Melhoria:** (não bloqueia sozinha — lista; ou "nenhum")
- …

**plan_depth:** ok | questionável — {motivo} | N/A neste escopo

**Zero-context:** ok | falha | N/A — {task(s) e por quê}

**Evidência:** paths/seções citadas

Se ✅: uma frase ("Onda ok" / "Pronto para /sdd-05-review" se cross).
Se ❌: liste só o que o orquestrador deve corrigir (acionável, sem reescrever o plano inteiro).
```
