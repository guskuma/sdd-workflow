---
name: using-sdd
description: Use ao iniciar qualquer conversa de desenvolvimento neste projeto — estabelece como descobrir e usar as skills SDD antes de qualquer ação, e como adaptar nomes de ferramentas entre plataformas.
---

<SUBAGENT-STOP>
Se você foi disparado como subagente para executar uma task específica, pule esta skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
Se houver ao menos 1% de chance de uma skill se aplicar ao que você está fazendo, você DEVE invocá-la.

Se uma skill se aplica à sua tarefa, o uso NÃO é opcional.
</EXTREMELY-IMPORTANT>

## Prioridade de instruções

As skills SDD sobrepõem o comportamento padrão do modelo, mas **as instruções do usuário sempre têm precedência**:

1. **Instruções explícitas do usuário** (AGENTS.md, CLAUDE.md, GEMINI.md, pedido direto) — prioridade máxima
2. **Skills SDD** — sobrepõem o comportamento padrão onde houver conflito
3. **Prompt de sistema padrão** — prioridade mínima

## O contrato do projeto: `AGENTS.md`

As skills SDD são **genéricas**. Tudo que é específico do projeto (stack, comandos de build/test, integrações, issue tracker, branch base, mapas de código e documentação) vive no **`AGENTS.md` na raiz do repositório**.

- **Sempre** consulte o `AGENTS.md` do projeto antes de assumir comandos, paths ou convenções.
- Se o projeto **não tiver** `AGENTS.md`, avise o dev e sugira rodar `/sdd-init` para análise automática do repositório e geração guiada.
- Onde uma skill disser "gate de qualidade", "issue tracker", "integrações externas" ou "branch base", o valor concreto está no `AGENTS.md`.

## Como acessar skills

- **Claude Code / Copilot CLI:** use a tool `Skill` / `skill`. Ao invocar, o conteúdo é carregado — siga-o diretamente. Não use a tool de leitura de arquivo em SKILL.md.
- **Cursor:** as skills são acionadas por descrição (auto) ou pelos comandos `/sdd-0X`.
- **Codex / Gemini CLI:** skills são descobertas pelo frontmatter `name`/`description` e ativadas sob demanda.
- **Outros ambientes:** consulte a documentação da plataforma sobre carregamento de skills.

## Adaptação entre plataformas

As skills usam nomes de tools do estilo Claude Code / Cursor (`Read`, `Edit`, `Bash`, `Task`, `SwitchMode`...). Em outras plataformas, use o equivalente:

- **Copilot CLI:** `references/copilot-tools.md`
- **Codex:** `references/codex-tools.md`
- **Gemini CLI:** `references/gemini-tools.md`

Se a sua plataforma **não** tiver um recurso citado (ex.: `SwitchMode` para Plan mode, ou subagentes via `Task`), degrade graciosamente: descreva o micro-plano no chat e siga sem o recurso, sem inventar comportamento.

## A regra

**Invoque as skills relevantes ANTES de qualquer resposta ou ação.** Mesmo 1% de chance de aplicar = invoque para checar. Se a skill invocada não servir, você não precisa usá-la.

## Fluxo SDD (visão geral)

```
/sdd-init (bootstrap do projeto) → /sdd-01-new → /sdd-02-research → /sdd-03-specify → /sdd-04-plan → /sdd-05-review (plano)
 → /sdd-06-execute ⇄ /sdd-07-task-review (por task) [TDD opcional, decidido no 01]
 → /sdd-08-spec-review → /sdd-09-docs
```

**Skills transversais** (invocadas dentro das fases, não as substituem): `debugging`, `verification`, `parallel-execution`, `commit-message`.

## Red flags — você está racionalizando

| Pensamento | Realidade |
|---|---|
| "É só uma pergunta simples" | Perguntas são tarefas. Cheque skills. |
| "Preciso de mais contexto antes" | A checagem de skill vem ANTES de perguntar. |
| "Deixa eu explorar o código primeiro" | As skills dizem COMO explorar. Cheque antes. |
| "Isso não precisa de skill formal" | Se existe skill, use. |
| "Eu lembro dessa skill" | Skills evoluem. Leia a versão atual. |

## Tipos de skill

- **Rígidas** (TDD, debugging, verification): siga exatamente; não relaxe a disciplina.
- **Flexíveis** (padrões): adapte os princípios ao contexto.

A própria skill indica qual é.
