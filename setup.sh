#!/bin/bash

# Claude Code Setup Automation Script
# 이 스크립트는 Node.js, Claude Code 설치 및 glm 커스텀 명령어 설정을 자동으로 수행합니다.

set -e  # Exit on error / 에러 발생 시 스크립트 종료

# Color codes / 색상 코드
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions / 로그 함수
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Step 1: Check Node.js and npm installation
# 1단계: Node.js 및 npm 확인
log_info "Checking Node.js and npm installation..."

if ! command -v node &> /dev/null; then
    log_error "Node.js is not installed."
    log_info "Please install Node.js: https://nodejs.org/"
    exit 1
else
    log_success "Node.js version: $(node -v)"
fi

if ! command -v npm &> /dev/null; then
    log_error "npm is not installed."
    exit 1
else
    log_success "npm version: $(npm -v)"
fi

# Step 2: Check and install Claude Code
# 2단계: Claude Code 설치 확인 및 설치
log_info "Checking Claude Code installation..."

if ! command -v claude &> /dev/null; then
    log_warning "Claude Code is not installed. Installing globally..."
    npm install -g @anthropic-ai/claude-code
    log_success "Claude Code installed successfully!"
else
    log_success "Claude Code is already installed."
fi

# Step 3: Create ~/.local/bin directory
# 3단계: ~/.local/bin 디렉토리 생성
log_info "Creating ~/.local/bin directory..."
mkdir -p ~/.local/bin
log_success "Directory created successfully!"

# Step 4: Create glm script
# 4단계: glm 스크립트 생성
log_info "Creating glm execution script..."

GLM_SCRIPT_PATH="$HOME/.local/bin/glm"

# Get GLM_BASE_URL and GLM_API_KEY input
# GLM_BASE_URL과 GLM_API_KEY 입력 받기
echo ""
log_info "Please enter the GLM model configuration information."
echo ""

read -p "Enter GLM Provider Base URL (e.g.: https://api.novita.ai/v3/anthropic): " GLM_BASE_URL
read -p "Enter GLM API Key: " GLM_API_KEY

# Write glm script
# glm 스크립트 작성
cat > "$GLM_SCRIPT_PATH" << EOF
#!/bin/bash

# GLM-4.6 model Claude Code execution script
# GLM-4.6 모델을 사용하기 위한 Claude Code 실행 스크립트
# This script runs in API mode with custom API endpoint and key
# 이 스크립트는 커스텀 API 엔드포인트와 키를 사용하여 API 모드로 실행됩니다.

# Isolated config dir and scoped env vars per new_solution.md approach
# 분리된 설정 디렉토리와 스코프 환경 변수 (new_solution.md 방식)
CLAUDE_CONFIG_DIR="$HOME/.claude-glm" \
CLAUDE_BASE_URL="$GLM_BASE_URL" \
ANTHROPIC_BASE_URL="$GLM_BASE_URL" \
ANTHROPIC_API_KEY="$GLM_API_KEY" \
claude "\$@"
EOF

log_success "glm script created successfully!"

# Ensure isolated GLM config directory and settings.json exist
# 분리된 GLM 설정 디렉토리와 settings.json 생성
log_info "Creating GLM config directory and settings.json (~/.claude-glm)..."
mkdir -p "$HOME/.claude-glm"
cat > "$HOME/.claude-glm/settings.json" << 'JSON'
{
  "apiKeyHelper": "printf %s \"$ANTHROPIC_API_KEY\""
}
JSON
log_success "GLM config directory and settings.json created."

# Step 4.5: Install SuperClaude to GLM environment (optional)
# 4.5단계: GLM 환경에 SuperClaude 설치 (선택 사항)
echo ""
log_info "Would you like to install SuperClaude in the GLM environment?"
read -p "Install SuperClaude? (y/N): " INSTALL_SC

if [[ "$INSTALL_SC" =~ ^[Yy]$ ]]; then
    log_info "Checking for SuperClaude installation..."
    
    # Check if SuperClaude is available (npm first, then Python)
    # npm 우선, 그 다음 Python 순서로 확인
    SC_COMMAND=""
    if command -v superclaude &> /dev/null; then
        SC_COMMAND="superclaude"
        log_success "SuperClaude (npm) is available."
    elif command -v SuperClaude &> /dev/null; then
        SC_COMMAND="SuperClaude"
        log_success "SuperClaude (Python) is available."
    elif python3 -m SuperClaude --version &> /dev/null 2>&1; then
        SC_COMMAND="python3 -m SuperClaude"
        log_success "SuperClaude (Python module) is available."
    fi
    
    if [ -n "$SC_COMMAND" ]; then
        log_info "Setting up SuperClaude for GLM environment (~/.claude-glm)..."
        
        echo ""
        log_warning "IMPORTANT: SuperClaude will be copied to: ~/.claude-glm"
        log_warning "This is separate from your default ~/.claude directory."
        echo ""
        
        # Check if SuperClaude is already installed in default directory
        # 기본 디렉토리에 SuperClaude가 설치되어 있는지 확인
        if [ -f "$HOME/.claude/CLAUDE.md" ]; then
            log_success "SuperClaude found in default directory (~/.claude)"
            log_info "Copying SuperClaude files to GLM directory..."
            
            # List of SuperClaude files/directories to copy
            # 복사할 SuperClaude 파일/디렉토리 목록
            SC_FILES=(
                "CLAUDE.md"
                "COMMANDS.md"
                "MODES.md"
                "PERSONAS.md"
                "PRINCIPLES.md"
                "RULES.md"
                "MCP.md"
                "ORCHESTRATOR.md"
                "FLAGS.md"
                "commands"
                "hooks"
                "plugins"
            )
            
            # Copy each file/directory if it exists
            # 각 파일/디렉토리가 존재하면 복사
            for item in "${SC_FILES[@]}"; do
                if [ -e "$HOME/.claude/$item" ]; then
                    cp -r "$HOME/.claude/$item" "$HOME/.claude-glm/"
                    log_success "Copied: $item"
                fi
            done
            
            # Verify installation
            # 설치 검증
            if [ -f "$HOME/.claude-glm/CLAUDE.md" ]; then
                log_success "SuperClaude successfully set up in GLM environment!"
                echo ""
                log_info "Copied SuperClaude files to ~/.claude-glm/"
                log_info "Your GLM environment now has all SuperClaude features."
            else
                log_warning "Warning: CLAUDE.md not found after copy. Please check manually."
            fi
        else
            log_warning "SuperClaude not found in default directory (~/.claude)"
            log_info "Installing SuperClaude to default directory first..."
            
            # Install to default directory
            # 기본 디렉토리에 설치
            if $SC_COMMAND install; then
                log_success "SuperClaude installed to default directory."
                log_info "Now copying to GLM directory..."
                
                # Copy files after installation
                # 설치 후 파일 복사
                SC_FILES=(
                    "CLAUDE.md"
                    "COMMANDS.md"
                    "MODES.md"
                    "PERSONAS.md"
                    "PRINCIPLES.md"
                    "RULES.md"
                    "MCP.md"
                    "ORCHESTRATOR.md"
                    "FLAGS.md"
                    "commands"
                    "hooks"
                    "plugins"
                )
                
                for item in "${SC_FILES[@]}"; do
                    if [ -e "$HOME/.claude/$item" ]; then
                        cp -r "$HOME/.claude/$item" "$HOME/.claude-glm/"
                        log_success "Copied: $item"
                    fi
                done
                
                log_success "SuperClaude successfully set up in GLM environment!"
            else
                log_error "Failed to install SuperClaude. Please install manually."
            fi
        fi
    else
        log_warning "SuperClaude is not installed globally."
        log_info "Please install SuperClaude first using one of these methods:"
        echo "  - Using npm (recommended):  npm install -g @bifrost_inc/superclaude"
        echo "  - Using pipx: pipx install SuperClaude"
        echo "  - Using pip:  pip install SuperClaude"
        echo ""
        log_info "After installing, you can run this script again or manually install:"
        echo "  CLAUDE_CONFIG_DIR=\"\$HOME/.claude-glm\" superclaude install  # npm version"
        echo "  # or"
        echo "  CLAUDE_CONFIG_DIR=\"\$HOME/.claude-glm\" SuperClaude install  # Python version"
    fi
else
    log_info "Skipping SuperClaude installation."
    log_info "You can install it later with:"
    echo "  CLAUDE_CONFIG_DIR=\"\$HOME/.claude-glm\" superclaude install  # npm (recommended)"
    echo "  # or"
    echo "  CLAUDE_CONFIG_DIR=\"\$HOME/.claude-glm\" SuperClaude install  # Python"
fi

# Step 5: Grant execution permission
# 5단계: 실행 권한 부여
log_info "Granting execution permission to glm script..."
chmod +x "$GLM_SCRIPT_PATH"
log_success "Execution permission granted!"

# Step 6: Set PATH environment variable
# 6단계: PATH 환경 변수 설정
log_info "Setting PATH environment variable..."

# Check current shell / 현재 쉘 확인
CURRENT_SHELL=$(basename "$SHELL")

if [ "$CURRENT_SHELL" = "zsh" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ "$CURRENT_SHELL" = "bash" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    log_warning "Unknown shell: $CURRENT_SHELL"
    SHELL_RC="$HOME/.profile"
fi

# Check if ~/.local/bin is already in PATH
# PATH에 ~/.local/bin이 이미 있는지 확인
if grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
    log_info "PATH is already set in $SHELL_RC."
else
    echo '' >> "$SHELL_RC"
    echo '# PATH setting for Claude Code GLM custom command' >> "$SHELL_RC"
    echo '# Claude Code GLM 커스텀 명령어를 위한 PATH 설정' >> "$SHELL_RC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    log_success "PATH setting added to $SHELL_RC."
fi

# Step 7: Completion message
# 7단계: 완료 메시지
echo ""
echo "=========================================="
log_success "All settings completed successfully!"
echo "=========================================="
echo ""
log_info "Apply settings immediately with the following command:"
echo "  source $SHELL_RC"
echo ""
log_info "Or restart the terminal."
echo ""
echo "Usage:"
echo "  1. Run Claude Code with subscription (Interactive mode):"
echo "     $ claude ."
echo ""
echo "  2. Run Claude Code with GLM model (API mode):"
echo "     $ glm ."
echo ""
log_warning "Important: To use the glm command, first run 'source $SHELL_RC' or restart the terminal!"
echo ""

