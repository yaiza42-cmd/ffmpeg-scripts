@echo off
setlocal enabledelayedexpansion

set "SALIDA=%~dp0\voces_mejoradas"

if not exist "%SALIDA%" (
    mkdir "%SALIDA%"
    echo 📁 Carpeta "voces_mejoradas" creada en: %SALIDA%
) else (
    echo 📁 La carpeta "voces_mejoradas" ya existe en: %SALIDA%
)

echo =========================================
echo 🎙️  MEJORANDO CALIDAD VOCAL DE ARCHIVOS MP3
echo =========================================

set "FILTRO=deesser, equalizer=f=1500:t=q:w=1:g=3, compand=attacks=0.3:decays=0.8:points=-80/-80|-20/-6|-10/-3|-5/-2|0/-2, loudnorm=I=-14:TP=-1.5:LRA=11, dynaudnorm, bass=g=5, volume=3dB"

echo ================================
echo 🛠️  COMANDO FFmpeg que se utilizará:
echo ffmpeg -y -i "archivo" -af "%FILTRO%" -ar 44100 -b:a 320k "salida\archivo_mejorado.mp3"
echo ================================

set "contador=0"

for %%A in (*.mp3) do (
    set "nombre_base=%%~nA"
    set "salida_archivo=%SALIDA%\%%~nA_mejorado.mp3"

    if exist "!salida_archivo!" (
        echo ⏭️  Ya existe, se omite: !salida_archivo!
        continue
    )

    echo 🎧 Procesando: %%A
    ffmpeg -y -i "%%A" -af "!FILTRO!" -ar 44100 -b:a 320k "!salida_archivo!"
    
    if %errorlevel% equ 0 (
        echo ✅ Guardado: !salida_archivo!
        set /a contador+=1
    ) else (
        echo ❌ Error al procesar: %%A
    )
    echo --------------------------------
)

echo ✅ Proceso completado. Total de archivos procesados: %contador%
pause
endlocal
