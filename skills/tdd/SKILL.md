---
name: tdd
description: >-
  TDD condicional: red → green → refactor com Iron Law. Invocar quando a spec tiver
  tdd: true (frontmatter) durante Execute (06), Plan (04) ou debug de comportamento.
  Não aplica se tdd: false ou legado sem campo. Genérico — stack e exclusões em AGENTS.md.
---

# TDD (condicional)

## Objetivo

Quando a spec optar por TDD (`tdd: true`), garantir ciclo **red → green → refactor** com evidência — sem produção antes do teste vermelho correto.

**Iron Law** (somente se `tdd: true`):

```
NENHUM CÓDIGO DE PRODUÇÃO SEM TESTE FALHANDO PRIMEIRO
```

Violação da letra = violação do espírito. Se escreveu produção antes do teste vermelho → **apagar** a produção, recomeçar pelo teste. Não “adaptar”, não guardar como referência.

## Quando invocar

| Situação | Ação |
|----------|------|
| `tdd: true` no frontmatter de `spec.md` | **Obrigatório** em `/sdd-06-execute` (e Steps no plan) |
| `tdd: false` ou campo ausente (legado) | **Não** invocar — gate do `AGENTS.md` basta |
| Integração listada como fora em `AGENTS.md` | Test-first **N/A** salvo `tdd_integracao` com opt-in |
| Bugfix com `tdd: true` | Teste do sintoma primeiro (deve falhar) |

Convenção completa: `specs/templates/sdd-tdd.md`.

## Ciclo Red → Green → Refactor

### RED — teste que falha pelo motivo certo

1. Escrever **um** teste mínimo do comportamento desejado.
2. Rodar o comando de teste (`AGENTS.md`).
3. Confirmar: **falhou** e a falha é a esperada (não erro de compile/import do teste).
4. Se falhou pelo motivo errado → corrigir o teste, não a produção.

Registrar evidência (skill **`verification`** ou bloco em `executions.md`).

### GREEN — mínimo para passar

1. Implementar o **mínimo** de produção para o teste passar.
2. Rodar testes — devem passar.
3. Sem features extras, sem refator “de brinde”.

### REFACTOR — limpar com testes verdes

1. Melhorar clareza/duplicação **só** no escopo tocado.
2. Manter testes verdes a cada passo.
3. Não expandir escopo da task.

## Opt-out e exclusões

- `tdd: false` → esta skill **não** se aplica.
- Integrações excluídas (`AGENTS.md` + `tdd_integracao: fora`) → não impor test-first; mocks/stubs existentes ok.
- Protótipo throwaway / config gerada: perguntar ao dev; se dispensar TDD, registrar em `executions.md`.

## Red flags — parar

| Racionalização | Realidade |
|----------------|-----------|
| "Escrevo o código e o teste depois" | Apague a produção; comece pelo RED |
| "O teste falhou, então está ok" | Falha deve ser a **asserção** esperada |
| "É óbvio demais para TDD" | Com `tdd: true`, não há exceção por simplicidade |
| "Integração real no teste unitário" | Respeitar exclusões; opt-in em `tdd_integracao` |
| "Deixo o teste falhando e sigo" | GREEN antes da próxima task |

## Integração SDD

- **Plan:** DoD/Steps com ordem test-first quando `tdd: true`.
- **Execute:** orquestrador e `prompt-implement.md` seguem esta skill; Estágio 2 do review valida diff teste + produção.
- **Debug:** após causa raiz, se `tdd: true`, regressão com teste do sintoma (ver skill **`debugging`** + **`verification`**).

## Saída esperada

Ciclo red (falha correta) → green → refactor documentado; ou N/A justificado (`tdd: false` / integração fora).
