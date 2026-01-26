#!/bin/bash

# Claude Code CLI 설치 스크립트 (Ubuntu/Linux용)
# 공식 설치 방법: https://claude.ai/install.sh

set -e

echo "======================================"
echo "  Claude Code CLI 설치 스크립트"
echo "======================================"
echo ""

# 시스템 요구사항 확인
echo "[1/3] 시스템 요구사항 확인 중..."

# Ubuntu 버전 확인
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "  - OS: $NAME $VERSION_ID"
else
    echo "  - OS 정보를 확인할 수 없습니다."
fi

# curl 설치 확인
if ! command -v curl &> /dev/null; then
    echo "  - curl이 설치되어 있지 않습니다. 설치 중..."
    sudo apt-get update && sudo apt-get install -y curl
else
    echo "  - curl: 설치됨"
fi

echo ""
echo "[2/3] Claude Code CLI 설치 중..."
echo "  - 공식 설치 스크립트 실행: https://claude.ai/install.sh"
echo ""

# 공식 설치 스크립트 실행
curl -fsSL https://claude.ai/install.sh | bash

echo ""
echo "[3/3] 설치 확인 중..."

# 설치 확인
if command -v claude &> /dev/null; then
    echo ""
    echo "======================================"
    echo "  설치 완료!"
    echo "======================================"
    echo ""
    echo "Claude Code 버전:"
    claude --version
    echo ""
    echo "사용법: claude"
    echo "문제 진단: claude doctor"
    echo ""
else
    echo ""
    echo "======================================"
    echo "  설치 후 셸을 재시작하세요"
    echo "======================================"
    echo ""
    echo "다음 명령어를 실행하거나 터미널을 재시작하세요:"
    echo "  source ~/.bashrc  (bash 사용 시)"
    echo "  source ~/.zshrc   (zsh 사용 시)"
    echo ""
fi
