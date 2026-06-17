---
name: commit-message
description: >-
  Gera mensagens de commit no formato Conventional Commits, opcionalmente com a chave
  do issue tracker. Use quando o usuário pedir mensagem de commit, ajuda para commitar,
  ou antes de um git commit.
---

# Mensagens de commit

## Formato (subject)

Uma linha, em português, imperativo ou descritivo claro. Com issue tracker configurado (`AGENTS.md`):

```
<type>: <ISSUE-KEY> <descrição>
```

Sem issue tracker (ou sem key conhecida):

```
<type>: <descrição>
```

**Exemplos:**

```
feat: PROJ-1234 Implementação da funcionalidade XYZ
fix: Corrige timeout na chamada de integração externa
```

### Regras

| Regra | Detalhe |
|-------|---------|
| `type` | Minúsculas, sem escopo entre parênteses |
| `ISSUE-KEY` | Conforme o issue tracker do projeto (`AGENTS.md`); omitir se não houver |
| Separador | Dois pontos + espaço após o type; espaço entre a key e a descrição |
| Descrição | Frase curta; primeira letra maiúscula; sem ponto final |
| Tamanho | Subject ≤ 72 caracteres quando possível |

### Types permitidos

| Type | Quando usar |
|------|-------------|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `docs` | Só documentação |
| `refactor` | Mudança interna sem alterar comportamento observável |
| `test` | Testes |
| `chore` | Build, deps, configs, tooling |
| `perf` | Melhoria de performance |

Não usar `feat!` / breaking change salvo pedido explícito.

## Corpo (opcional)

Se o diff for grande ou houver contexto útil, adicionar linha em branco e corpo em português:

```
feat: PROJ-1234 Implementação da funcionalidade XYZ

- Valida regra de negócio no serviço
- Trata erro de integração na borda
```

## Como obter o ISSUE-KEY (se o projeto usar issue tracker)

Ordem de prioridade:

1. Informado pelo usuário no chat
2. Nome da pasta da spec em `specs/YYYY-MM-{ISSUE-KEY}-slug/`
3. Branch atual (`git branch --show-current`) se contiver a key
4. Se não houver key: **perguntar** antes de sugerir a mensagem final (ou omitir se o projeto não usa issue tracker)

## Fluxo

1. `git status` e `git diff` (staged + unstaged) em paralelo
2. `git log -5 --oneline` para alinhar o tom ao repositório
3. Identificar `type` e resumir o **porquê** da mudança (não listar cada arquivo)
4. Montar o subject no formato acima
5. Entregar **uma** mensagem pronta para `git commit -m` (e corpo se fizer sentido)

## Não fazer

- Não commitar nem dar push (só gerar a mensagem, salvo pedido explícito)
- Não incluir arquivos com segredos (`.env`, credenciais)
- Não usar formato `feat(scope):`
- Não usar inglês na descrição salvo termos técnicos inevitáveis
