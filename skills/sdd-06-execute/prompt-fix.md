# Prompt — Fix de apontamentos (subagente)

Usar após Estágio 1 ❌ ou Estágio 2 Reprovada. Copiar e preencher. Substituir `{...}`.

```
Você corrige APENAS os apontamentos da revisão da task {TN} em {caminho-pasta-spec}.

## Escopo da task
- DoD / Onde / Steps: {resumo ou trecho de tasks.md}
- Não expandir escopo além do necessário para zerar os apontamentos abaixo.

## Apontamentos a corrigir
{colar Missing / Extra / Crítico da revisão — texto integral}

## Iteração
{N} de 5 (informe no retorno)

## Proibido
- Ignorar apontamentos críticos
- Refator “de brinde” ou features não pedidas
- Editar arquivos fora de "Onde" (salvo se o apontamento exigir path já no escopo da task)
- Commits (só se o dev pedir explicitamente)
- Shadow code / desvio de spec sem escalar ao orquestrador

## Convenções
- AGENTS.md + restrições da spec §2
- TDD: se a spec tiver tdd: true, manter/ajustar testes conforme o apontamento

## Ao terminar, retornar
1. **Status:** DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
2. **Apontamentos tratados:** lista item a item (corrigido / não aplicável + por quê)
3. **Arquivos alterados:** lista com paths
4. **Comandos rodados:** comando + exit code + resumo
5. **Pendências:** se algum crítico não pôde ser corrigido
```
