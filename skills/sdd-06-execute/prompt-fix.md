# Prompt — Fix de apontamentos (subagente)

Usar **somente** após o gate **`receiving-review`**, no loop do `/sdd-06-execute`. O dispatch leva **todos** os Aceitos daquela reprovação, num lote. Fora do execute esta regra não vale: a skill `receiving-review` manda um Aceito por vez. Substituir `{...}`.

**Preferir retomada** do **mesmo implementador** da task (ele já leu Onde/Steps/diff). Task novo só se a plataforma não retomar, ou se o implementador tiver retornado `NEEDS_CONTEXT` / `BLOCKED`.

## Modo retomada (padrão)

Enviar só o bloco abaixo ao implementador já em curso:

```
## Fix — retomada (iter {N} de 5)

Corrigir APENAS os apontamentos ACEITOS abaixo. Não expandir escopo.
Não corrigir rejeitados/ambíguos (não listados). Sem commits salvo pedido do dev.

### Apontamentos ACEITOS
{colar somente findings Aceitos — texto integral + motivo do aceito se houver}

### Ao terminar, retornar
1. **Status:** DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
2. **Apontamentos tratados:** item a item (corrigido / não aplicável + por quê)
3. **Arquivos alterados:** paths
4. **Comandos rodados:** comando + exit code + resumo
5. **Pendências:** Aceito crítico não corrigido, se houver
```

## Modo Task novo (fallback)

Pacote integral — copiar e preencher:

```
Você corrige APENAS os apontamentos ACEITOS da task {TN} em {caminho-pasta-spec}.

## Escopo da task
- DoD / Onde / Steps: {resumo ou trecho de tasks.md}
- Não expandir escopo além do necessário para zerar os apontamentos abaixo.

## Apontamentos ACEITOS (já filtrados por receiving-review)
{colar somente findings Aceitos — texto integral + motivo do aceito se houver}

## NÃO corrigir
- Findings rejeitados ou ambíguos do receiving-review (não listados acima)
- Nits ou pedidos novos que não estejam na lista Aceitos

## Iteração
{N} de 5 (informe no retorno)

## Proibido
- Ignorar apontamentos Aceitos críticos
- Refator “de brinde” ou features não pedidas
- Editar arquivos fora de "Onde" (salvo se o apontamento exigir path já no escopo da task)
- Commits (só se o dev pedir explicitamente)
- Shadow code / desvio de spec sem escalar ao orquestrador

## Convenções
- AGENTS.md + restrições da spec §2
- TDD: se a spec tiver tdd: true, manter/ajustar testes conforme o apontamento

## Ao terminar, retornar
1. **Status:** DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
2. **Apontamentos tratados:** lista item a item (corrigido / não aplicável + por quê)
3. **Arquivos alterados:** lista com paths
4. **Comandos rodados:** comando + exit code + resumo
5. **Pendências:** se algum Aceito crítico não pôde ser corrigido
```
