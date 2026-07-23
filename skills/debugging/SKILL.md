---
name: debugging
description: >-
  Debugging sistemático: causa raiz antes do fix. Invocar em falhas de teste, build,
  integração externa ou comportamento inesperado durante Execute (06) ou Spec review (07).
  Não substitui as fases SDD. Genérico para qualquer stack.
---

# Debugging sistemático

## Objetivo

Encontrar **causa raiz** antes de alterar código. Patches no sintoma geram rework e shadow fixes.

**Iron Law:**

```
NENHUM FIX SEM INVESTIGAÇÃO DE CAUSA RAIZ
```

Se a Fase 1 não terminou, **não** propor fix.

## Quando invocar

| Situação | Quem dispara |
|----------|--------------|
| Gate iterativo falhou | `/sdd-06-execute` |
| Teste que passava passou a falhar | `/sdd-06-execute` |
| Erro de integração externa inesperado | `/sdd-06-execute` |
| Build/compile falhou após mudança | `/sdd-06-execute` |
| Loop de revisão reprovado por bug | `/sdd-06-execute` (fix no loop) |

**Não pular quando:** parece simples, há pressa, ou "só um quick fix".

## Contexto do projeto

Integrações externas, mapa de código e comandos de gate: `AGENTS.md`. Convenções de código: rules/convenções do projeto (ver `AGENTS.md`).

## As quatro fases

Completar cada fase antes da próxima.

### Fase 1 — Investigar causa raiz

**Antes de editar código de produção:**

1. Ler mensagens de erro e stack trace por completo (linha, arquivo, código).
2. Reproduzir de forma confiável rodando o teste/comando relevante (ver `AGENTS.md` — Gate de qualidade). **Se não reproduzir → reunir mais dados; não chutar.**
3. Verificar mudanças recentes (`git diff`, commits da task).
4. Em integrações externas: consultar o mapa em `AGENTS.md`; verificar o mapeamento de erros do projeto.
5. **Sistemas multi-camada** (entrada → serviço → cliente, CI → build → deploy): **antes** de fix, instrumentar boundaries:
   - Logar o que **entra** e o que **sai** em cada camada relevante
   - Rodar uma vez para ver **onde** quebra
   - Só então investigar o componente falho
6. Erro fundo na call stack: rastrear o valor/comportamento errado **para trás** até a origem; corrigir na origem, não no sintoma.

Registrar em `executions.md` (seção da task):

```markdown
### Debug — {data}
- **Sintoma:** ...
- **Reprodução:** comando + output resumido
- **Hipótese:** ...
- **Evidência:** ...
```

### Fase 2 — Padrão e hipótese

1. Comparar com exemplo que **funciona** no mesmo codebase (se houver).
2. Listar diferenças — não descartar “isso não pode importar”.
3. Formar **uma** hipótese explícita: "A causa é X porque Y".
4. Testar a hipótese com a **menor** mudança possível (uma variável). Se falhar → nova hipótese; **não** empilhar fixes.

### Fase 3 — Fix mínimo alinhado à spec

- O fix deve resolver a **causa**, não mascarar o sintoma.
- Respeitar restrições da spec e as restrições padrão do projeto (`AGENTS.md`).
- Se a causa exigir **mudança de escopo** → parar; seguir o fluxo de **desvio** SDD (atualizar spec/tasks antes de codar).
- Se `tdd: true`: criar/ajustar teste do sintoma **primeiro** (skill **`tdd`**) — deve falhar; depois o fix.
- Integrações excluídas de TDD (`AGENTS.md`): pode usar mocks/stubs existentes; não impor test-first retroativo sem opt-in.
- **Um** fix por vez. Sem "já que estou aqui".

**Se ≥ 3 tentativas de fix falharam:** parar. Questionar arquitetura/padrão com o dev — não tentar o 4º patch no escuro.

### Fase 4 — Verificar e registrar

Invocar a skill **`verification`** antes de declarar resolvido.

Atualizar `executions.md`:

```markdown
- **Causa raiz:** ...
- **Fix:** ...
- **Verificação:** [link ao bloco verification em executions.md]
```

## Red flags — voltar à Fase 1

| Racionalização | Realidade |
|----------------|-----------|
| "Quick fix agora, investigo depois" | O primeiro fix define o padrão — faça certo |
| "É simples, não precisa de processo" | Bugs simples também têm causa raiz |
| "Mudo várias coisas e rodo o teste" | Não isola o que funcionou |
| "Provavelmente é X" | Evidência antes do fix |
| "Mais uma tentativa" (após 2+ falhas) | ≥3 falhas → discutir arquitetura |

## Restrições

- Não violar restrições do projeto (`AGENTS.md`) sem atualizar a spec.
- Não adicionar shadow code durante o debug.
- Múltiplas tentativas de fix sem nova evidência → voltar à Fase 1.

## Saída esperada

Causa documentada, fix mínimo, verificação com evidência, retorno ao fluxo SDD (`/sdd-06-execute` ou revisão).
