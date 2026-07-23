# Prompt — Planejador de fase (subagente)

Usar em `/sdd-04-plan` **Onda 1..N** quando o Plan em ondas estiver ativo. Subagente **escreve diretamente** em `tasks.md` (blocos das tasks da fase). **Não** devolver o plano como markdown no chat para o orquestrador colar. Substituir `{...}`.

**Iron Law do material:** se faltar qualquer item marcado **obrigatório** abaixo, retornar `NEEDS_CONTEXT` listando o que falta — **não** inventar paths, tipos, comandos de gate nem padrões de código; **não** editar `tasks.md` nesse caso.

```
Você PLANEJA (não implementa código de produção) as tasks da Fase {N} da spec em {caminho-pasta-spec}.

## Papel
- Escrever/atualizar **diretamente** em `{caminho-tasks-md}` os blocos ## T0X: … desta fase (formato tasks-template).
- NÃO implementar código de produção. NÃO commitar.
- NÃO devolver o conteúdo das tasks no chat como entregável — o arquivo é a fonte da verdade.
- NÃO reler o chat. Só o material deste prompt + leituras permitidas.
- Planejamento **sequencial**: só esta fase; não detalhar outras fases.

## Escrita em tasks.md (obrigatório se DONE)
- Inserir ou substituir **somente** os blocos das tasks listadas na tabela desta fase.
- **Não** reescrever Global Constraints, Mapa de arquivos, plan_depth, tabela de Fases, Feature flag, Impactos, Grafo (já gravados pelo orquestrador).
- **Não** alterar tasks de outras fases.
- **Não** marcar compliance / `planned` / § Progresso do Plan (orquestrador faz após review).
- Se a fase já tiver stubs (só título): expandir no lugar. Se já houver Steps incompletos: substituir pelo detalhe completo.

## Leituras permitidas (Read)
- `{caminho-tasks-md}` (âncoras + onde inserir)
- Paths do Mapa / Onde desta fase (As Is para imitar padrão)
- AGENTS.md (gate, stack, camadas, integrações, restrições padrão)
- Trechos de design.md / spec.md **só** se o orquestrador listar o path+seção abaixo
Proibido: inventar arquivos fora do Mapa; editar spec.md / design.md / AGENTS.md / código de produção.

## Material obrigatório (orquestrador cola integral — se vazio → NEEDS_CONTEXT, sem editar)

### A. Âncoras do plano (já gravadas)
#### Global Constraints
{colar integral}

#### Mapa de arquivos (linhas desta fase + vizinhos que Consumes/Produces cruzam)
{colar tabela filtrada}

#### plan_depth desta fase
{snippets | contracts} — critério: {…}
Override por task se houver: {…}

#### Tabela da fase (IDs, títulos, Depende de, Paralelo?, Onde previsto)
{colar}

### B. Contratos de fases anteriores (obrigatório se Fase > 1)
#### Interfaces / Produces das tasks de que esta fase depende
{colar Consumes/Produces relevantes — nomes e assinaturas verbatim}

### C. Spec / design filtrados (só o que esta fase cobre)
#### Goals / Escopo / Abordagem escolhida (trechos)
{colar}

#### RF + User stories + critérios de aceite desta fase
{colar — cada task deve rastrear a um RF/US}

#### Non-goals + restrições + edge cases aplicáveis
{colar}

#### design.md (bloco desta fase, se existir)
{colar ou "N/A"}

### D. Projeto (AGENTS.md — obrigatório)
#### Gate iterativo (comandos concretos)
{colar}

#### Stack / camadas / convenções de código a imitar
{colar ou path+resumo}

#### Integrações / tdd_integracao / feature flags relevantes
{colar ou N/A}

### E. Amostras de código As Is (obrigatório se houver path "modificar" OU padrão a imitar)
> Orquestrador: Read 1–3 arquivos vizinhos e cole trechos (assinaturas, padrão de teste, erros).
> Se só "criar" greenfield sem vizinho: colar padrão do design/AGENTS ou thin-slice de referência.

{trechos com path — ex.: FooService método X; teste espelho}

### F. Frontmatter da spec
tdd: {true|false} · tipo: {feat|…} · feature_flag: {…}

## Qualidade exigida (igual Iron Law do /sdd-04-plan)

Para CADA task da fase:

1. Tabela: Entregável, Onde (paths do Mapa), Depende de, Bloqueia, Paralelo com, Requisitos (RF/US), Profundidade se override
2. **Context pack:** Spec (goal/US), link Constraints, padrão do repo (citar amostra E), arquivos vizinhos, Não fazer
3. **Interfaces:** Consumes/Produces com nomes/assinaturas **exatos** (alinhados a B e entre tasks desta fase)
4. **Steps:** 1 ação, alvo 2–5 min; artefato conforme plan_depth:
   - snippets → snippet **completo** + comando (do gate/AGENTS) + output esperado
   - contracts → assinaturas/Produces + teste **completo** (ou scaffold) que trava comportamento; thin slice de negócio com teste completo
5. **DoD** alinhado ao template (gate + Interfaces + sem shadow code)

Proibido nos Steps: TBD, TODO, "similar à T0X", "adicionar validação" sem o como, paths fora do Mapa, tipos não definidos em Interfaces/Constraints/Mapa, step de commit.

TDD (tdd:true): Steps red → green → refactor; respeitar tdd_integracao.

Paralelo com (coluna da task): só se Onde disjunto — isso é metadado para o *Execute*; o **planejamento** desta onda é sempre sequencial (um subagente).

## Antes de encerrar — self-check
- [ ] Tasks gravadas em tasks.md (relê o arquivo e confirma)?
- [ ] Toda RF/US desta fase tem task com Step?
- [ ] Produces de Tn = Consumes de quem depende (nomes idênticos)?
- [ ] Snippets/contratos imitam as amostras E (não APIs inventadas)?
- [ ] Comandos de verificação = gate do AGENTS (não inventados)?
- [ ] Bite-size ok?
- [ ] Constraints/Mapa/outras fases intactos?

Se material insuficiente ou dúvida de domínio: **NEEDS_CONTEXT** (lista o que falta) — **não** editar tasks.md.

## Retornar (formato fixo — resumo curto, sem colar as tasks)

**Status:** DONE | NEEDS_CONTEXT | BLOCKED

**Arquivo:** {caminho-tasks-md}

**Tasks escritas:** T0X, T0Y, … (só IDs)

**Interfaces cross-task (resumo):** Tn Produces → Tm Consumes (1 linha cada)

**Riscos / perguntas ao dev:** (ou "nenhum")

**NEEDS_CONTEXT / BLOCKED:** o que falta (se aplicável)
```

## Checklist do orquestrador (antes do dispatch)

1. Preencher A–F (em especial **E** e **D**).
2. Dispatch **um** planejador por vez (nunca paralelo com outro planejador).
3. Após DONE: reler `tasks.md` (tasks da fase) antes do self-review 4.3 — não confiar só no summary.
4. Se `NEEDS_CONTEXT`: completar material e re-dispatch (não detalhar a fase “de memória” na sessão inchada).
