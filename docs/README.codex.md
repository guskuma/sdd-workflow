# SDD para o Codex

Guia rápido de instalação e uso com o OpenAI Codex.

## Instalação

Veja o passo a passo em [`../.codex/INSTALL.md`](../.codex/INSTALL.md). Resumo:

```bash
git clone https://github.com/guskuma/sdd-workflow.git ~/.codex/sdd-workflow
mkdir -p ~/.agents/skills
ln -s ~/.codex/sdd-workflow/skills ~/.agents/skills/sdd-workflow
```

Reinicie o Codex.

## Uso

- Não há slash commands no Codex. Invoque as skills pelo nome (ex.: "use a skill sdd-01-new").
- Para `parallel-execution` e o subagente `code-reviewer`, habilite `multi_agent = true` no config.
- Mapeamento de tools: [`../skills/using-sdd/references/codex-tools.md`](../skills/using-sdd/references/codex-tools.md).
