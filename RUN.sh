#!/bin/bash
sleep 3
clear

# ================== CORES ==================
GREEN="\e[1;32m"
RED="\e[1;31m"
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
echo -e "║            Compatível V40 / V41  /V42  /V43                  ║"
echo -e "╚════════════════════════════════════════════════════╝${RESET}"
echo

# ================== PACOTES + SHA256 ==================
declare -A PACKAGES=(
  ["ge-custom"]=""
  ["GE-Proton7-54"]="66baa96da9a468d16d51e047ec55c166ebb3d374235810cbe0cb5b7d29d7ecad"
  ["GE-Proton8-2"]="4489500ba32f7aa0f034ee4b940ef3c5e5775c5a85b3421697c90b2c744a3cda"
  ["GE-Proton8-5"]="7dcc28026b8142b9400e0d3b628bf55278a15fde364e0177355152072c3b7dfb"
  ["GE-Proton9-5"]="10c4861c65190944d969c7cabb4c70c49b41d73b53fb9430d6d545351bed3e8f5"
  ["GE-Proton9-14"]="38951bfc41bfe20578c9cf3189440b729135a63fc1a7b89baed5a3d2b1b2021e"
  ["Proton-GE-Proton7-42"]=""
  ["wine-9.17-amd64"]=""
  ["wine-9.22-staging-tkg"]="76b9f985af42f3f6acba6a738de34283c8884fe670bf300e482e03dbb4c595eb"
  ["wine-10.0-rc4-staging-tkg"]="2f1f88157ac8982ca16babd85b474797e24df7dee3075e2527be51f62adebe95"
  ["wine-proton-9.0-1"]="3693a14bd94d24291c33386fc8fb5d13c0b9f09a13bb937ed4b8a373a0616043"
  ["wine-proton-9.0-2"]="81dd2f98fd56aeec150cbc31a1bd435497b4e2cd4415cc646fd3bf136970deb4"
  ["wine-proton-9.0-3"]="537f9d06926d332cc725ba4d2bfe880ae86b80f009ed16956c05f6f3f1bdfafe"
  ["wine-proton-exp-9.0"]="0ff0f2ccd0e6d1b0fbcb6436f8a9797956b62405ec20e93c6e3253da1311e5ab"
)

# ================== FUNÇÕES ==================
install_package() {
  local PACK="$1"
  local SHA="${PACKAGES[$PACK]}"

  echo -ne "${WHITE}Baixando ${BOLD_ORANGE}${PACK}${RESET} ... "
  wget -q "$REPO_URL/$PACK"

  if [[ ! -f "$PACK" ]]; then
    echo -e "${RED}ERRO${RESET}"
    return
  fi

  if [[ -n "$SHA" ]]; then
    CALC_SHA=$(sha256sum "$PACK" | awk '{print $1}')
    if [[ "$CALC_SHA" != "$SHA" ]]; then
      echo -e "${RED}SHA256 INVÁLIDO${RESET}"
      rm -f "$PACK"
      return
    fi
  fi

  echo -e "${GREEN}OK${RESET}"
  echo -ne "${WHITE}Extraindo... ${RESET}"

  unsquashfs -d "$DEST_DIR/$PACK" "$PACK" > /dev/null 2>&1
  rm -f "$PACK"

  echo -e "${GREEN}INSTALADO!${RESET}"
}

install_all() {
  for PACK in "${!PACKAGES[@]}"; do
    echo
    install_package "$PACK"
  done
}

# ================== MENU PRINCIPAL ==================
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
      OPTIONS=("${!PACKAGES[@]}" "VOLTAR")
      select PACK in "${OPTIONS[@]}"; do
        [[ "$PACK" == "VOLTAR" ]] && break
        [[ -n "$PACK" ]] && install_package "$PACK"
        break
      done
      ;;
    2)
      echo
      echo -e "${BOLD_ORANGE}Instalando TODOS os pacotes...${RESET}"
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

# ================== FINAL ==================
echo
echo -e "${GREEN}Processo finalizado.${RESET}"
echo -e "${BOLD_ORANGE}══════════════════════════════════════════════════════"
echo -e "   By @JCGAMESCLASSICOS - Batocera Wine Pack          "
echo -e "══════════════════════════════════════════════════════${RESET}"
