#!/usr/bin/env bash

set -e

echo "=== 1. Instalando Dependências do Sistema ==="
# Atualiza os pacotes e instala dependências base
sudo pacman -Syu --needed --noconfirm \
    git \
    stow \
    hyprland \
    mako \
    python-pywal \
    libnotify \
    gdk-pixbuf2 \
    gtk3

# Se usar AUR (ex: Paru ou Yay) para pacotes adicionais
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm swaybg async-channel
fi

echo "=== 2. Criando Estrutura de Pastas ==="
mkdir -p ~/.config
mkdir -p ~/.cache/wal

echo "=== 3. Aplicando Links Simbólicos com Stow ==="
# O GNU Stow espelha a estrutura da pasta para a sua $HOME
stow -R mako
stow -R hypr
stow -R wal

echo "=== 4. Configurando Links do Pywal ==="
# Garante que o link simbólico do Mako para a cache do Pywal exista
ln -sf ~/.cache/wal/mako ~/.config/mako/config

echo "=== Instalação e Configuração Concluídas! ==="
