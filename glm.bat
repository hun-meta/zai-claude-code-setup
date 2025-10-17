@echo off
REM GLM-4.6 model Claude Code execution script (Windows)
REM GLM-4.6 모델을 사용하기 위한 Claude Code 실행 스크립트 (Windows)
REM This script runs in API mode with custom API endpoint and key
REM 이 스크립트는 커스텀 API 엔드포인트와 키를 사용하여 API 모드로 실행됩니다.

REM --- Configuration start / 설정 시작 ---
REM Set GLM service Base URL / GLM 서비스 Base URL 설정
REM (e.g.: https://api.novita.ai/v3/anthropic)
set CLAUDE_BASE_URL=YOUR_GLM_PROVIDER_BASE_URL_HERE

REM Set GLM API Key / GLM API 키 설정
REM Please enter the API key issued by the service
REM 해당 서비스에서 발급받은 API 키를 입력하세요.
set ANTHROPIC_API_KEY=YOUR_GLM_API_KEY_HERE
REM --- Configuration end / 설정 종료 ---

REM Run Claude Code with isolated config dir and scoped env (new_solution.md)
REM 분리 설정 디렉토리와 스코프 환경 변수로 실행 (new_solution.md 방식)
setlocal
set CLAUDE_CONFIG_DIR=%USERPROFILE%\.claude-glm
set ANTHROPIC_BASE_URL=%CLAUDE_BASE_URL%
REM Arguments passthrough
claude %*
endlocal

