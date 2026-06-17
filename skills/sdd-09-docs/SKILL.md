---
name: sdd-09-docs
description: >-
  Fase Docs do SDD: atualiza a documentação pública e preenche o mr-template.md ao
  finalizar uma spec. Use com /sdd-09-docs após /sdd-08-spec-review aprovado.
---

# SDD — Documentação + MR/PR

## Objetivo

Garantir que a documentação pública reflita o que foi entregue na spec e que o `mr-template.md` esteja pronto para o MR/PR.

## Contexto do projeto

Consultar o `AGENTS.md` para: mapa de documentação, issue tracker/MR, ADR, checklist e gates.

## Quando rodar

Ao **finalizar a spec** (após `/sdd-08-spec-review` aprovado), antes de `implementation-log.md` e do MR/PR.

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

1. Se `mr-template.md` não existir na pasta da spec (spec legada), copiar o template de MR/PR de `AGENTS.md`.
2. **Preencher** as seções narrativas a partir de `spec.md` (**Por quê?**, To Be, goals, **restrições**) e `executions.md` (como testar, evidências, gates):
   - **Descrição:** resumo do que foi feito e por quê
   - **Issues / Tasks relacionadas:** link da issue + "Closes" se aplicável
   - **Tipo de mudança:** marcar o checkbox correspondente ao `tipo` da spec
   - **Como testar:** passos extraídos dos critérios de aceite e gates
   - **Impactos e riscos:** riscos residuais e como as **restrições** foram respeitadas
   - **Evidências:** gates verdes, testes relevantes, registros de `executions.md`
3. Título do MR/PR conforme `AGENTS.md`.
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

## Saída esperada

Documentação alinhada à spec (ou justificativa N/A); `mr-template.md` preenchido; `executions.md` atualizado. Ao concluir: entrada em `specs/implementation-log.md`, `status: done` em `spec.md`, MR/PR conforme `AGENTS.md`.
