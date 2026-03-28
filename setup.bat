@echo off
REM ============================================================
REM Market Risk AI Tool - Windows Setup Script
REM ============================================================
echo.
echo ============================================================
echo   Market Risk AI Tool - Setup
echo ============================================================
echo.

REM Step 1: Check Python
echo [1/5] Checking Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH.
    echo Please install Python 3.10+ from python.org
    pause
    exit /b 1
)
python --version
echo.

REM Step 2: Check Ollama
echo [2/5] Checking Ollama...
ollama --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Ollama is not installed or not in PATH.
    echo Please install Ollama from ollama.com
    pause
    exit /b 1
)
ollama --version
echo.

REM Step 3: Create virtual environment
echo [3/5] Creating Python virtual environment...
if not exist .venv (
    python -m venv .venv
    echo Created .venv
) else (
    echo .venv already exists, skipping
)
echo.

REM Step 4: Install dependencies
echo [4/5] Installing Python dependencies...
call .venv\Scripts\activate.bat
pip install -r requirements.txt
echo.

REM Step 5: Pull Qwen model
echo [5/5] Pulling Qwen 2.5 7B model from Ollama registry...
echo (This downloads ~4.4GB - may take a while)
ollama pull qwen2.5:7b
echo.

echo ============================================================
echo   Setup complete!
echo ============================================================
echo.
echo   To start the agent:
echo     1. Make sure SAJHA MCP Server is running on port 3002
echo     2. Run:  start.bat
echo.
pause
