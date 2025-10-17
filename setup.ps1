# Claude Code Setup Automation Script (Windows PowerShell)
# Windows PowerShell 기반 Claude Code 설정 자동화 스크립트
# This script automatically installs Node.js, Claude Code, and sets up glm custom command
# 이 스크립트는 Node.js, Claude Code 설치 및 glm 커스텀 명령어 설정을 자동으로 수행합니다.

# Check for admin rights (optional) / 관리자 권한 확인 (선택적)
# $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Color output functions / 색상 함수
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Stop on error / 에러 발생 시 중단
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=========================================="
Write-Info "Claude Code + GLM Setup Starting"
Write-Host "=========================================="
Write-Host ""

# Step 1: Check Node.js and npm installation
# 1단계: Node.js 및 npm 확인
Write-Info "Checking Node.js and npm installation..."

try {
    $nodeVersion = node -v
    Write-Success "Node.js version: $nodeVersion"
} catch {
    Write-Error "Node.js is not installed."
    Write-Info "Please install Node.js: https://nodejs.org/"
    Read-Host "Press Enter to exit"
    exit 1
}

try {
    $npmVersion = npm -v
    Write-Success "npm version: $npmVersion"
} catch {
    Write-Error "npm is not installed."
    Read-Host "Press Enter to exit"
    exit 1
}

# Step 2: Check and install Claude Code
# 2단계: Claude Code 설치 확인 및 설치
Write-Info "Checking Claude Code installation..."

try {
    $claudeVersion = claude --version 2>$null
    Write-Success "Claude Code is already installed."
} catch {
    Write-Warning "Claude Code is not installed. Installing globally..."
    try {
        npm install -g @anthropic-ai/claude-code
        Write-Success "Claude Code installed successfully!"
    } catch {
        Write-Error "Failed to install Claude Code."
        Write-Info "Please run PowerShell with administrator rights and try again."
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# Step 3: Create script directory
# 3단계: 스크립트 디렉토리 생성
$scriptDir = "$env:USERPROFILE\bin"
Write-Info "Creating script directory... ($scriptDir)"

if (-not (Test-Path $scriptDir)) {
    New-Item -ItemType Directory -Path $scriptDir -Force | Out-Null
    Write-Success "Directory created successfully!"
} else {
    Write-Info "Directory already exists."
}

# Step 4: Get GLM configuration
# 4단계: GLM 정보 입력
Write-Host ""
Write-Info "Please enter the GLM model configuration information."
Write-Host ""

$GLM_BASE_URL = Read-Host "Enter GLM Provider Base URL (e.g.: https://api.novita.ai/v3/anthropic)"
$GLM_API_KEY = Read-Host "Enter GLM API Key"

# Step 5: Create glm.bat batch file
# 5단계: glm.bat 배치 파일 생성
Write-Info "Creating glm.bat execution script..."

$batFilePath = "$scriptDir\glm.bat"
$batContent = @"
@echo off
REM GLM-4.6 model Claude Code execution script
REM GLM-4.6 모델을 사용하기 위한 Claude Code 실행 스크립트
REM This script runs in API mode with custom API endpoint and key
REM 이 스크립트는 커스텀 API 엔드포인트와 키를 사용하여 API 모드로 실행됩니다.

REM Set GLM service Base URL / GLM 서비스 Base URL 설정
REM (e.g.: https://api.novita.ai/v3/anthropic)
set CLAUDE_BASE_URL=$GLM_BASE_URL

REM Set GLM API Key / GLM API 키 설정
REM Please enter the API key issued by the service
REM 해당 서비스에서 발급받은 API 키를 입력하세요.
set ANTHROPIC_API_KEY=$GLM_API_KEY

REM Run Claude Code in API mode
REM Claude Code를 API 모드로 실행
REM %* passes all arguments after glm command to claude
REM %* 는 glm 명령어 뒤에 오는 모든 인자를 claude에 전달합니다.
claude --api %*
"@

Set-Content -Path $batFilePath -Value $batContent -Encoding UTF8
Write-Success "glm.bat script created successfully!"

# Step 6: Set PATH environment variable
# 6단계: PATH 환경 변수 설정
Write-Info "Setting PATH environment variable..."

# Get current user PATH / 현재 사용자의 PATH 가져오기
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Check if already in PATH / 이미 PATH에 있는지 확인
if ($currentPath -like "*$scriptDir*") {
    Write-Info "PATH is already set."
} else {
    # Add to PATH / PATH에 추가
    $newPath = "$currentPath;$scriptDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Success "PATH environment variable added: $scriptDir"
    Write-Warning "You must restart PowerShell to apply the changes."
}

# Add to current session PATH / 현재 세션에도 PATH 추가
$env:Path = "$env:Path;$scriptDir"

# Step 7: Completion message
# 7단계: 완료 메시지
Write-Host ""
Write-Host "=========================================="
Write-Success "All settings completed successfully!"
Write-Host "=========================================="
Write-Host ""
Write-Info "Usage:"
Write-Host ""
Write-Host "  1. Run Claude Code with subscription (Interactive mode):" -ForegroundColor White
Write-Host "     PS> claude ." -ForegroundColor White
Write-Host ""
Write-Host "  2. Run Claude Code with GLM model (API mode):" -ForegroundColor White
Write-Host "     PS> glm ." -ForegroundColor White
Write-Host ""
Write-Warning "Important: To use the glm command, restart PowerShell or open a new terminal window!"
Write-Host ""
Write-Info "Script location: $batFilePath"
Write-Host ""

Read-Host "Press Enter to exit"

