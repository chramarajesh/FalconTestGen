# FlowGen Setup Script
# This script sets up everything needed to run FlowGen

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "║                  FlowGen Setup Script                      ║" -ForegroundColor Cyan
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"
$projectRoot = $PSScriptRoot

# Function to print step headers
function Write-Step {
    param([string]$message)
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
    Write-Host "  $message" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
    Write-Host ""
}

# Function to print success messages
function Write-Success {
    param([string]$message)
    Write-Host "✅ $message" -ForegroundColor Green
}

# Function to print error messages
function Write-Error-Custom {
    param([string]$message)
    Write-Host "❌ $message" -ForegroundColor Red
}

# Function to print info messages
function Write-Info {
    param([string]$message)
    Write-Host "ℹ️  $message" -ForegroundColor Cyan
}

# Function to print warning messages
function Write-Warning-Custom {
    param([string]$message)
    Write-Host "⚠️  $message" -ForegroundColor Yellow
}

# Function to check if a command exists
function Test-Command {
    param([string]$command)
    $null = Get-Command $command -ErrorAction SilentlyContinue
    return $?
}

try {
    # Step 1: Check Prerequisites
    Write-Step "Step 1: Checking Prerequisites"
    
    # Check Node.js
    Write-Info "Checking Node.js installation..."
    if (Test-Command "node") {
        $nodeVersion = node --version
        Write-Success "Node.js is installed: $nodeVersion"
        
        # Check if version is >= 18
        $versionNumber = [int]($nodeVersion -replace 'v(\d+)\..*', '$1')
        if ($versionNumber -lt 18) {
            Write-Warning-Custom "Node.js version 18 or higher is recommended. Current: $nodeVersion"
            Write-Info "Download from: https://nodejs.org/"
        }
    } else {
        Write-Error-Custom "Node.js is not installed!"
        Write-Info "Please install Node.js 18+ from: https://nodejs.org/"
        Write-Info "After installation, run this script again."
        exit 1
    }
    
    # Check npm
    Write-Info "Checking npm installation..."
    if (Test-Command "npm") {
        $npmVersion = npm --version
        Write-Success "npm is installed: v$npmVersion"
    } else {
        Write-Error-Custom "npm is not installed!"
        exit 1
    }
    
    # Step 2: Install Root Dependencies
    Write-Step "Step 2: Installing Root Dependencies"
    
    Write-Info "Installing root package dependencies..."
    Set-Location $projectRoot
    npm install
    Write-Success "Root dependencies installed"
    
    # Step 3: Install Server Dependencies
    Write-Step "Step 3: Installing Server Dependencies"
    
    Write-Info "Installing server dependencies..."
    Set-Location "$projectRoot\server"
    npm install
    Write-Success "Server dependencies installed"
    
    # Step 4: Install Playwright Browsers
    Write-Step "Step 4: Installing Playwright Browsers"
    
    Write-Info "Installing Chromium browser for Playwright..."
    Write-Info "This may take a few minutes (downloading ~150MB)..."
    npx playwright install chromium
    Write-Success "Playwright Chromium browser installed"
    
    # Verify Playwright installation
    Write-Info "Verifying Playwright installation..."
    $playwrightTest = node -e "const { chromium } = require('playwright'); chromium.launch().then(b => { console.log('OK'); b.close(); }).catch(e => { console.error('FAIL'); process.exit(1); });"
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Playwright is working correctly"
    } else {
        Write-Error-Custom "Playwright verification failed"
        exit 1
    }
    
    # Step 5: Install Client Dependencies
    Write-Step "Step 5: Installing Client Dependencies"
    
    Write-Info "Installing client dependencies..."
    Set-Location "$projectRoot\client"
    npm install
    Write-Success "Client dependencies installed"
    
    # Step 6: Setup Environment Variables
    Write-Step "Step 6: Setting Up Environment Variables"
    
    $envPath = "$projectRoot\server\.env"
    if (Test-Path $envPath) {
        Write-Success "Environment file already exists: server\.env"
        Write-Info "Checking environment variables..."
        
        $envContent = Get-Content $envPath -Raw
        
        # Check for required variables
        $missingVars = @()
        
        if ($envContent -notmatch "GOOGLE_GENAI_API_KEY=") {
            $missingVars += "GOOGLE_GENAI_API_KEY"
        }
        if ($envContent -notmatch "FIREBASE_PROJECT_ID=") {
            $missingVars += "FIREBASE_PROJECT_ID"
        }
        if ($envContent -notmatch "FIREBASE_PRIVATE_KEY=") {
            $missingVars += "FIREBASE_PRIVATE_KEY"
        }
        if ($envContent -notmatch "FIREBASE_CLIENT_EMAIL=") {
            $missingVars += "FIREBASE_CLIENT_EMAIL"
        }
        
        if ($missingVars.Count -gt 0) {
            Write-Warning-Custom "Some environment variables are missing or empty:"
            foreach ($var in $missingVars) {
                Write-Host "   - $var" -ForegroundColor Yellow
            }
            Write-Info "Please update server\.env with your credentials"
        } else {
            Write-Success "All required environment variables are present"
        }
    } else {
        Write-Info "Creating environment file..."
        
        $envTemplate = @"
# Google Gemini AI Configuration
GOOGLE_GENAI_API_KEY=your_google_genai_api_key_here

# Firebase Configuration
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_PRIVATE_KEY=your_firebase_private_key
FIREBASE_CLIENT_EMAIL=your_firebase_client_email

# Server Configuration
PORT=5000
NODE_ENV=development
"@
        
        Set-Content -Path $envPath -Value $envTemplate
        Write-Success "Environment file created: server\.env"
        Write-Warning-Custom "Please update server\.env with your actual credentials:"
        Write-Host "   - GOOGLE_GENAI_API_KEY (Get from: https://makersuite.google.com/app/apikey)" -ForegroundColor Yellow
        Write-Host "   - FIREBASE_PROJECT_ID" -ForegroundColor Yellow
        Write-Host "   - FIREBASE_PRIVATE_KEY" -ForegroundColor Yellow
        Write-Host "   - FIREBASE_CLIENT_EMAIL" -ForegroundColor Yellow
    }
    
    # Step 7: Verify Installation
    Write-Step "Step 7: Verifying Installation"
    
    Write-Info "Checking installed packages..."
    
    # Check server packages
    Set-Location "$projectRoot\server"
    $serverPackages = @("express", "playwright", "@google/generative-ai", "firebase-admin", "ws", "dotenv")
    foreach ($package in $serverPackages) {
        $installed = npm list $package --depth=0 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$package is installed"
        } else {
            Write-Warning-Custom "$package might not be installed correctly"
        }
    }
    
    # Check client packages
    Set-Location "$projectRoot\client"
    $clientPackages = @("react", "react-dom", "vite")
    foreach ($package in $clientPackages) {
        $installed = npm list $package --depth=0 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$package is installed"
        } else {
            Write-Warning-Custom "$package might not be installed correctly"
        }
    }
    
    # Step 8: Create Quick Start Scripts
    Write-Step "Step 8: Creating Quick Start Scripts"
    
    # Create start script
    $startScript = @"
# FlowGen Start Script
Write-Host "Starting FlowGen..." -ForegroundColor Cyan
Set-Location "$projectRoot"
npm run dev
"@
    Set-Content -Path "$projectRoot\start.ps1" -Value $startScript
    Write-Success "Created start.ps1"
    
    # Create restart script
    $restartScript = @"
# FlowGen Restart Script
Write-Host "Restarting FlowGen..." -ForegroundColor Cyan
Set-Location "$projectRoot"
npm run restart
"@
    Set-Content -Path "$projectRoot\restart.ps1" -Value $restartScript
    Write-Success "Created restart.ps1"
    
    # Create test script
    $testScript = @"
# FlowGen Test Script
Write-Host "Testing FlowGen AI Integration..." -ForegroundColor Cyan
Set-Location "$projectRoot\server"
node test-ai.js
"@
    Set-Content -Path "$projectRoot\test-ai.ps1" -Value $testScript
    Write-Success "Created test-ai.ps1"
    
    # Final Summary
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                                                            ║" -ForegroundColor Green
    Write-Host "║              ✅ Setup Completed Successfully!              ║" -ForegroundColor Green
    Write-Host "║                                                            ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "📋 Next Steps:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Configure Environment Variables:" -ForegroundColor White
    Write-Host "   Edit: server\.env" -ForegroundColor Gray
    Write-Host "   Add your Google Gemini API key and Firebase credentials" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Test AI Integration (Optional):" -ForegroundColor White
    Write-Host "   .\test-ai.ps1" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Start the Application:" -ForegroundColor White
    Write-Host "   .\start.ps1" -ForegroundColor Gray
    Write-Host "   OR" -ForegroundColor Gray
    Write-Host "   npm run dev" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. Access the Application:" -ForegroundColor White
    Write-Host "   Client:  http://localhost:3000" -ForegroundColor Gray
    Write-Host "   Server:  http://localhost:5000" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📚 Documentation:" -ForegroundColor Cyan
    Write-Host "   - README.md" -ForegroundColor Gray
    Write-Host "   - AI_INTEGRATION_SUMMARY.md" -ForegroundColor Gray
    Write-Host "   - AI_QUICK_REFERENCE.md" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🆘 Need Help?" -ForegroundColor Cyan
    Write-Host "   Check the documentation or run: npm run restart" -ForegroundColor Gray
    Write-Host ""
    
    Set-Location $projectRoot
    
} catch {
    Write-Host ""
    Write-Error-Custom "Setup failed: $_"
    Write-Host ""
    Write-Info "Please check the error message above and try again."
    Write-Info "If the problem persists, check the documentation or seek help."
    Write-Host ""
    exit 1
}