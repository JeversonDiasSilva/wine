#!/bin/bash
# Cria os diretórios necessários
mkdir -p /userdata/system/wine/custom

# Vai para o diretório de destino
cd /userdata/system/wine

# Baixa o arquivo SquashFS
wget https://github.com/JeversonDiasSilva/wine/releases/download/1.0/Proton-STREETFIGHTERV

# Extrai o conteúdo do squashfs para a pasta desejada com o nome wine-9.17-amd64
unsquashfs -d ./custom/wine-9.17-amd64 WINE-MARIOKART

rm Proton-STREETFIGHTERV