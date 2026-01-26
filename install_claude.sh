#!/bin/bash

# Claude Code CLI 바이너리 다운로드 스크립트
# Windows용 claude.exe와 Linux용 claude를 현재 디렉토리에 다운로드

set -e

GCS_BUCKET="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"
DOWNLOAD_DIR="$(pwd)"

echo "======================================"
echo "  Claude Code 바이너리 다운로드"
echo "======================================"
echo ""
echo "다운로드 위치: $DOWNLOAD_DIR"
echo ""

# curl 설치 확인
if ! command -v curl &> /dev/null; then
    echo "오류: curl이 설치되어 있지 않습니다."
    echo "설치: sudo apt-get install curl"
    exit 1
fi

# 최신 버전 확인
echo "[1/4] 최신 버전 확인 중..."
VERSION=$(curl -fsSL "$GCS_BUCKET/latest")
echo "  - 최신 버전: $VERSION"

# Linux 플랫폼 감지
echo ""
echo "[2/4] 플랫폼 감지 중..."
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  LINUX_ARCH="x64" ;;
    aarch64) LINUX_ARCH="arm64" ;;
    arm64)   LINUX_ARCH="arm64" ;;
    *)       LINUX_ARCH="x64" ;;
esac
LINUX_PLATFORM="linux-$LINUX_ARCH"
echo "  - Linux 플랫폼: $LINUX_PLATFORM"
echo "  - Windows 플랫폼: win32-x64"

# Linux용 claude 다운로드
echo ""
echo "[3/4] Linux용 claude 다운로드 중..."
LINUX_URL="$GCS_BUCKET/$VERSION/$LINUX_PLATFORM/claude"
echo "  - URL: $LINUX_URL"

if curl -fsSL -o "$DOWNLOAD_DIR/claude" "$LINUX_URL"; then
    chmod +x "$DOWNLOAD_DIR/claude"
    echo "  - 완료: $DOWNLOAD_DIR/claude"
else
    echo "  - 실패: Linux용 claude 다운로드 오류"
fi

# Windows용 claude.exe 다운로드
echo ""
echo "[4/4] Windows용 claude.exe 다운로드 중..."
WINDOWS_URL="$GCS_BUCKET/$VERSION/win32-x64/claude.exe"
echo "  - URL: $WINDOWS_URL"

if curl -fsSL -o "$DOWNLOAD_DIR/claude.exe" "$WINDOWS_URL"; then
    echo "  - 완료: $DOWNLOAD_DIR/claude.exe"
else
    echo "  - 실패: Windows용 claude.exe 다운로드 오류"
fi

# 결과 확인
echo ""
echo "======================================"
echo "  다운로드 완료!"
echo "======================================"
echo ""
echo "다운로드된 파일:"
ls -lh "$DOWNLOAD_DIR/claude" "$DOWNLOAD_DIR/claude.exe" 2>/dev/null || echo "일부 파일이 없습니다."
echo ""
echo "Linux에서 실행: ./claude"
echo "Windows에서 실행: claude.exe"
echo ""
