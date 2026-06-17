# Instalando o SDD para o Codex

O Codex tem descoberta nativa de skills: ele varre `~/.agents/skills/` no startup, lê o frontmatter de cada `SKILL.md` e carrega sob demanda. Basta clonar e criar um symlink.

## Pré-requisitos

- Git
- OpenAI Codex CLI

## Instalação

1. **Clonar o repositório:**
   ```bash
   git clone https://github.com/guskuma/sdd-workflow.git ~/.codex/sdd-workflow
   ```

2. **Criar o symlink das skills:**
   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/sdd-workflow/skills ~/.agents/skills/sdd-workflow
   ```

   **Windows (PowerShell):**
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
   cmd /c mklink /J "$env:USERPROFILE\.agents\skills\sdd-workflow" "$env:USERPROFILE\.codex\sdd-workflow\skills"
   ```

3. **Subagentes (opcional):** as skills `parallel-execution` e o `code-reviewer` dependem do recurso multi-agente. Adicione ao config do Codex:
   ```toml
   [features]
   multi_agent = true
   ```

4. **Reiniciar o Codex.**

## Verificar

```bash
ls -la ~/.agents/skills/sdd-workflow
```

## Atualizar

```bash
cd ~/.codex/sdd-workflow && git pull
```

## Desinstalar

```bash
rm ~/.agents/skills/sdd-workflow
```

Opcional: remover o clone (`rm -rf ~/.codex/sdd-workflow`).

> A descoberta é por `description` no frontmatter. A skill `using-sdd` é descoberta automaticamente e estabelece a disciplina de uso. Comandos `/sdd-0X` não existem no Codex — invoque as skills pelo nome (ex.: "use a skill sdd-01-new").
