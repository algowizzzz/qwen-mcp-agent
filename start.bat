@echo off
echo.
echo ============================================================
echo   Market Risk AI Tool - Starting...
echo ============================================================
echo.
echo   Open your browser at: http://localhost:8000
echo   Press Ctrl+C to stop.
echo.
call .venv\Scripts\activate.bat
python -m uvicorn agent.server:app --host 0.0.0.0 --port 8000
echo.
echo ============================================================
echo   Server stopped. If it crashed, the error is shown above.
echo ============================================================
pause
