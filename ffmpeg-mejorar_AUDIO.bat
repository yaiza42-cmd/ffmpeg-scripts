@echo off
setlocal enabledelayedexpansion

set "SALIDA=audio_mejorado"
if not exist "%SALIDA%" (
    mkdir "%SALIDA%"
    echo Carpeta creada: %SALIDA%
)

echo Normalizando y mejorando archivos de audio...
echo.

:: FILTROS EXPLICADOS:
:: highpass=f=40 -> Protege los graves (el "cuerpo").
:: lowpass=f=18000 -> Deja pasar más brillo que el anterior.
:: acompressor -> Ajustado para ser más sutil (-16dB).
:: loudnorm -> Al final para asegurar el volumen estándar.

for %%A in (*.mp3 *.m4a) do (
    echo Procesando: %%A
    ffmpeg -y -i "%%A" ^
        -af "highpass=f=40,lowpass=f=18000,acompressor=threshold=-16dB:ratio=2:attack=20:release=200,loudnorm=I=-13:TP=-1.5:LRA=8" ^
        -ar 44100 -b:a 320k -c:a libmp3lame ^
        "%SALIDA%\%%~nA_mejorado.mp3"
)

echo.
echo ✅ Proceso completado. Audios mejorados en la carpeta "%SALIDA%".
pause
endlocal
