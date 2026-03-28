@echo off
setlocal enabledelayedexpansion

set "SALIDA=%~dp0\voz_anonymous"
mkdir "%SALIDA%" 2>nul
echo 📁 Carpeta de salida: %SALIDA%

echo ====================================
echo 🎭 ANONIMIZANDO VOZ ESTILO ANONYMOUS (CLARA)
echo ====================================


set "FILTRO=asetrate=44100*0.75,atempo=1.33,volume=5dB"
set "contador=0"

for %%A in (*.mp3) do (
    set "nombre_base=%%~nA"
    set "salida_archivo=%SALIDA%\%%~nA_anonymous.mp3"

    if exist "!salida_archivo!" (
        echo ⏭️  Ya existe: !salida_archivo!
        continue
    )

    echo 🔊 Procesando: %%A
    ffmpeg -y -i "%%A" -af "!FILTRO!" -ar 44100 -b:a 128k "!salida_archivo!"
    
    if %errorlevel% equ 0 (
        echo ✅ Guardado: !salida_archivo!
        set /a contador+=1
    ) else (
        echo ❌ Error al procesar: %%A
    )
    echo --------------------------------
)

echo ✅ Proceso completado. Total de archivos convertidos: %contador%
pause
endlocal