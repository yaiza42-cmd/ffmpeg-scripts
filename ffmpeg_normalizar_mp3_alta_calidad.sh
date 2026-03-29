#!/bin/bash

# Carpeta de salida en el mismo directorio del script
SALIDA="$(dirname "$0")/normalizados"

# Verifica si la carpeta ya existe, y si no, la crea
if [[ ! -d "$SALIDA" ]]; then
    mkdir -p "$SALIDA"
    echo "Carpeta \"normalizados\" creada en: $SALIDA"
else
    echo "La carpeta \"normalizados\" ya existe en: $SALIDA"
fi

echo "================================"
echo "NORMALIZANDO ARCHIVOS MP3 A 320kbps"
echo "================================"

# Verifica si ffmpeg está en el PATH
if ! command -v ffmpeg &>/dev/null; then
    echo "FFmpeg no se encuentra en el PATH. Asegúrate de que esté instalado."
    read -p "Presiona ENTER para salir"
    exit 1
fi

# Mostrar el comando FFmpeg que se usará
echo "================================"
echo "COMANDO FFmpeg:"
echo 'ffmpeg -y -i "archivo" -af "loudnorm=I=-12:TP=-1.5:LRA=7, dynaudnorm" -ar 44100 -b:a 320k "salida/archivo_normalizado.mp3"'
echo "================================"

# Procesar cada archivo MP3 en el directorio actual
shopt -s nullglob
for archivo in *.mp3; do
    echo "Procesando archivo: $archivo"
    nombre_base="$(basename "${archivo%.*}")"
    salida_archivo="$SALIDA/${nombre_base}_normalizado.mp3"

    ffmpeg -y -i "$archivo" -af "loudnorm=I=-12:TP=-1.5:LRA=7, dynaudnorm" -ar 44100 -b:a 320k "$salida_archivo"
    echo "Guardado: $salida_archivo"
    echo "--------------------------------"
done

echo "Proceso completado."
