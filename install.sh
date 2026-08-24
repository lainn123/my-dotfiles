#!/usr/bin/env bash

# Cancela a execução se ocorrer qualquer erro
set -e

CONFIG_DIR="$HOME/.config"

echo "==> Criando diretório de configuração se não existir..."
mkdir -p "$CONFIG_DIR"

echo "==> Instalando programas e pacotes necessários..."
# Altere 'pacman -S --needed' se estiver usando outra distro/gerenciador
sudo pacman -S --needed --noconfirm \
    btop \
    fish \
    foot \
    hyprland \
    micro \
    starship \
    python-pywal \
    waybar \
    rofi \
    rust

echo "==> Copiando diretórios de configuração para $CONFIG_DIR..."
# Copia as pastas visíveis na imagem para o ~/.config
cp -rf btop "$CONFIG_DIR/"
cp -rf fish "$CONFIG_DIR/"
cp -rf foot "$CONFIG_DIR/"
cp -rf hypr "$CONFIG_DIR/"
cp -rf micro "$CONFIG_DIR/"
cp -rf starship "$CONFIG_DIR/"
cp -rf waybar "$CONFIG_DIR/"

# Trata a pasta do wal/templates
if [ -d "wal" ]; then
    mkdir -p "$CONFIG_DIR/wal"
    cp -rf wal/* "$CONFIG_DIR/wal/"
fi

# Copia arquivos avulsos de configuração
echo "==> Copiando arquivos individuais..."
if [ -f "config.rasi" ]; then
    mkdir -p "$CONFIG_DIR/rofi"
    cp -f config.rasi "$CONFIG_DIR/rofi/"
fi

echo "==> Instalação concluída com sucesso!"
