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

REM Run Claude Code in API mode
REM Claude Code를 API 모드로 실행
REM %* passes all arguments after glm command to claude
REM %* 는 glm 명령어 뒤에 오는 모든 인자(예: ., file.js 등)를 claude 명령어로 그대로 전달합니다.
claude --api %*

