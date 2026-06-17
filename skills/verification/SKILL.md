---
name: verification
description: >-
  Verificação com evidência: rodar o comando, ler o output e só então afirmar sucesso.
  Invocar antes de marcar task done, aprovar revisão, fechar spec review ou registrar
  gate verde em executions.md. Aplica-se a qualquer stack (comandos no AGENTS.md).
---

# Verificação com evidência

## Objetivo

**Evidência antes de afirmação.** Nunca declarar sucesso sem output fresco do comando.

**Iron Law:**

```
NENHUMA AFIRMAÇÃO DE SUCESSO SEM OUTPUT FRESCO DO COMANDO
```

## Quando invocar

| Momento | Skill que dispara |
|---------|-------------------|
| Fim de task/fase em Execute | `/sdd-06-execute` |
| Estágio 2 de Task review | `/sdd-07-task-review` |
| Validação final da spec | `/sdd-08-spec-review` |
| Após debug resolvido | `debugging` |
| Após execução paralela integrada | `parallel-execution` |

## Gate function (obrigatório)

Antes de qualquer afirmação de sucesso:

1. **IDENTIFICAR** — qual comando prova a afirmação?
2. **RODAR** — comando completo, nesta sessão (não reutilizar output antigo).
3. **LER** — exit code, contagem de falhas, warnings relevantes.
4. **VERIFICAR** — o output confirma a afirmação?
5. **SÓ ENTÃO** — registrar em `executions.md` ou reportar no chat.

## Comandos por contexto

Os comandos concretos do projeto estão no `AGENTS.md` (seção **Gate de qualidade**). Padrão:

| Contexto | Comando |
|----------|---------|
| Gate iterativo (task/fase) | lint/compile → testes → build (ver `AGENTS.md`) |
| Gate completo (spec) | comando completo de verificação (ver `AGENTS.md`) |
| Teste único (debug) | teste de uma classe/arquivo (ver `AGENTS.md`) |

> Se o `AGENTS.md` não definir os comandos, **pergunte ao dev** quais são antes de afirmar gate verde.

### Regressão TDD (`tdd: true`)

Para bugfix ou novo comportamento:

1. Escrever teste → rodar → **deve FALHAR**
2. Implementar fix → rodar → **deve PASSAR**
3. (Opcional forte) Reverter fix → rodar → **deve FALHAR** → restaurar → **PASSAR**

Registrar cada passo com output.

## Formato de registro em `executions.md`

```markdown
### Verificação — {data} {contexto}
- **Comando:** `<comando do AGENTS.md>`
- **Exit code:** 0
- **Evidência:** "<linha-chave do output: ex. Tests: 142 passed, 0 failed>"
- **Afirmação:** gate iterativo verde
```

## Red flags — parar

- "Deve passar agora", "provavelmente ok", "parece correto"
- Confiar em report de subagente sem revisar o diff + rodar o comando
- Linter passou ≠ compile passou ≠ testes passaram
- Registrar gate verde em `executions.md` sem bloco Verificação

## Tabela de afirmações vs evidência

| Afirmação | Exige | Não basta |
|-----------|-------|-----------|
| Testes passam | output do comando de teste com 0 falhas | run anterior |
| Build ok | exit 0 do compile/build | só linter |
| Bug corrigido | teste do sintoma passa | código alterado |
| Task concluída | gate iterativo + revisão | só implementação |
| Spec pronta | gate completo + spec review | só tasks done |

## Saída esperada

Bloco Verificação em `executions.md` ou no chat com comando + output + afirmação explícita.
