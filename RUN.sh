#!/bin/bash
# install-wine.sh
# Script para instalar o instalador wine-install no Batocera

INSTALL_PATH="/usr/bin/wine-install"

echo -e "\n${BOLD_ORANGE}Instalando Wine Installer no sistema...${RESET}"

cat << 'EOF' > "$INSTALL_PATH"
#!/bin/bash
sleep 2
clear

# ================== CORES ==================
GREEN="\e[1;32m"
RED="\e[1;31m"
YELLOW="\e[1;33m"
RESET="\e[0m"
BOLD_GREEN="\e[1;32m"
BOLD_ORANGE="\e[1;38;5;208m"
WHITE="\e[1;37m"

# ================== DIRETÓRIOS ==================
BASE_DIR="/userdata/system/wine"
DEST_DIR="$BASE_DIR/custom"
REPO_URL="https://github.com/JeversonDiasSilva/wine/releases/download/1.0"

mkdir -p "$DEST_DIR"
cd "$BASE_DIR" || exit 1

# ================== HEADER ==================
echo -e "${BOLD_GREEN}╔════════════════════════════════════════════════════╗"
echo -e "║     INSTALAÇÃO WINE / PROTON / GE - BATOCERA       ║"
echo -e "║        Compatível V40 / V41 / V42 / V43            ║"
echo -e "╚════════════════════════════════════════════════════╝${RESET}"
echo

# ================== PACOTES ==================
PACKAGES=(
  ge-custom
  GE-Proton7-54
  GE-Proton8-2
  GE-Proton8-5
  GE-Proton9-5
  GE-Proton9-14
  Proton-GE-Proton7-42
  wine-9.17-amd64
  wine-9.22-staging-tkg
  wine-10.0-rc4-staging-tkg
  wine-proton-9.0-1
  wine-proton-9.0-2
  wine-proton-9.0-3
  wine-proton-exp-9.0
)

is_installed() {
  [[ -d "$DEST_DIR/$1" ]]
}

install_package() {
  local PKG="$1"
  local URL="$REPO_URL/$PKG"

  if is_installed "$PKG"; then
    echo -e "${YELLOW}✔ $PKG já instalado — pulando${RESET}"
    return
  fi

  echo
  echo -e "${BOLD_ORANGE}Baixando:${RESET} $PKG"

  wget -q \
    --show-progress \
    --progress=bar:force:noscroll \
    -O "$PKG" \
    "$URL"

  if [[ ! -f "$PKG" ]]; then
    echo -e "${RED}Erro no download${RESET}"
    return
  fi

  echo -e "${WHITE}Extraindo...${RESET}"
  unsquashfs -d "$DEST_DIR/$PKG" "$PKG" > /dev/null 2>&1
  rm -f "$PKG"

  echo -e "${BOLD_GREEN}✔ Instalado com sucesso!${RESET}"
}

install_all() {
  for PKG in "${PACKAGES[@]}"; do
    install_package "$PKG"
  done
}

# ================== MENU ==================
while true; do
  echo
  echo -e "${BOLD_ORANGE}1)${RESET} Instalar UM pacote"
  echo -e "${BOLD_ORANGE}2)${RESET} Instalar TODOS os pacotes"
  echo -e "${BOLD_ORANGE}3)${RESET} Sair"
  echo
  read -rp "Escolha uma opção: " opt

  case "$opt" in
    1)
      echo
      OPTIONS=("${PACKAGES[@]}" "VOLTAR")
      select PKG in "${OPTIONS[@]}"; do
        [[ "$PKG" == "VOLTAR" ]] && break
        [[ -n "$PKG" ]] && install_package "$PKG"
        break
      done
      ;;
    2)
      install_all
      ;;
    3)
      break
      ;;
    *)
      echo -e "${RED}Opção inválida!${RESET}"
      ;;
  esac
done

echo
echo -e "${GREEN}Processo finalizado.${RESET}"
echo -e "${BOLD_ORANGE}══════════════════════════════════════════════════════"
echo -e "   By @JCGAMESCLASSICOS - Batocera Wine Pack          "
echo -e "══════════════════════════════════════════════════════${RESET}"

EOF

chmod +x "$INSTALL_PATH"

echo
echo -e "${BOLD_ORANGE}Salvando overlay do Batocera...${RESET}"
batocera-save-overlay

echo
echo -e "${GREEN}✅ INSTALAÇÃO CONCLUÍDA!${RESET}"
echo -e "${BOLD_ORANGE}Agora execute o comando:${RESET}"
echo
echo "    wine-install"
echo
