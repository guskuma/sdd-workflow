# Prompt — Estágio 2: Code quality (subagente readonly)

Só após o Estágio 1 ✅. Subagente **não altera código**. Substituir `{...}`.

- **Padrão:** **retomar o mesmo revisor** do Estágio 1 com o checklist abaixo (modo delta se `iter > 1`).
- **Fallback (Task novo):** agente `code-reviewer` se a plataforma tiver; senão subagente genérico com o pacote integral.

## Modo retomada após Estágio 1 ✅ (iter == 1)

```
## Estágio 2 — Code quality (mesma review) — task {TN}

NÃO altere código. O Estágio 1 (spec compliance) já está ✅ nesta passagem.
Foque só no checklist de qualidade abaixo. Material da task já está no seu contexto; releia o diff se precisar.

### Fechado no Estágio 1 (não reabrir como qualidade)
{findings rejeitados no receiving-review, com motivo — ou "nenhum"}

### Verificar (Estágio 2 — code quality)
1. Respeita as restrições da spec + AGENTS.md + convenções do projeto?
2. Gate iterativo verificado com evidência (skill verification)? Output fresco?
3. Testes cobrem o comportamento da task? Edge cases da spec?
4. Há regressão óbvia (usos alterados, integrações adjacentes)?
5. TDD ok ou N/A justificado (tdd, tdd_integracao)?

### Retornar
- **Resultado:** Aprovada | Aprovada com ressalvas | Reprovada
- **Crítico:** itens que bloqueiam (ou "nenhum")
- **Sugestão:** melhorias não bloqueantes
- **Evidência:** trechos do diff / output
```

## Modo delta (retomada, iter > 1, após Estágio 1 ✅ no delta)

```
## Estágio 2 — delta (iter {N} de 5) — task {TN}

NÃO altere código. Spec compliance do delta já está ✅. Veredito de qualidade anterior FECHADO.

### Fechado no Estágio 1 (não reabrir)
{findings rejeitados no receiving-review, com motivo — ou "nenhum"}

### Fechado
{colar Crítico/Sugestão da iter anterior — ou "nenhum"}

### Diff novo
{paths + trechos só do que mudou desde a última review}

### Verificar agora
1. Aceitos de qualidade do fix resolvidos?
2. Regressão / falha de restrição / teste no diff novo?
3. Gate ainda válido (se o orquestrador fornecer evidência fresca)?

### Retornar
- **Resultado:** Aprovada | Aprovada com ressalvas | Reprovada
- **Crítico:** … | "nenhum"
- **Sugestão:** …
- **Evidência:** trechos do diff novo
```

## Modo Task novo (fallback — pacote integral)

```
Você revisa a QUALIDADE do código da task {TN} em {caminho-pasta-spec}. NÃO altere código.

## Material
- git diff dos arquivos da task
- spec.md §2 (Restrições), AGENTS.md (restrições padrão e convenções)
- Evidência do gate (verification) desta task, se o orquestrador fornecer
- Findings rejeitados no Estágio 1 (fechados — não reabrir): {lista ou "nenhum"}

## Verificar (Estágio 2 — code quality)
1. Respeita as restrições da spec + AGENTS.md + convenções do projeto?
2. Gate iterativo verificado com evidência (skill verification)? Output fresco?
3. Testes cobrem o comportamento da task? Edge cases da spec?
4. Há regressão óbvia (usos alterados, integrações adjacentes)?
5. TDD ok ou N/A justificado (tdd, tdd_integracao)?

## Retornar
- **Resultado:** Aprovada | Aprovada com ressalvas | Reprovada
- **Crítico:** itens que bloqueiam (ou "nenhum")
- **Sugestão:** melhorias não bloqueantes
- **Evidência:** trechos do diff / output que sustentam o resultado
```
