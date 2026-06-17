# Instalando o SDD para o OpenCode

## Pré-requisitos

- Git
- OpenCode

## Instalação

1. **Clonar o repositório:**
   ```bash
   git clone https://github.com/guskuma/sdd-workflow.git ~/.config/opencode/sdd-workflow
   ```

2. **Disponibilizar as skills** conforme o mecanismo de plugins/skills do seu OpenCode (ex.: apontar a configuração para `~/.config/opencode/sdd-workflow` ou criar symlink do diretório `skills/`).

3. **Reiniciar o OpenCode.**

## Atualizar

```bash
cd ~/.config/opencode/sdd-workflow && git pull
```

> O `package.json` aponta `main` para `.opencode/plugins/sdd.js`. As skills são descobertas a partir de `skills/`. Comandos `/sdd-0X` podem não existir — invoque as skills pelo nome.
