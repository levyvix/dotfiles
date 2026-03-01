# Dotfiles

Meus dotfiles do Omarchy gerenciados com [yadm](https://yadm.io/).

## 📦 Conteúdo

### Desktop
- **Hyprland**: Window manager (keybindings, monitors, input)
- **Waybar**: Barra de status
- **Mako**: Notificações
- **UWSM**: Defaults do sistema

### Terminal & Shell
- **Ghostty / Alacritty / Kitty**: Terminais
- **ZSH**: Configurações do shell
- **Fish**: Shell alternativo
- **Tmux**: Multiplexer de terminal
- **Starship**: Prompt
- **~/.bashrc**: Aliases e funções customizadas
- **~/.XCompose**: Definições de emoji

### Editores
- **Neovim/LazyVim**: Configurações do editor

### Ferramentas
- **Git**: Gitconfig global e gitignore global
- **Lazygit / Lazydocker**: TUIs de git e docker
- **Yazi**: File manager
- **Btop**: Monitor de recursos
- **Fastfetch**: Info do sistema
- **MPV**: Player de vídeo
- **Zathura**: Leitor de PDF
- **Mise**: Gerenciador de versões
- **Jj**: Alternativa ao git

### Apps & Sistema
- **Walker**: App launcher
- **Mimeapps**: Apps padrão por tipo de arquivo

## ⚡ Workflow Simplificado

### Alias `dots-sync`

O `.zshrc` já inclui um script que faz tudo de uma vez:

```bash
# Edite seus arquivos normalmente
vim ~/.config/hypr/hyprland.conf
vim ~/.config/waybar/config.jsonc
vim ~/.bashrc

# Sincronize TUDO com um comando
dots-sync
```

---

## 🚀 Instalação em Nova Máquina

### Pré-requisitos

```bash
sudo pacman -S yadm git
```

### Setup Completo

```bash
# Clone e aplique todos os dotfiles
yadm clone git@github.com:levyvix/dotfiles.git

# Ou clone sem aplicar (para revisar primeiro)
yadm clone --no-bootstrap git@github.com:levyvix/dotfiles.git
yadm status  # Ver arquivos
```

## 📝 Uso Diário

### Adicionar Novo Arquivo

```bash
yadm add ~/.config/novo-app/config.toml
yadm commit -m "feat: add novo-app config"
yadm push
```

### Atualizar Dotfiles Existentes

```bash
# Edite o arquivo diretamente
vim ~/.config/hypr/hyprland.conf

# Veja o que mudou e commite
yadm diff
yadm add ~/.config/hypr/hyprland.conf
yadm commit -m "chore: update hypr config"
yadm push
```

### Puxar Mudanças de Outra Máquina

```bash
yadm pull
```

## 🔍 Comandos Úteis

```bash
# Ver status (arquivos modificados)
yadm status

# Ver diferença entre repo e sistema
yadm diff

# Listar arquivos gerenciados
yadm list

# Remover arquivo do yadm (sem deletar do disco)
yadm rm --cached ~/.config/app/config
```

## 🎯 Workflow Recomendado

### Ao Modificar Configs

1. Edite o arquivo diretamente
2. Verifique: `yadm diff`
3. Commite: `yadm add <arquivo> && yadm commit -m "message" && yadm push`

### Em Nova Máquina

1. Instale yadm: `sudo pacman -S yadm`
2. Clone configs: `yadm clone git@github.com:levyvix/dotfiles.git`

### Sincronizar Entre Máquinas

1. Máquina A: `yadm push`
2. Máquina B: `yadm pull`

## 📚 Links Úteis

- [yadm Docs](https://yadm.io/)
- [Omarchy Manual](https://learn.omacom.io/2/the-omarchy-manual)
- [Repositório](https://github.com/levyvix/dotfiles)
