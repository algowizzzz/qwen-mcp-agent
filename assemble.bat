@echo off
REM Reassemble the model from chunks (Windows)
REM Usage: assemble.bat

set OUTPUT=models\Qwen2.5-7B-Instruct-Q4_K_M.gguf
set CHUNKS_DIR=models\chunks

if exist "%OUTPUT%" (
    echo Model already assembled at %OUTPUT%
    exit /b 0
)

echo Assembling model from chunks...
copy /b "%CHUNKS_DIR%\model_part_aa"+"%CHUNKS_DIR%\model_part_ab"+"%CHUNKS_DIR%\model_part_ac"+"%CHUNKS_DIR%\model_part_ad"+"%CHUNKS_DIR%\model_part_ae"+"%CHUNKS_DIR%\model_part_af"+"%CHUNKS_DIR%\model_part_ag"+"%CHUNKS_DIR%\model_part_ah"+"%CHUNKS_DIR%\model_part_ai"+"%CHUNKS_DIR%\model_part_aj"+"%CHUNKS_DIR%\model_part_ak"+"%CHUNKS_DIR%\model_part_al"+"%CHUNKS_DIR%\model_part_am"+"%CHUNKS_DIR%\model_part_an"+"%CHUNKS_DIR%\model_part_ao"+"%CHUNKS_DIR%\model_part_ap"+"%CHUNKS_DIR%\model_part_aq"+"%CHUNKS_DIR%\model_part_ar"+"%CHUNKS_DIR%\model_part_as"+"%CHUNKS_DIR%\model_part_at"+"%CHUNKS_DIR%\model_part_au"+"%CHUNKS_DIR%\model_part_av"+"%CHUNKS_DIR%\model_part_aw"+"%CHUNKS_DIR%\model_part_ax"+"%CHUNKS_DIR%\model_part_ay"+"%CHUNKS_DIR%\model_part_az"+"%CHUNKS_DIR%\model_part_ba"+"%CHUNKS_DIR%\model_part_bb"+"%CHUNKS_DIR%\model_part_bc"+"%CHUNKS_DIR%\model_part_bd"+"%CHUNKS_DIR%\model_part_be"+"%CHUNKS_DIR%\model_part_bf"+"%CHUNKS_DIR%\model_part_bg"+"%CHUNKS_DIR%\model_part_bh"+"%CHUNKS_DIR%\model_part_bi"+"%CHUNKS_DIR%\model_part_bj"+"%CHUNKS_DIR%\model_part_bk"+"%CHUNKS_DIR%\model_part_bl"+"%CHUNKS_DIR%\model_part_bm"+"%CHUNKS_DIR%\model_part_bn"+"%CHUNKS_DIR%\model_part_bo"+"%CHUNKS_DIR%\model_part_bp"+"%CHUNKS_DIR%\model_part_bq"+"%CHUNKS_DIR%\model_part_br"+"%CHUNKS_DIR%\model_part_bs"+"%CHUNKS_DIR%\model_part_bt"+"%CHUNKS_DIR%\model_part_bu"+"%CHUNKS_DIR%\model_part_bv" "%OUTPUT%"

echo Done! Model assembled at %OUTPUT%
echo.
echo To run with Ollama:
echo   ollama create qwen7b -f Modelfile
echo   ollama run qwen7b
