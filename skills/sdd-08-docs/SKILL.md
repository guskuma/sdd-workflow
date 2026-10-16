---
name: sdd-08-docs
description: >-
  Fase Docs do SDD: atualiza a documentação pública e preenche o mr-template.md.
  Grava status documented. Não fecha a spec. Use com /sdd-08-docs após
  /sdd-07-spec-review aprovado (status reviewed).
---

# SDD — Documentação + MR/PR

## Objetivo

Garantir que a documentação pública reflita o que foi entregue na spec e que o `mr-template.md` esteja pronto para o MR/PR.

## Contexto do projeto

Consultar o `AGENTS.md` para: mapa de documentação, issue tracker/MR, ADR, checklist e gates.

## Quando rodar

Após `/sdd-07-spec-review` aprovado (`status: reviewed`, ou `documented` se for reexecução), antes do `finish-branch`. Esta fase não cria `closure.md` e não grava `done`. Em reexecução, não volte o status para `reviewed`.

## Passos — Documentação

1. Ler `spec.md` e `executions.md` — listar entregáveis que impactam API, mensageria ou comportamento público.
2. Varredura nos paths de documentação do projeto (`AGENTS.md` — Mapa de documentação):
   - Arquivos que **precisam** de alteração
   - Arquivos **já corretos**
   - **Lacunas** (comportamento novo sem doc)
3. Para cada gap necessário:
   - Editar o arquivo adequado (mesmo tom e formato dos vizinhos)
   - Atualizar o contrato público (OpenAPI, schema, etc.) se aplicável
4. Registrar em `executions.md` a seção **Documentação**:
   - Arquivos alterados
   - "N/A — sem impacto em doc pública" se aplicável (justificar)
5. Não documentar shadow features (só o que está na spec).

## Passos — MR/PR (`mr-template.md`)

1. Se `mr-template.md` não existir na pasta da spec (spec legada), resolver o template pela cascata de discovery:
   1. Se existir `.gitlab/`, procurar em `.gitlab/merge_request_templates/`.
   2. Senão, se existir `.github/`, procurar em `.github/PULL_REQUEST_TEMPLATE.md` ou `.github/PULL_REQUEST_TEMPLATE/`.
   3. Senão, usar `specs/templates/mr-template.md` (template bundled do plugin).
   4. **Seleção entre múltiplos templates:** tentar deduzir pelo `tipo` da spec (ex.: `feat.md`, `fix.md`, `Default.md`). Se não houver correspondência clara, **perguntar ao dev**.
   5. Copiar o template escolhido para `mr-template.md` na pasta da spec.
2. **Preencher** as seções narrativas a partir de `spec.md` (**Por quê?**, To Be, goals, **restrições**) e `executions.md` (como testar, evidências, gates):
   - **Resumo / Descrição:** resumo do que foi feito e por quê
   - **Issues / Tasks relacionadas:** link da issue + "Closes" se aplicável
   - **Tipo de mudança:** marcar o checkbox correspondente ao `tipo` da spec
   - **Como testar:** passos extraídos dos critérios de aceite e gates
   - **Impactos e riscos:** riscos residuais e como as **restrições** foram respeitadas
   - **Evidências:** gates verdes, testes relevantes, registros de `executions.md`
3. Título do MR/PR conforme convenção de branches em `AGENTS.md`.
4. Checklist do template: marcar **apenas** itens já comprovados.
5. Registrar em `executions.md` → seção **MR**: arquivo preenchido ou "N/A" com justificativa.

## Fechamento na issue (opcional)

1. Perguntar explicitamente ao dev se deseja publicar um comentário final na issue.
2. Se o dev aprovar, publicar via a ferramenta do projeto (`AGENTS.md`) com um resumo curto de:
   - o que foi entregue;
   - decisões relevantes e impacto;
   - como validar;
   - links da spec/MR/ADR (se houver).
3. Registrar em `executions.md`: pergunta, decisão, execução e link/comentário.

## ADR (opcional, quando aplicável)

1. Perguntar explicitamente ao dev se deseja criar um ADR no fechamento.
2. Se o dev aprovar e a decisão for arquitetural relevante, criar o ADR no path de `AGENTS.md`.
3. Referenciar o ADR em `spec.md`, `executions.md` e no comentário final da issue (quando houver).
4. Se não aplicável ou não aprovado, registrar `N/A`/decisão no `executions.md`.

## Regras

- Preferir ajuste cirúrgico nos arquivos existentes vs. arquivo novo, salvo domínio novo.
- Manter o idioma e o padrão de documentação do projeto.
- Se for só mudança interna sem impacto em contrato público: registrar N/A com justificativa.
- Comentário na issue e ADR são opcionais, mas a decisão do dev deve ficar registrada no `executions.md`.

## Feature flag no `AGENTS.md` (opcional)

Se `feature_flag: sim` e o § Feature flags do `AGENTS.md` estiver vazio, placeholder ou `N/A` genérico:

1. Perguntar uma vez: "Deseja que eu grave no `AGENTS.md` o padrão desta flag (mecanismo, nome, default, path)?"
2. Só escrever depois do sim. Se não, o padrão fica na spec e em `tasks.md`.

## Após docs — status e branch

Com documentação e `mr-template.md` prontos:

1. Em `spec.md`: `status: documented`. Deixar `concluido` e `pr` vazios. Não criar `closure.md`. Não editar `specs/implementation-log.md` (legado).
2. Marcar em `executions.md` as seções Documentação e MR/PR.
3. Invocar a skill **`finish-branch`**: gate completo via **`verification`** → menu (merge local / abrir MR/PR / manter / descartar). `done`, `concluido`, `pr` e `closure.md` são dessa skill, e só depois de merge local ou de MR/PR com URL.
4. Não abrir MR/PR nem mergear **sem** passar por `finish-branch`.

Feedback de review no MR depois de aberto → skill **`receiving-review`**.

## Red flags

| Racionalização | Realidade |
|----------------|-----------|
| "Fecho a spec agora para não esquecer o histórico" | `done` e `closure.md` só no `finish-branch`, com merge ou URL |
| "`pr: pending` já registra o fechamento" | `pr` vazio até o `finish-branch`; `pending` não fecha |

## Saída esperada

Documentação alinhada à spec (ou justificativa N/A); `mr-template.md` preenchido; `executions.md` atualizado; `status: documented`; transição para **`finish-branch`**.