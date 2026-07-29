---
name: writing-skills
description: >-
  Escrever ou endurecer skills SDD com disciplina de processo: pressure scenario (baseline
  sem a skill) → redigir a skill → re-testar compliance. Use ao criar/editar skills deste
  plugin ou skills genéricas reutilizáveis — não para convenções de um único projeto.
---

# Escrever skills (meta)

## Objetivo

Tratar documentação de processo como código: **provar** que a skill muda o comportamento do agente sob pressão.

**Iron Law:**

```
NENHUMA SKILL NOVA SEM CENÁRIO DE PRESSÃO QUE FALHOU SEM ELA
```

Se não viu o agente falhar sem a skill, não sabe se a skill ensina a coisa certa.

## Quando invocar

- Criar skill nova em `skills/`
- Endurecer skill existente (Iron Law, red flags, lacunas)
- Revisar skill que o agente “lembra” mas contorna

**Não** criar skill para: one-off, convenção só deste repo (vai no `AGENTS.md`), regra enforceável por CI/linter.

## Tipos

| Tipo | Exemplo neste plugin |
|------|----------------------|
| Técnica (passos rígidos) | `verification`, `debugging`, `tdd` |
| Padrão (postura) | `receiving-review`, disciplina em `using-sdd` |
| Referência | `postgresql-table-design`, `using-sdd/references/*-tools.md` |

## Ciclo (TDD de processo)

1. **Pressure scenario** — situação em que o modelo racionaliza (pressa, “é simples”, bajulação, skip de gate).
2. **Baseline (RED)** — subagente ou sessão **sem** a skill (ou com versão antiga); documentar a violação exata.
3. **Escrever skill (GREEN)** — texto mínimo que fecha **essa** brecha: Iron Law, quando invocar, red flags, integração SDD.
4. **Re-testar** — mesmo cenário **com** a skill; agente deve cumprir.
5. **Refactor** — novas racionalizações → fechar lacunas → re-testar.

## Checklist de qualidade (SKILL.md)

- [ ] Frontmatter `name` + `description` (description dispara auto-invocation — incluir gatilhos)
- [ ] Iron Law quando a disciplina for rígida
- [ ] Quando invocar / quando **não**
- [ ] Integração com fases SDD e `AGENTS.md` (genérico — zero stack hardcodada)
- [ ] Red flags / tabela de racionalização
- [ ] Saída esperada
- [ ] Links relativos a skills irmãs (`verification`, etc.)
- [ ] Português alinhado ao restante do plugin (salvo referências técnicas)

## Estrutura

```
skills/{nome}/
  SKILL.md           # obrigatório
  prompt-*.md        # só se subagente precisar de template
  references/        # só se necessário
```

Skills de fase (`sdd-0X`) vs transversais: transversais **não** substituem fases; fases invocam transversais.

## Após editar

1. Atualizar `using-sdd` (lista de transversais) se skill nova.
2. Pontos de invocação nas fases (06, 08, …).
3. `README.md` + `CHANGELOG.md`.
4. Versão SemVer em **todos** os manifestos (MINOR se capacidade nova).

## Red flags

| Racionalização | Realidade |
|----------------|-----------|
| "Texto claro basta" | Sem pressure test, o agente contorna |
| "Skill específica do projeto X" | Isso é `AGENTS.md` |
| "Vou copiar o Superpowers inteiro" | Adaptar iron laws; manter contrato SDD |
| "Description vaga" | Description fraca = skill nunca dispara |

## Saída esperada

Skill com Iron Law/red flags quando couber; cenário de pressão documentado (chat ou nota no PR); pontos de integração e versão atualizados.
