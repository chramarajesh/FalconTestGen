# FlowGen Setup Guide

## 🚀 Quick Start (Automated Setup)

### For Windows PowerShell Users

```powershell
# Run the setup script
.\setup.ps1
```

### For Windows Command Prompt Users

```cmd
# Run the setup script
setup.bat
```

The setup script will automatically:
- ✅ Check prerequisites (Node.js, npm)
- ✅ Install all dependencies (root, server, client)
- ✅ Download and install Playwright browsers
- ✅ Create environment configuration file
- ✅ Verify installation
- ✅ Create quick start scripts

---

## 📋 Prerequisites

Before running the setup script, make sure you have:

### Required

- **Node.js 18+** - [Download here](https://nodejs.org/)
- **npm** (comes with Node.js)

### Optional (for full functionality)

- **Google Gemini API Key** - [Get here](https://makersuite.google.com/app/apikey)
- **Firebase Project** - [Create here](https://console.firebase.google.com/)

---

## 🛠️ Manual Setup (If Automated Setup Fails)

### Step 1: Install Root Dependencies

```powershell
npm install
```

### Step 2: Install Server Dependencies

```powershell
cd server
npm install
```

### Step 3: Install Playwright Browsers

```powershell
# Still in server directory
npx playwright install chromium
```

This will download Chromium browser (~150MB). It may take a few minutes.

### Step 4: Install Client Dependencies

```powershell
cd ..\client
npm install
```

### Step 5: Configure Environment Variables

Create a file named `.env` in the `server` directory:

```powershell
cd ..\server
New-Item -ItemType File -Name .env
```

Edit `server/.env` and add:

```env
# Google Gemini AI Configuration
GOOGLE_GENAI_API_KEY=your_google_genai_api_key_here

# Firebase Configuration
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_PRIVATE_KEY=your_firebase_private_key
FIREBASE_CLIENT_EMAIL=your_firebase_client_email

# Server Configuration
PORT=5000
NODE_ENV=development
```

---

## 🔑 Getting API Keys

### Google Gemini API Key

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the API key
5. Paste it in `server/.env` as `GOOGLE_GENAI_API_KEY`

### Firebase Credentials

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing one
3. Go to Project Settings → Service Accounts
4. Click "Generate New Private Key"
5. Download the JSON file
6. Extract the following values and add to `server/.env`:
   - `project_id` → `FIREBASE_PROJECT_ID`
   - `private_key` → `FIREBASE_PRIVATE_KEY`
   - `client_email` → `FIREBASE_CLIENT_EMAIL`

**Note**: For `FIREBASE_PRIVATE_KEY`, make sure to keep the `\n` characters as-is or wrap the entire key in quotes.

---

## ✅ Verify Installation

### Test Playwright Installation

```powershell
cd server
node -e "const { chromium } = require('playwright'); chromium.launch().then(b => { console.log('✅ Chromium installed!'); b.close(); }).catch(e => console.error('❌ Error:', e.message));"
```

Expected output: `✅ Chromium installed!`

### Test AI Integration

```powershell
cd server
node test-ai.js
```

Expected output:
```
✅ AI initialized successfully
✅ Test 1 passed: Click action
✅ Test 2 passed: Fill action
✅ Test 3 passed: Navigate action
✅ Test 4 passed: Select action
```

---

## 🎯 Starting the Application

### Option 1: Using Quick Start Script (After Setup)

```powershell
.\start.ps1
```

### Option 2: Using npm Scripts

```powershell
# Start both server and client
npm run dev

# Or start them separately
npm run server  # Start server only
npm run client  # Start client only
```

### Option 3: Restart Everything

```powershell
# Kill all Node processes and restart
npm run restart

# Or use the quick script
.\restart.ps1
```

---

## 🌐 Accessing the Application

Once started, you can access:

- **Client UI**: http://localhost:3000 (or 3001 if 3000 is in use)
- **Server API**: http://localhost:5000
- **WebSocket**: ws://localhost:5000
- **Health Check**: http://localhost:5000/api/health

---

## 📁 Project Structure

```
FlowGen/
├── client/                 # React frontend
│   ├── src/
│   ├── package.json
│   └── vite.config.js
├── server/                 # Node.js backend
│   ├── config/            # Configuration files
│   ├── models/            # Data models
│   ├── routes/            # API routes
│   ├── services/          # Business logic
│   │   └── aiService.js   # Google Gemini AI integration
│   ├── utils/             # Utilities
│   ├── .env               # Environment variables (create this)
│   ├── index.js           # Server entry point
│   ├── package.json
│   └── test-ai.js         # AI integration test
├── package.json           # Root package.json
├── setup.ps1              # PowerShell setup script
├── setup.bat              # Batch setup script
├── start.ps1              # Quick start script
├── restart.ps1            # Quick restart script
├── test-ai.ps1            # Quick AI test script
├── SETUP_GUIDE.md         # This file
├── README.md              # Main documentation
├── AI_INTEGRATION_SUMMARY.md
├── AI_INTEGRATION_DIAGRAM.md
└── AI_QUICK_REFERENCE.md
```

---

## 🐛 Troubleshooting

### Issue: "Node.js is not installed"

**Solution**: Install Node.js 18+ from https://nodejs.org/

After installation, restart your terminal and run the setup script again.

---

### Issue: "Failed to launch browser, executable doesn't exist"

**Cause**: Playwright browsers are not installed.

**Solution**:
```powershell
cd server
npx playwright install chromium
```

---

### Issue: "EADDRINUSE: address already in use :::5000"

**Cause**: Port 5000 is already in use by another process.

**Solution**:
```powershell
# Kill all Node processes
Get-Process -Name node -ErrorAction SilentlyContinue | Stop-Process -Force

# Or change the port in server/.env
# PORT=5001
```

---

### Issue: "AI not generating descriptions"

**Cause**: Google Gemini API key is missing or invalid.

**Solution**:
1. Check `server/.env` has `GOOGLE_GENAI_API_KEY`
2. Verify the API key is correct
3. Test with: `node server/test-ai.js`

---

### Issue: "Firebase initialization failed"

**Cause**: Firebase credentials are missing or invalid.

**Solution**:
1. Check `server/.env` has all Firebase variables
2. Verify credentials are correct
3. Make sure `FIREBASE_PRIVATE_KEY` is properly formatted

---

### Issue: "npm install fails"

**Cause**: Network issues or corrupted cache.

**Solution**:
```powershell
# Clear npm cache
npm cache clean --force

# Try again
npm install
```

---

### Issue: "Client won't start - port 3000 in use"

**Cause**: Port 3000 is already in use.

**Solution**: Vite will automatically try port 3001, 3002, etc. Check the terminal output for the actual port.

---

## 🔧 Advanced Configuration

### Change Server Port

Edit `server/.env`:
```env
PORT=5001
```

### Change Browser Type

Edit `server/config/playwright.js`:
```javascript
browserType: 'firefox', // or 'webkit'
```

Then install the browser:
```powershell
npx playwright install firefox
```

### Enable Headless Mode

Edit `server/config/playwright.js`:
```javascript
launchOptions: {
  headless: true,  // Change to true
  // ...
}
```

### Adjust AI Model

Edit `server/services/aiService.js`:
```javascript
const model = genAI.getGenerativeModel({ model: 'gemini-pro' });
```

Check available models:
```powershell
node server/list-models.js
```

---

## 📚 Additional Documentation

- **README.md** - Main project documentation
- **AI_INTEGRATION_SUMMARY.md** - Complete AI integration overview
- **AI_INTEGRATION_DIAGRAM.md** - Visual architecture diagrams
- **AI_QUICK_REFERENCE.md** - Quick reference for developers

---

## 🆘 Getting Help

### Check Logs

Server logs will show detailed information about what's happening:
```powershell
npm run server
```

Look for:
- ✅ Success messages (green)
- ❌ Error messages (red)
- ⚠️ Warning messages (yellow)
- ℹ️ Info messages (blue)

### Test Individual Components

```powershell
# Test AI integration
node server/test-ai.js

# Test Playwright
node -e "const { chromium } = require('playwright'); chromium.launch().then(b => b.close());"

# Check server health
curl http://localhost:5000/api/health
```

### Common Commands

```powershell
# Install dependencies
npm install

# Start development
npm run dev

# Restart everything
npm run restart

# Kill all Node processes
Get-Process -Name node | Stop-Process -Force

# Check what's running on a port
netstat -ano | findstr :5000
```

---

## 🎉 Success Checklist

After setup, verify everything is working:

- [ ] Node.js and npm are installed
- [ ] All dependencies are installed (root, server, client)
- [ ] Playwright Chromium browser is installed
- [ ] Environment variables are configured
- [ ] AI test script passes (`node server/test-ai.js`)
- [ ] Server starts without errors (`npm run server`)
- [ ] Client starts without errors (`npm run client`)
- [ ] Can access client UI at http://localhost:3000
- [ ] Can access server API at http://localhost:5000
- [ ] Browser launches when starting recording
- [ ] AI generates descriptions during recording

---

## 📝 Notes

### First Time Setup

The first time you run the setup script, it will:
- Download ~150MB for Chromium browser
- Install ~500MB of node_modules
- Take 5-10 minutes depending on your internet speed

### Subsequent Runs

If you run the setup script again, it will:
- Skip already installed packages
- Update outdated packages
- Verify installation

### Environment Variables

The `.env` file is in `.gitignore` and will not be committed to version control. This is for security reasons. Each developer needs to create their own `.env` file with their own credentials.

### Playwright Browsers

Playwright browsers are installed globally in your user directory:
- Windows: `C:\Users\<username>\AppData\Local\ms-playwright`

You only need to install them once per machine, not per project.

---

## 🚀 Ready to Go!

Once setup is complete, you're ready to start using FlowGen!

```powershell
# Start the application
npm run dev

# Open your browser to
# http://localhost:3000

# Start recording and watch the magic happen! ✨
```

---

*For more information, see the main README.md or the AI integration documentation.*