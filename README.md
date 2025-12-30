# Dotfiles

Meus dotfiles do Omarchy gerenciados com [chezmoi](https://chezmoi.io/).

## 📦 Conteúdo

- **Hyprland**: Configurações do window manager (keybindings, monitors, input)
- **Waybar**: Configuração da barra de status
- **Ghostty**: Configuração do terminal
- **Neovim/LazyVim**: Configurações do editor
- **Walker**: Configuração do app launcher
- **ZSH**: Configurações do shell
- **UWSM**: Defaults do sistema
- **~/.bashrc**: Aliases e funções customizadas
- **~/.XCompose**: Definições de emoji

## 🚀 Instalação em Nova Máquina

### Pré-requisitos

```bash
# Arch/Omarchy
sudo pacman -S chezmoi git

# Ou use o instalador direto do chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### Setup Completo

```bash
# Clone e aplique todos os dotfiles
chezmoi init --apply levyvix

# Ou clone sem aplicar (para revisar primeiro)
chezmoi init levyvix
chezmoi diff  # Ver mudanças
chezmoi apply # Aplicar quando estiver pronto
```

## 📝 Uso Diário

### Adicionar Novo Arquivo

```bash
# Adicionar arquivo ao chezmoi
chezmoi add ~/.config/novo-app/config.toml

# Ou editar diretamente (chezmoi abre no editor e adiciona automaticamente)
chezmoi edit ~/.config/novo-app/config.toml
```

### Atualizar Dotfiles Existentes

```bash
# Opção 1: Editar via chezmoi (recomendado)
chezmoi edit ~/.config/hypr/hyprland.conf

# Opção 2: Editar arquivo diretamente e re-adicionar
vim ~/.config/hypr/hyprland.conf
chezmoi re-add ~/.config/hypr/hyprland.conf
```

### Sincronizar Mudanças

```bash
# Ver o que mudou
chezmoi diff

# Commit e push para GitHub
chezmoi cd
git add .
git commit -m "Update configs"
git push
exit  # Volta para diretório anterior
```

### Puxar Mudanças de Outra Máquina

```bash
# Atualizar do GitHub e aplicar
chezmoi update

# Ou passo a passo:
chezmoi git pull
chezmoi diff  # Revisar mudanças
chezmoi apply # Aplicar
```

### Aplicar Dotfiles Específicos

```bash
# Aplicar apenas um arquivo
chezmoi apply ~/.config/hypr/hyprland.conf

# Aplicar apenas um diretório
chezmoi apply ~/.config/waybar

# Ver o que seria aplicado sem aplicar
chezmoi apply --dry-run
```

## 🔍 Comandos Úteis

```bash
# Ver status (arquivos modificados mas não commitados)
chezmoi status

# Ver diferença entre repo e sistema
chezmoi diff

# Abrir diretório source do chezmoi
chezmoi cd

# Ver onde chezmoi guarda os arquivos
chezmoi source-path

# Remover arquivo do chezmoi
chezmoi forget ~/.config/app/config
```

## 🎯 Workflow Recomendado

### Ao Modificar Configs

1. Edite via `chezmoi edit` ou edite diretamente e use `chezmoi re-add`
2. Verifique: `chezmoi diff`
3. Commit: `chezmoi cd && git commit -am "message" && git push`

### Em Nova Máquina

1. Instale chezmoi: `sudo pacman -S chezmoi`
2. Clone configs: `chezmoi init levyvix`
3. Revise: `chezmoi diff`
4. Aplique: `chezmoi apply`

### Sincronizar Entre Máquinas

1. Máquina A: `chezmoi cd && git push`
2. Máquina B: `chezmoi update` (pull + apply automático)

## 🔐 Secrets (Opcional)

Para arquivos com senhas/tokens, chezmoi suporta encriptação:

```bash
# Adicionar arquivo privado (será encriptado)
chezmoi add --encrypt ~/.config/app/secrets.yaml

# Editar arquivo encriptado
chezmoi edit ~/.config/app/secrets.yaml
```

Requer configuração de age ou gpg - veja: https://chezmoi.io/user-guide/encryption/

## 📚 Links Úteis

- [Chezmoi Docs](https://chezmoi.io/)
- [Omarchy Manual](https://learn.omacom.io/2/the-omarchy-manual)
- [Repositório](https://github.com/levyvix/dotfiles)

## 🛠️ Manutenção

```bash
# Atualizar chezmoi
sudo pacman -S chezmoi

# Backup antes de mudanças grandes
chezmoi cd && git tag backup-$(date +%Y%m%d)
```
