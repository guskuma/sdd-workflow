# Prompt — Estágio 1: Spec compliance (subagente readonly)

Subagente **não altera código**. Substituir `{...}`.

- `iter == 1` (ou revisor indisponível): **Task novo** com pacote integral.
- `iter > 1` e mesmo revisor disponível: **retomar** com modo **delta**.

## Modo delta (retomada, iter > 1)

```
## Estágio 1 — delta (iter {N} de 5) — task {TN}

NÃO altere código. Você já revisou esta task; o veredito anterior está FECHADO.

### Fechado (não reabrir salvo regressão óbvia no diff novo)
{colar Missing/Extra/resultado da iter anterior — ou "nenhum finding aberto"}

### Diff novo (após o fix)
{paths em Onde + trechos/git diff só do que mudou desde a última review}

### Verificar agora
1. Os Aceitos do fix foram resolvidos no diff novo?
2. Surgiu Missing/Extra/regressão óbvia no diff novo?
3. Interfaces / DoD / Steps ainda ok no escopo tocado?

### Retornar
- **Resultado:** ✅ | ❌
- **Missing:** lista (ou "nenhum")
- **Extra:** lista (ou "nenhum")
- **Evidência:** trechos do diff novo
```

## Modo Task novo / iter 1 (pacote integral)

```
Você revisa APENAS a aderência à spec da task {TN} em {caminho-pasta-spec}. NÃO altere código.

## Material
- spec.md (goals, non-goals, RF/US, restrições) da pasta {caminho-pasta-spec}
- tasks.md / §5 (DoD, Onde, Interfaces, Steps da task {TN}; Global Constraints se houver)
- git diff dos arquivos listados em "Onde"

## Verificar (Estágio 1 — spec compliance)
1. O entregável corresponde ao DoD e aos Steps planejados?
2. Interfaces Consumes/Produces respeitadas (nomes/assinaturas), se existirem?
3. Os critérios de aceite da US / RF foram cobertos?
4. Há shadow code (algo fora da spec/plano sem desvio documentado)?
5. Há escopo EXTRA (non-goals, features não pedidas)?
6. Há escopo FALTANTE (requisitos omitidos)?
7. Há código especulativo ou alterações fora de "Onde"/Steps?

## Retornar
- **Resultado:** ✅ | ❌
- **Missing:** lista (ou "nenhum")
- **Extra:** lista (ou "nenhum")
- **Evidência:** trechos do diff que sustentam o resultado
```
