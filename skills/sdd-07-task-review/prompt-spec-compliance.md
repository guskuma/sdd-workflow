# Prompt — Estágio 1: Spec compliance (subagente readonly ou mesma sessão)

Copiar e preencher. Substituir `{...}`.

```
Você revisa APENAS a aderência à spec da task {TN} em {caminho-pasta-spec}. NÃO altere código.

## Material
- spec.md (goals, non-goals, RF/US, restrições) da pasta {caminho-pasta-spec}
- tasks.md / §5 (DoD, Onde, Steps da task {TN})
- git diff dos arquivos listados em "Onde"

## Verificar (Estágio 1 — spec compliance)
1. O entregável corresponde ao DoD e aos Steps planejados?
2. Os critérios de aceite da US / RF foram cobertos?
3. Há shadow code (algo fora da spec/plano sem desvio documentado)?
4. Há escopo EXTRA (non-goals, features não pedidas)?
5. Há escopo FALTANTE (requisitos omitidos)?

## Retornar
- **Resultado:** ✅ | ❌
- **Missing:** lista (ou "nenhum")
- **Extra:** lista (ou "nenhum")
- **Evidência:** trechos do diff que sustentam o resultado
```
