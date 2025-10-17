# Claude Code GLM Setup Automation

**Language / 언어**: [English](#-english-documentation) | [한국어](#-한국어-문서)

---

# 📖 English Documentation

# Claude Code GLM Setup Automation

Automated setup scripts to use Claude Code with GLM-4.6 model together.

**Supported Platforms**: macOS, Linux, Windows

## 📋 Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start (macOS/Linux)](#quick-start-macoslinux)
- [Quick Start (Windows)](#quick-start-windows)
- [Manual Setup (macOS/Linux)](#manual-setup-macoslinux)
- [Manual Setup (Windows)](#manual-setup-windows)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)

## ✨ Features

- Automatic Node.js and Claude Code installation check
- Automatic GLM custom command generation
- Automatic PATH environment variable setup
- **Cross-platform support** (macOS, Linux, Windows)
- **Isolated config per command** via `CLAUDE_CONFIG_DIR` (`~/.claude-glm`) to avoid credential cross-contamination
- Two execution modes:
  - `claude`: Standard subscription mode
  - `glm`: GLM-4.6 API mode

## 📦 Prerequisites

- **Node.js** (v16 or higher recommended)
- **npm**
- **GLM API Key** and **Base URL**

If Node.js is not installed, download it from the [official website](https://nodejs.org/).

## 🚀 Quick Start (macOS/Linux)

### 1. Clone Repository

```bash
git clone <repository-url>
cd zai-claude-code-setup
```

### 2. Run Setup Script

```bash
chmod +x setup.sh
./setup.sh
```

The script will request the following information:
- **GLM Provider Base URL** (e.g.: `https://api.novita.ai/v3/anthropic`)
- **GLM API Key** (API key issued by the service)

### 3. Apply Environment Variables

```bash
# For zsh users (macOS default)
source ~/.zshrc

# For bash users (Linux default)
source ~/.bashrc
```

Or restart the terminal.

---

## 🪟 Quick Start (Windows)

### 1. Clone Repository

```powershell
git clone <repository-url>
cd zai-claude-code-setup
```

### 2. Run PowerShell as Administrator

- Search for "PowerShell" in Windows Search
- Right-click > Select "Run as administrator"

### 3. Set Execution Policy (First time only)

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 4. Run Setup Script

```powershell
.\setup.ps1
```

The script will request the following information:
- **GLM Provider Base URL** (e.g.: `https://api.novita.ai/v3/anthropic`)
- **GLM API Key** (API key issued by the service)

### 5. Set session variables and restart PowerShell

Set your GLM environment in your session or profile (example):
```powershell
$env:ANTHROPIC_API_KEY = "YOUR_GLM_KEY"
$env:CLAUDE_BASE_URL   = "https://api.novita.ai/v3/anthropic"
```

Then close and reopen PowerShell.

---

## 🔧 Manual Setup (macOS/Linux)

Follow these steps if you prefer to set up manually without using the automation script.

### 1. Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

### 2. Create Directory

```bash
mkdir -p ~/.local/bin
```

### 3. Copy and Configure glm Script

```bash
# Copy glm script to ~/.local/bin
cp glm ~/.local/bin/glm

# Edit script
nano ~/.local/bin/glm
```

Modify the following section:
```bash
export CLAUDE_BASE_URL="YOUR_GLM_PROVIDER_BASE_URL_HERE"
export ANTHROPIC_API_KEY="YOUR_GLM_API_KEY_HERE"
```

### 4. Grant Execution Permission

```bash
chmod +x ~/.local/bin/glm
```

### 5. Set PATH

```bash
# For zsh users
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# For bash users
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## 🔧 Manual Setup (Windows)

Follow these steps if you prefer to set up manually without using the automation script.

### 1. Install Claude Code

```powershell
npm install -g @anthropic-ai/claude-code
```

### 2. Create Script Directory

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\bin" -Force
```

### 3. Copy and Configure glm.bat File

```powershell
# Copy glm.bat to user bin directory
Copy-Item glm.bat "$env:USERPROFILE\bin\glm.bat"

# Edit with Notepad
notepad "$env:USERPROFILE\bin\glm.bat"
```

Modify the following section:
```batch
set CLAUDE_BASE_URL=YOUR_GLM_PROVIDER_BASE_URL_HERE
set ANTHROPIC_API_KEY=YOUR_GLM_API_KEY_HERE
```

### 4. Set PATH Environment Variable

```powershell
# Add bin directory to current user's PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$currentPath;$env:USERPROFILE\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")
```

### 5. Restart PowerShell

Restart PowerShell to apply the changes.

---

## 💻 Usage

### Run Claude Code with Subscription (Interactive mode)

**macOS/Linux:**
```bash
# Start interactive session in current directory
claude .

# Run in specific directory
claude /path/to/project
```

**Windows:**
```powershell
# Start interactive session in current directory
claude .

# Run in specific directory
claude C:\path\to\project
```

This command uses default authentication:
- **macOS/Linux**: `~/.claude/credentials.json`
- **Windows**: `%USERPROFILE%\.claude\credentials.json`

### Run Claude Code with GLM Model (Isolated API mode)

**macOS/Linux (set env in session before running):**
```bash
# Start API server in current directory
glm .

# Run in specific directory
glm /path/to/project

# Run with specific file
glm my_project
```

Export these before running in the same session:
```bash
export ANTHROPIC_API_KEY="YOUR_GLM_KEY"
export CLAUDE_BASE_URL="https://api.novita.ai/v3/anthropic"
```

**Windows (set env in session before running):**
```powershell
# Start API server in current directory
glm .

# Run in specific directory
glm C:\path\to\project

# Run with specific project
glm my_project
```

Set these before running in the same session:
```powershell
$env:ANTHROPIC_API_KEY = "YOUR_GLM_KEY"
$env:CLAUDE_BASE_URL   = "https://api.novita.ai/v3/anthropic"
```

This command runs with isolated config and scoped environment:
- Config dir: `~/.claude-glm` (set by `CLAUDE_CONFIG_DIR`)
- Env vars (scoped to process): `CLAUDE_BASE_URL`, `ANTHROPIC_BASE_URL`, `ANTHROPIC_API_KEY`
- Launchers:
  - **macOS/Linux**: `~/.local/bin/glm` script
  - **Windows**: `%USERPROFILE%\bin\glm.bat` batch file

## 🔍 Verification

### macOS/Linux

To verify the setup is correct:

```bash
# Check if glm command is in PATH
which glm

# Sample output: /Users/username/.local/bin/glm

# Check glm script contents
cat ~/.local/bin/glm
```

### Windows

To verify the setup is correct (isolated config):

```powershell
# Check if glm command is in PATH
where.exe glm

# Sample output: C:\Users\username\bin\glm.bat

# Check isolated config dir exists and has settings.json
Test-Path "$env:USERPROFILE\.claude-glm\settings.json"

# Check glm batch file contents
type "$env:USERPROFILE\bin\glm.bat"
```

## 🛠 Troubleshooting

### glm command not found

**macOS/Linux:**
```bash
# Check PATH
echo $PATH

# Verify ~/.local/bin is included
# If not, run source again
source ~/.zshrc  # or ~/.bashrc
```

**Windows:**
```powershell
# Check PATH
$env:Path

# Restart PowerShell
# Or add PATH to current session
$env:Path += ";$env:USERPROFILE\bin"
```

### Claude Code not installed

**macOS/Linux:**
```bash
# Install globally
npm install -g @anthropic-ai/claude-code

# Verify installation
claude --version
```

**Windows (Administrator PowerShell):**
```powershell
# Install globally
npm install -g @anthropic-ai/claude-code

# Verify installation
claude --version
```

### Change API Key or Base URL

**macOS/Linux:**
```bash
# Edit glm script
nano ~/.local/bin/glm

# Or use
vim ~/.local/bin/glm
```

Modify `CLAUDE_BASE_URL` and `ANTHROPIC_API_KEY`, then save.

**Windows:**
```powershell
# Edit glm.bat file
notepad "$env:USERPROFILE\bin\glm.bat"
```

Modify `CLAUDE_BASE_URL` and `ANTHROPIC_API_KEY`, then save.

### Permission Error (macOS/Linux)

```bash
# Check execution permission
ls -la ~/.local/bin/glm

# Grant permission if needed
chmod +x ~/.local/bin/glm
```

### PowerShell Execution Policy Error (Windows)

```powershell
# Check execution policy
Get-ExecutionPolicy

# Change to RemoteSigned
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 📝 Script File Description

### macOS/Linux
- **`setup.sh`**: Bash-based setup automation script
- **`glm`**: Bash script template to run Claude Code with GLM-4.6 model

### Windows
- **`setup.ps1`**: PowerShell-based setup automation script
- **`glm.bat`**: Batch file template to run Claude Code with GLM-4.6 model

## 🔐 Security Notes

- Never commit API keys to public repositories
- Be careful with script files containing sensitive information:
  - **macOS/Linux**: `~/.local/bin/glm`
  - **Windows**: `%USERPROFILE%\bin\glm.bat`
- You can set stricter file permissions if needed:

**macOS/Linux:**
```bash
chmod 700 ~/.local/bin/glm
```

**Windows:**
```powershell
# Restrict access to other users in file properties
icacls "$env:USERPROFILE\bin\glm.bat" /inheritance:r /grant:r "$env:USERNAME:F"
```

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is distributed under the MIT License.

---

# 📖 한국어 문서

# Claude Code GLM 설정 자동화

Claude Code와 GLM-4.6 모델을 함께 사용하기 위한 자동화 설정 스크립트입니다.

**지원 플랫폼**: macOS, Linux, Windows

## 📋 목차

- [기능](#기능)
- [사전 요구사항](#사전-요구사항)
- [빠른 시작 (macOS/Linux)](#빠른-시작-macoslinux-1)
- [빠른 시작 (Windows)](#빠른-시작-windows-1)
- [수동 설정 (macOS/Linux)](#수동-설정-macoslinux-1)
- [수동 설정 (Windows)](#수동-설정-windows-1)
- [사용 방법](#사용-방법-1)
- [문제 해결](#문제-해결-1)

## ✨ 기능

- Node.js 및 Claude Code 설치 자동 확인
- GLM 커스텀 명령어 자동 생성
- PATH 환경 변수 자동 설정
- **크로스 플랫폼 지원** (macOS, Linux, Windows)
- 두 가지 실행 모드 지원:
  - `claude`: 기본 구독 모드
  - `glm`: GLM-4.6 API 모드

## 📦 사전 요구사항

- **Node.js** (v16 이상 권장)
- **npm**
- **GLM API 키** 및 **Base URL**

Node.js가 설치되어 있지 않다면 [공식 웹사이트](https://nodejs.org/)에서 다운로드하세요.

## 🚀 빠른 시작 (macOS/Linux)

### 1. 저장소 클론

```bash
git clone <repository-url>
cd zai-claude-code-setup
```

### 2. 설정 스크립트 실행

```bash
chmod +x setup.sh
./setup.sh
```

스크립트가 다음 정보를 요청합니다:
- **GLM Provider Base URL** (예: `https://api.novita.ai/v3/anthropic`)
- **GLM API Key** (서비스에서 발급받은 키)

### 3. 환경 변수 적용

```bash
# zsh 사용자 (macOS 기본)
source ~/.zshrc

# bash 사용자 (Linux 기본)
source ~/.bashrc
```

또는 터미널을 재시작하세요.

---

## 🪟 빠른 시작 (Windows)

### 1. 저장소 클론

```powershell
git clone <repository-url>
cd zai-claude-code-setup
```

### 2. PowerShell을 관리자 권한으로 실행

- Windows 검색에서 "PowerShell" 검색
- 우클릭 > "관리자 권한으로 실행" 선택

### 3. 실행 정책 설정 (최초 1회만)

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 4. 설정 스크립트 실행

```powershell
.\setup.ps1
```

스크립트가 다음 정보를 요청합니다:
- **GLM Provider Base URL** (예: `https://api.novita.ai/v3/anthropic`)
- **GLM API Key** (서비스에서 발급받은 키)

### 5. PowerShell 재시작

설정이 완료되면 PowerShell을 닫고 새 창을 여세요.

---

## 🔧 수동 설정 (macOS/Linux)

자동화 스크립트를 사용하지 않고 수동으로 설정하려면 다음 단계를 따르세요.

### 1. Claude Code 설치

```bash
npm install -g @anthropic-ai/claude-code
```

### 2. 디렉토리 생성

```bash
mkdir -p ~/.local/bin
```

### 3. glm 스크립트 복사 및 설정

```bash
# glm 스크립트를 ~/.local/bin으로 복사
cp glm ~/.local/bin/glm

# 스크립트 편집
nano ~/.local/bin/glm
```

다음 부분을 수정하세요:
```bash
export CLAUDE_BASE_URL="YOUR_GLM_PROVIDER_BASE_URL_HERE"
export ANTHROPIC_API_KEY="YOUR_GLM_API_KEY_HERE"
```

### 4. 실행 권한 부여

```bash
chmod +x ~/.local/bin/glm
```

### 5. PATH 설정

```bash
# zsh 사용자
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# bash 사용자
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## 🔧 수동 설정 (Windows)

자동화 스크립트를 사용하지 않고 수동으로 설정하려면 다음 단계를 따르세요.

### 1. Claude Code 설치

```powershell
npm install -g @anthropic-ai/claude-code
```

### 2. 스크립트 디렉토리 생성

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\bin" -Force
```

### 3. glm.bat 파일 복사 및 설정

```powershell
# glm.bat 파일을 사용자 bin 디렉토리로 복사
Copy-Item glm.bat "$env:USERPROFILE\bin\glm.bat"

# 메모장으로 편집
notepad "$env:USERPROFILE\bin\glm.bat"
```

다음 부분을 수정하세요:
```batch
set CLAUDE_BASE_URL=YOUR_GLM_PROVIDER_BASE_URL_HERE
set ANTHROPIC_API_KEY=YOUR_GLM_API_KEY_HERE
```

### 4. PATH 환경 변수 설정

```powershell
# 현재 사용자의 PATH에 bin 디렉토리 추가
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$currentPath;$env:USERPROFILE\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")
```

### 5. PowerShell 재시작

변경사항을 적용하려면 PowerShell을 재시작하세요.

---

## 💻 사용 방법

### 기본 Claude Code 실행 (구독 모드)

**macOS/Linux:**
```bash
# 현재 디렉토리에서 대화형 세션 시작
claude .

# 특정 디렉토리에서 실행
claude /path/to/project
```

**Windows:**
```powershell
# 현재 디렉토리에서 대화형 세션 시작
claude .

# 특정 디렉토리에서 실행
claude C:\path\to\project
```

이 명령어는 기본 인증 정보를 사용합니다:
- **macOS/Linux**: `~/.claude/credentials.json`
- **Windows**: `%USERPROFILE%\.claude\credentials.json`

### GLM 모델로 Claude Code 실행 (API 모드)

**macOS/Linux:**
```bash
# 현재 디렉토리를 기준으로 API 서버 시작
glm .

# 특정 디렉토리에서 실행
glm /path/to/project

# 특정 파일과 함께 실행
glm my_project
```

**Windows:**
```powershell
# 현재 디렉토리를 기준으로 API 서버 시작
glm .

# 특정 디렉토리에서 실행
glm C:\path\to\project

# 특정 프로젝트와 함께 실행
glm my_project
```

이 명령어는 커스텀 Base URL과 API 키를 사용합니다:
- **macOS/Linux**: `~/.local/bin/glm` 스크립트
- **Windows**: `%USERPROFILE%\bin\glm.bat` 배치 파일

## 🔍 확인 사항

### macOS/Linux

설정이 제대로 되었는지 확인하려면:

```bash
# glm 명령어가 PATH에 있는지 확인
which glm

# 출력 예시: /Users/username/.local/bin/glm

# glm 스크립트 내용 확인
cat ~/.local/bin/glm
```

### Windows

설정이 제대로 되었는지 확인하려면:

```powershell
# glm 명령어가 PATH에 있는지 확인
where.exe glm

# 출력 예시: C:\Users\username\bin\glm.bat

# glm 배치 파일 내용 확인
type "$env:USERPROFILE\bin\glm.bat"
```

## 🛠 문제 해결

### glm 명령어를 찾을 수 없음

**macOS/Linux:**
```bash
# PATH 확인
echo $PATH

# ~/.local/bin이 포함되어 있는지 확인
# 없다면 다시 source 실행
source ~/.zshrc  # 또는 ~/.bashrc
```

**Windows:**
```powershell
# PATH 확인
$env:Path

# PowerShell 재시작
# 또는 현재 세션에 PATH 추가
$env:Path += ";$env:USERPROFILE\bin"
```

### Claude Code가 설치되지 않음

**macOS/Linux:**
```bash
# 전역으로 설치
npm install -g @anthropic-ai/claude-code

# 설치 확인
claude --version
```

**Windows (관리자 권한 PowerShell):**
```powershell
# 전역으로 설치
npm install -g @anthropic-ai/claude-code

# 설치 확인
claude --version
```

### API 키 또는 Base URL 변경

**macOS/Linux:**
```bash
# glm 스크립트 편집
nano ~/.local/bin/glm

# 또는
vim ~/.local/bin/glm
```

`CLAUDE_BASE_URL`과 `ANTHROPIC_API_KEY`를 수정한 후 저장하세요.

**Windows:**
```powershell
# glm.bat 파일 편집
notepad "$env:USERPROFILE\bin\glm.bat"
```

`CLAUDE_BASE_URL`과 `ANTHROPIC_API_KEY`를 수정한 후 저장하세요.

### 권한 오류 (macOS/Linux)

```bash
# 실행 권한이 있는지 확인
ls -la ~/.local/bin/glm

# 권한이 없다면 부여
chmod +x ~/.local/bin/glm
```

### PowerShell 실행 정책 오류 (Windows)

```powershell
# 실행 정책 확인
Get-ExecutionPolicy

# RemoteSigned로 변경
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 📝 스크립트 파일 설명

### macOS/Linux
- **`setup.sh`**: Bash 기반 전체 설정 자동화 스크립트
- **`glm`**: GLM-4.6 모델로 Claude Code를 실행하는 Bash 스크립트 템플릿

### Windows
- **`setup.ps1`**: PowerShell 기반 전체 설정 자동화 스크립트
- **`glm.bat`**: GLM-4.6 모델로 Claude Code를 실행하는 배치 파일 템플릿

## 🔐 보안 참고사항

- API 키는 절대 공개 저장소에 커밋하지 마세요.
- 스크립트 파일에는 민감한 정보(API 키)가 포함되어 있으므로 주의하세요:
  - **macOS/Linux**: `~/.local/bin/glm`
  - **Windows**: `%USERPROFILE%\bin\glm.bat`
- 필요한 경우 파일 권한을 더 엄격하게 설정할 수 있습니다:

**macOS/Linux:**
```bash
chmod 700 ~/.local/bin/glm
```

**Windows:**
```powershell
# 파일 속성에서 다른 사용자의 접근 제한
icacls "$env:USERPROFILE\bin\glm.bat" /inheritance:r /grant:r "$env:USERNAME:F"
```

## 🤝 기여

이슈나 개선 사항이 있다면 언제든지 PR을 보내주세요!

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

