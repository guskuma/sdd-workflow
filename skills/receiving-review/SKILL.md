---
name: receiving-review
description: >-
  Receber feedback de code review com rigor técnico: entender, verificar no código,
  pushback se errado, só então implementar. Obrigatório no loop do /sdd-06-execute antes
  de qualquer fix (apontamentos dos Estágios 1–2). Também use para review externo (MR/PR,
  dev, bots) — especialmente se parecer vago ou questionável.
---

# Receber code review

## Objetivo

Tratar feedback de review como **hipótese técnica**, não como ordem social. Verificar antes de implementar.

**Iron Law:**

```
NENHUMA IMPLEMENTAÇÃO DE FEEDBACK SEM ENTENDER E VERIFICAR NO CÓDIGO
```

Concordância performática ("Você está absolutamente certo!") é proibida. Ação ou pushback técnico.

## Quando invocar

### No loop do `/sdd-06-execute` (obrigatório)

Após Estágio 1 ❌ ou Estágio 2 **Reprovada**, **antes** de `prompt-fix`:

1. Rodar esta skill (orquestrador, ou template [`../sdd-06-execute/prompt-receiving-review.md`](../sdd-06-execute/prompt-receiving-review.md)).
2. Classificar cada finding: **Aceito** | **Rejeitado** | **Ambíguo**.
3. Só findings **Aceitos** vão para o fix. Ambíguos → parar e perguntar ao dev.
4. Se todos Rejeitados → não fixar; tratar o estágio como OK para aquele conjunto.

Não substitui os Estágios 1–2 (eles **produzem** os findings). Esta skill **filtra** antes do código mudar.

### Fora do execute (review externo)

- Comentários em MR/PR (GitHub/GitLab/etc.)
- Feedback do dev no chat após `/sdd-06-execute` ou `/sdd-07-spec-review`
- Sugestões de revisor humano ou bot (Bugbot, Copilot review, etc.)
- Lista de itens "corrija 1–N" no meio ou após a spec

## Padrão de resposta

```
1. LER      — feedback completo, sem reagir
2. ENTENDER — reformular o requisito (ou perguntar)
3. VERIFICAR — checar no codebase / spec / AGENTS.md
4. AVALIAR  — faz sentido NESTE projeto?
5. RESPONDER — ack técnico ou pushback fundamentado
6. IMPLEMENTAR — só Aceitos; um item por vez; verification após cada um
                 (no 06: passo 6 = dispatch prompt-fix com o lote Aceito)
```

## Fontes

| Fonte | Postura |
|-------|---------|
| Estágios 1–2 do `/sdd-06-execute` | **Sempre** filtrar com esta skill antes do fix |
| Dev (humano do projeto) | Confiança alta — ainda assim esclarecer escopo; sem bajulação |
| Revisor externo / bot | Verificar corretude; pushback se quebra contrato, plataforma ou spec |

## Feedback ambíguo

Se **qualquer** item da lista estiver unclear:

1. **Parar** — não implementar os “claros” primeiro (no 06: não dispatch fix).
2. Perguntar só sobre os ambíguos (agrupar numa mensagem se forem dependentes).
3. Itens podem ser relacionados; entendimento parcial = implementação errada.

## Pushback (quando o feedback está errado)

Antes de aceitar um finding, checar:

1. Tecnicamente correto para **este** codebase / diff da task?
2. Quebra comportamento existente ou restrições da spec / `AGENTS.md`?
3. Há razão histórica ou non-goal para o código atual?
4. Está **dentro do escopo** da task (Onde / Steps)?
5. O revisor tem o contexto completo (spec, non-goals)?

Se parecer errado → **Rejeitado** com raciocínio técnico e evidência. Se não puder verificar → **Ambíguo** e perguntar ao dev.

## Implementação (após Aceitos)

1. Um item por vez (ou grupo atomicamente dependente) — no 06 o `prompt-fix` recebe o lote Aceito.
2. Se a mudança alterar comportamento da spec → **atualizar spec/tasks antes** (fluxo de desvio SDD).
3. Após o fix: skill **`verification`** (gate do 06).
4. Se falhar teste/build → skill **`debugging`**, não stack de patches.
5. Commits só se o dev pedir.

## Red flags — parar

| Racionalização | Realidade |
|----------------|-----------|
| "You're absolutely right!" | Ack técnico ou pushback |
| "O Estágio 1/2 pediu, então está certo" | Filtrar com esta skill antes do fix |
| "Implemento tudo e pergunto depois" | Ambiguidade bloqueia o lote inteiro |
| "O bot pediu, então está certo" | Verificar no código |
| "É só um nit, pulo a verification" | Evidence before done |
| "Aceito para não discutir" | Correção técnica > conforto social |

## Saída esperada

Lista Aceitos / Rejeitados / Ambíguos com motivos; fix **somente** dos Aceitos (ou escalação); spec atualizada se o escopo mudou.
