@echo off
echo.
echo ============================================================
echo   Market Risk AI Tool - llama.cpp Mode
echo ============================================================
echo.
echo   STEP 1: Starting llama-server on port 8080...
echo   STEP 2: Starting chatbot on port 8000...
echo.
echo   Make sure you have assembled the model first (assemble.bat)
echo   Make sure SAJHA MCP Server is running on port 3002
echo.

REM Check model exists
if not exist "models\Qwen2.5-7B-Instruct-Q4_K_M.gguf" (
    echo ERROR: Model file not found! Run assemble.bat first.
    pause
    exit /b 1
)

REM Start llama-server in background
echo Starting llama-server...
start "llama-server" llama-server.exe -m models\Qwen2.5-7B-Instruct-Q4_K_M.gguf -c 4096 -ngl 99 --port 8080

echo Waiting 10 seconds for llama-server to load model...
timeout /t 10 /nobreak >nul

REM Start the agent
echo Starting Market Risk AI Tool...
set LLM_BACKEND=llamacpp
call .venv\Scripts\activate.bat
python -m uvicorn agent.server:app --host 0.0.0.0 --port 8000

echo.
echo ============================================================
echo   Server stopped. If it crashed, the error is shown above.
echo ============================================================
pause
