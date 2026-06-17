# Prompt — Estágio 2: Code quality (subagente readonly ou mesma sessão)

Só após o Estágio 1 ✅. Copiar e preencher. Substituir `{...}`.

```
Você revisa a QUALIDADE do código da task {TN} em {caminho-pasta-spec}. NÃO altere código.

## Material
- git diff dos arquivos da task
- spec.md §2 (Restrições), AGENTS.md (restrições padrão e convenções)
- executions.md (bloco Verificação da task, se houver)

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
