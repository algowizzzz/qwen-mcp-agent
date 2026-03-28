@echo off
REM Reassemble the model from chunks (Windows)
REM Usage: assemble.bat

set OUTPUT=models\Qwen2.5-3B-Instruct-Q4_K_M.gguf
set CHUNKS_DIR=models\chunks

if exist "%OUTPUT%" (
    echo Model already assembled at %OUTPUT%
    exit /b 0
)

echo Assembling model from chunks...
copy /b "%CHUNKS_DIR%\model_part_aa"+"%CHUNKS_DIR%\model_part_ab"+"%CHUNKS_DIR%\model_part_ac"+"%CHUNKS_DIR%\model_part_ad"+"%CHUNKS_DIR%\model_part_ae"+"%CHUNKS_DIR%\model_part_af"+"%CHUNKS_DIR%\model_part_ag"+"%CHUNKS_DIR%\model_part_ah"+"%CHUNKS_DIR%\model_part_ai"+"%CHUNKS_DIR%\model_part_aj"+"%CHUNKS_DIR%\model_part_ak"+"%CHUNKS_DIR%\model_part_al"+"%CHUNKS_DIR%\model_part_am"+"%CHUNKS_DIR%\model_part_an"+"%CHUNKS_DIR%\model_part_ao"+"%CHUNKS_DIR%\model_part_ap"+"%CHUNKS_DIR%\model_part_aq"+"%CHUNKS_DIR%\model_part_ar"+"%CHUNKS_DIR%\model_part_as"+"%CHUNKS_DIR%\model_part_at" "%OUTPUT%"

echo Done! Model assembled at %OUTPUT%
echo.
echo To run with Ollama:
echo   ollama create qwen3b -f Modelfile
echo   ollama run qwen3b
