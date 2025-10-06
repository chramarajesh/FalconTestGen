# FlowGen Project Summary

## Overview
FlowGen is an intelligent browser automation and test generation tool that records user interactions in real-time, generates human-readable test descriptions using AI, analyzes application context, and creates comprehensive test scenarios automatically. It's designed for developers and QA engineers to streamline test creation and automation workflows.

## Key Features
- 🎥 Real-time user interaction recording with Playwright
- 🤖 AI-powered test description generation using Google Gemini AI
- 📊 Application context analysis and user flow mapping
- 🧪 Automated test scenario creation
- 💾 Session-based in-memory test case storage
- 🌐 WebSocket integration for real-time updates
- 🔍 Smart locator generation (CSS, XPath, ID, Text)

## Tech Stack

### Frontend
- **React 18** with TypeScript for type-safe development
- **Vite** for fast development and hot module replacement
- **Tailwind CSS** for utility-first styling
- **Axios** for API communication
- **WebSocket** for real-time updates

### Backend
- **Node.js** with Express.js framework
- **Playwright** for browser automation and testing
- **Google Gemini AI** for intelligent test description generation
- **WebSocket (ws)** for server-client communication
- **CORS** and environment configuration with dotenv

### Development Tools
- **Nodemon** for auto-restarting server on changes
- **ESLint** for code linting
- **TypeScript** for type safety
- **Concurrently** for running multiple processes

## Installation Requirements

### Prerequisites
- **Node.js 18+** (includes npm)
- **Windows PowerShell** or Command Prompt (for setup scripts)

### Recommended
- **Google Gemini API Key** for AI features ([Get here](https://makersuite.google.com/app/apikey))

## Quick Setup

### Automated Setup (Recommended)
```powershell
# For PowerShell
.\setup.ps1

# For Command Prompt
setup.bat
```

### Manual Setup
1. Install dependencies: `npm run install-all`
2. Configure environment: Add API keys to `server/.env`
3. Install Playwright browsers: `cd server && npx playwright install chromium`

## Getting Started
```bash
# Start development servers
npm run dev

# Client runs on http://localhost:3000
# Server runs on http://localhost:5000
```

## Project Structure
```
FlowGen/
├── client/          # React frontend (Vite + TypeScript)
├── server/          # Express backend (Node.js)
├── scripts/         # PowerShell restart scripts
├── package.json     # Root scripts and dependencies
└── README.md        # Detailed documentation
```

## UI Workflows

### 1. Application Context Workflow
**Purpose**: Record user interactions in a browser to analyze application behavior and generate AI-powered test scenarios

**Steps**:
1. **Mode Selection** - Choose "Application Context" recording mode in the UI
2. **Browser Launch** - Launch Playwright browser instance with recording capabilities
3. **Interaction Recording** - User performs actions (clicks, inputs, navigation) in the browser
4. **Real-time Capture** - Each action is captured with DOM context, element properties, and page information
5. **AI Description Generation** - Google Gemini AI generates human-readable descriptions for each step
6. **Context Analysis** - AI analyzes the full application context, identifying features and user flows
7. **Scenario Generation** - AI generates comprehensive test scenarios based on recorded interactions
8. **Test Case Creation** - Convert scenarios into executable test cases with proper selectors

**Functionality**: End-to-end workflow that transforms manual browser interactions into intelligent, AI-generated test cases through contextual analysis of application behavior.

### 2. Visual Context Workflow
**Purpose**: Analyze uploaded screenshots to understand UI structure and generate test scenarios from visual information

**Steps**:
1. **Mode Selection** - Choose "Visual Context" recording mode in the UI
2. **Screenshot Upload** - Upload multiple application screenshots (up to 20 images, 10MB each)
3. **Session Creation** - Create a unique session to manage the uploaded screenshots
4. **AI Visual Analysis** - Google Gemini AI analyzes each screenshot for:
   - Page identification and classification
   - UI element detection and properties
   - Workflow pattern recognition
   - Interactive element identification
5. **Sequence Management** - Optionally reorder screenshots to establish proper user flow sequence
6. **Scenario Generation** - AI generates test scenarios based on visual analysis and sequence
7. **Test Case Creation** - Transform visual scenarios into executable test cases with appropriate selectors

**Functionality**: Screenshot-based workflow that enables test generation from visual application documentation, supporting scenarios where direct browser access isn't available.

## Ports
- **Frontend (Vite)**: http://localhost:3000
- **Backend (Express API)**: http://localhost:5000

## API Endpoints
- Browser control: `/api/browser/*`
- Recording: `/api/recording/*`
- Test cases: `/api/testcase/*`
- Health check: `/api/health`

For detailed documentation, see [README.md](README.md) and other `.md` files in the project root.