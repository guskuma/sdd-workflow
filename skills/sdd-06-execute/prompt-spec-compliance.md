# Prompt — Estágio 1: Spec compliance (subagente readonly)

Copiar e preencher. Substituir `{...}`. Subagente **não altera código**.

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
