---
name: debugging
description: >-
  Debugging sistemático: causa raiz antes do fix. Invocar em falhas de teste, build,
  integração externa ou comportamento inesperado durante Execute (06), Task review (07)
  ou Spec review (08). Não substitui as fases SDD. Genérico para qualquer stack.
---

# Debugging sistemático

## Objetivo

Encontrar **causa raiz** antes de alterar código. Patches no sintoma geram rework e shadow fixes.

**Iron Law:**

```
NENHUM FIX SEM INVESTIGAÇÃO DE CAUSA RAIZ
```

## Quando invocar

| Situação | Quem dispara |
|----------|--------------|
| Gate iterativo falhou | `/sdd-06-execute` |
| Teste que passava passou a falhar | `/sdd-06-execute`, `/sdd-07-task-review` |
| Erro de integração externa inesperado | `/sdd-06-execute` |
| Build/compile falhou após mudança | `/sdd-06-execute` |
| Task review reprovada por bug | `/sdd-06-execute` (reentrada) |

**Não pular quando:** parece simples, há pressa, ou "só um quick fix".

## Contexto do projeto

Integrações externas, mapa de código e comandos de gate: `AGENTS.md`. Convenções de código: rules/convenções do projeto (ver `AGENTS.md`).

## As quatro fases

Completar cada fase antes da próxima.

### Fase 1 — Investigar causa raiz

**Antes de editar código de produção:**

1. Ler mensagens de erro e stack trace por completo (linha, arquivo, código).
2. Reproduzir de forma confiável rodando o teste/comando relevante (ver `AGENTS.md` — Gate de qualidade).
3. Verificar mudanças recentes (`git diff`, commits da task).
4. Em integrações externas: consultar o mapa em `AGENTS.md`; verificar o mapeamento de erros do projeto.
5. Em sistemas multi-camada (entrada → serviço → cliente): rastrear onde o valor/comportamento errado **entra** — corrigir na origem, não no sintoma.

Registrar em `executions.md` (seção da task):

```markdown
### Debug — {data}
- **Sintoma:** ...
- **Reprodução:** comando + output resumido
- **Hipótese:** ...
- **Evidência:** ...
```

### Fase 2 — Fix mínimo alinhado à spec

- O fix deve resolver a **causa**, não mascarar o sintoma.
- Respeitar restrições da spec e as restrições padrão do projeto (`AGENTS.md`).
- Se a causa exigir **mudança de escopo** → parar; seguir o fluxo de **desvio** SDD (atualizar spec/tasks antes de codar).
- Integrações excluídas de TDD (`AGENTS.md`): pode usar mocks/stubs existentes; não impor test-first retroativo sem opt-in.

### Fase 3 — Verificar

Invocar a skill **`verification`** antes de declarar resolvido.

### Fase 4 — Registrar

Atualizar `executions.md`:

```markdown
- **Causa raiz:** ...
- **Fix:** ...
- **Verificação:** [link ao bloco verification em executions.md]
```

## Restrições

- Não violar restrições do projeto (`AGENTS.md`) sem atualizar a spec.
- Não adicionar shadow code durante o debug.
- Múltiplas tentativas de fix sem nova evidência → voltar à Fase 1.

## Saída esperada

Causa documentada, fix mínimo, verificação com evidência, retorno ao fluxo SDD (`/sdd-06-execute` ou revisão).
