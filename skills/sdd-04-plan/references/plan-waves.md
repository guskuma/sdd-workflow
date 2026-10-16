# Plan em ondas

Arquivos em disco = memória. O chat é scratchpad. Um planejador por vez.

## Quando obrigatório (primeira que casar)

1. Mapa com **≥ 8** paths `criar`, ou
2. Greenfield / sistema novo com `design.md`, ou
3. Dev pediu plan por fase / ondas, ou
4. Sinais de pressão de contexto (plano já longo, inconsistências, placeholders)

Duas fases **sem** um desses sinais: detalhar tudo na mesma sessão. Ondas ficam desligadas. Checkpoint em `tasks.md` continua opcional, sem parar o dev.

Plano pequeno (formato curto, < 5 tasks, 1 fase): fluxo monólito. Ondas opcionais.

## Papéis

| Papel | Quem | Edita `tasks.md`? | Escopo |
|-------|------|-------------------|--------|
| Orquestrador | Sessão `/sdd-04-plan` | **Sim** (skeleton, Progresso, correções pós-review) | Skeleton, material A–F, perguntas ao dev, checkpoints |
| Planejador | Subagente `Task` + [`../prompt-plan-phase.md`](../prompt-plan-phase.md) | **Sim** — só blocos T0X da fase | **Uma** fase por dispatch |
| Revisor | Subagente `Task` + [`../prompt-plan-compliance.md`](../prompt-plan-compliance.md) | **Não** | `skeleton` \| `fase-N` \| `cross` |

Sem `Task`: o orquestrador detalha uma fase por vez no arquivo e faz a segunda passagem no lugar do revisor.

## Fluxo

```
Onda 0 — Skeleton
  Constraints + Mapa + plan_depth + Fases (IDs/títulos) + Progresso do Plan
  → review escopo=skeleton
  → checkpoint

Onda 1..N — Detalhe Fase N (sequencial)
  → material A–F (prompt-plan-phase) — amostras As Is + gate AGENTS
  → um planejador escreve T0X em tasks.md
  → orquestrador relê tasks.md → self-review
  → review escopo=fase-N (máx. 2 iters)
  → checkpoint

Onda final
  → review escopo=cross
  → Finalização — só então status: planned
```

## Material e retomada

Sem amostras As Is (ou padrão design/AGENTS) e sem comandos de gate → falha de preparação. Não disparar.

`NEEDS_CONTEXT` sem edição de `tasks.md`: completar só o que faltou e **retomar** o mesmo planejador. Re-dispatch integral só se a plataforma não continuar.

Após `DONE`, reler `tasks.md`. A retomada vale só para `NEEDS_CONTEXT` dentro da mesma onda. Fase N+1 não reaproveita o planejador da Fase N.

## Checkpoint

Gravar § Progresso do Plan. No chat:

> **Checkpoint Onda {n} gravado** em `tasks.md` ({escopo fechado}).
> Contexto desta sessão pode estar cheio. **Recomendado:** nova sessão e `/sdd-04-plan` na mesma pasta para a Onda {n+1}.
> Para seguir aqui: diga “continuar nesta sessão”.

Não iniciar a próxima onda sem essa escolha.

## Retomada no início de `/sdd-04-plan`

| Estado | Ação |
|--------|------|
| Sem skeleton | Onda 0 |
| Skeleton ok, Fase k sem Context pack/Steps | Onda k |
| Fase k detalhada, compliance pendente | Só revisor `fase-k` + correção |
| Todas fases ✅, cross pendente | Onda final `cross` |
| Tudo ✅ | Sugerir `/sdd-05-review` (já `planned`) |

Não reler o chat antigo. Só disco + material da onda.

## Red flags

| Racionalização | Realidade |
|----------------|-----------|
| "Duas fases, então paro a sessão" | Ondas só com ≥8 `criar`, greenfield com `design.md`, pedido do dev, ou pressão de contexto |
| "Dois planejadores em paralelo" | Sempre sequencial |
| "Devolver markdown no chat para colar" | O planejador escreve em `tasks.md` |
| "Dispatch sem amostras de código" | Falha de preparação |
| "NEEDS_CONTEXT → reenviar A–F inteiro" | Retomar com só o que faltou |
| "Retomar o planejador da Fase 1 na Fase 2" | Onda seguinte é material fresco |
| "`planned` após Fase 1" | Só após o cross |
| "Revisor lê tasks.md inteiro sempre" | Escopo `skeleton` / `fase-N` / `cross` |
| "Confiar no summary sem reler o arquivo" | Reler `tasks.md` após DONE |
