#!/bin/bash

# Carpeta de salida en el mismo directorio del script
SALIDA="$(dirname "$0")/voces_mejoradas"

# Crear carpeta si no existe
if [[ ! -d "$SALIDA" ]]; then
    mkdir -p "$SALIDA"
    echo "📁 Carpeta \"voces_mejoradas\" creada en: $SALIDA"
else
    echo "📁 La carpeta \"voces_mejoradas\" ya existe en: $SALIDA"
fi

echo "========================================="
echo "🎙️  MEJORANDO CALIDAD VOCAL DE ARCHIVOS MP3"
echo "========================================="

# Verifica si ffmpeg está disponible
if ! command -v ffmpeg &>/dev/null; then
    echo "❌ FFmpeg no está instalado o no está en el PATH."
    read -p "Presiona ENTER para salir"
    exit 1
fi

# Mostrar filtro utilizado
FILTRO='deesser, equalizer=f=1500:t=q:w=1:g=3, compand=attacks=0.3:decays=0.8:points=-80/-80|-20/-6|-10/-3|-5/-2|0/-2, loudnorm=I=-14:TP=-1.5:LRA=11, dynaudnorm, bass=g=5, volume=3dB'

echo "================================"
echo "🛠️  COMANDO FFmpeg que se utilizará:"
echo "ffmpeg -y -i \"archivo\" -af \"$FILTRO\" -ar 44100 -b:a 320k \"salida/archivo_mejorado.mp3\""
echo "================================"

# Contador de archivos procesados
contador=0

# Procesar archivos MP3 (robusto con espacios en nombres)
shopt -s nullglob
find . -maxdepth 1 -type f -iname "*.mp3" | while IFS= read -r archivo; do
    archivo="${archivo#./}"  # Quitar './' al inicio si existe
    nombre_base="$(basename "${archivo%.*}")"
    salida_archivo="$SALIDA/${nombre_base}_mejorado.mp3"

    if [[ -f "$salida_archivo" ]]; then
        echo "⏭️  Ya existe, se omite: $salida_archivo"
        continue
    fi

    echo "🎧 Procesando: $archivo"
    ffmpeg -y -i "$archivo" -af "$FILTRO" -ar 44100 -b:a 320k "$salida_archivo" < /dev/null

    if [[ $? -eq 0 ]]; then
        echo "✅ Guardado: $salida_archivo"
        ((contador++))
    else
        echo "❌ Error al procesar: $archivo"
    fi
    echo "--------------------------------"
done

echo "✅ Proceso completado. Total de archivos procesados: $contador"
