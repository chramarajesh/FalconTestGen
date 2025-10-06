@echo off
REM FlowGen Setup Script (Batch Version)
REM This script sets up everything needed to run FlowGen

echo.
echo ============================================================
echo                  FlowGen Setup Script
echo ============================================================
echo.

REM Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js is not installed!
    echo Please install Node.js 18+ from: https://nodejs.org/
    echo After installation, run this script again.
    pause
    exit /b 1
)

echo [OK] Node.js is installed
node --version

REM Check if npm is installed
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] npm is not installed!
    pause
    exit /b 1
)

echo [OK] npm is installed
npm --version

echo.
echo ============================================================
echo Step 1: Installing Root Dependencies
echo ============================================================
echo.

call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install root dependencies
    pause
    exit /b 1
)

echo.
echo ============================================================
echo Step 2: Installing Server Dependencies
echo ============================================================
echo.

cd server
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install server dependencies
    pause
    exit /b 1
)

echo.
echo ============================================================
echo Step 3: Installing Playwright Browsers
echo ============================================================
echo.
echo This may take a few minutes (downloading ~150MB)...
echo.

call npx playwright install chromium
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install Playwright browsers
    pause
    exit /b 1
)

echo.
echo [OK] Playwright Chromium browser installed

echo.
echo ============================================================
echo Step 4: Installing Client Dependencies
echo ============================================================
echo.

cd ..\client
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install client dependencies
    pause
    exit /b 1
)

cd ..

echo.
echo ============================================================
echo Step 5: Setting Up Environment Variables
echo ============================================================
echo.

if exist "server\.env" (
    echo [OK] Environment file already exists: server\.env
    echo Please make sure it contains your credentials
) else (
    echo Creating environment file...
    (
        echo # Google Gemini AI Configuration
        echo GOOGLE_GENAI_API_KEY=your_google_genai_api_key_here
        echo.
        echo # Firebase Configuration
        echo FIREBASE_PROJECT_ID=your_firebase_project_id
        echo FIREBASE_PRIVATE_KEY=your_firebase_private_key
        echo FIREBASE_CLIENT_EMAIL=your_firebase_client_email
        echo.
        echo # Server Configuration
        echo PORT=5000
        echo NODE_ENV=development
    ) > server\.env
    echo [OK] Environment file created: server\.env
    echo [WARNING] Please update server\.env with your actual credentials
)

echo.
echo ============================================================
echo              Setup Completed Successfully!
echo ============================================================
echo.
echo Next Steps:
echo.
echo 1. Configure Environment Variables:
echo    Edit: server\.env
echo    Add your Google Gemini API key and Firebase credentials
echo.
echo 2. Start the Application:
echo    npm run dev
echo.
echo 3. Access the Application:
echo    Client:  http://localhost:3000
echo    Server:  http://localhost:5000
echo.
echo Documentation:
echo    - README.md
echo    - AI_INTEGRATION_SUMMARY.md
echo    - AI_QUICK_REFERENCE.md
echo.

pause