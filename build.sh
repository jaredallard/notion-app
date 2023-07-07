#!/usr/bin/env bash
#
# Creates a distributible tarball for Notion.

set -e

info() {
  echo -e "\\033[36mINFO\\033[0m:" "$@"
}

error() {
  echo -e "\\033[31mERROR\\033[0m:" "$@"
}

sevenzip="7z"
if command -v 7zz >/dev/null; then # 7zip on macOS
  sevenzip="7zz"
elif command -v 7za >/dev/null; then # p7zip on Ubuntu
  sevenzip="7za"
fi

OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
  OS="darwin"
elif [[ "$OS" == "Linux" ]]; then
  OS="linux"
else
  error "unsupported OS: $OS"
  exit 1
fi

ARCH="$(uname -m)"
if [[ "$ARCH" == "x86_64" ]]; then
  ARCH="x64"
elif [[ "$ARCH" == "aarch64" ]]; then
  ARCH="arm64"
elif [[ "$ARCH" == "arm64" ]]; then
  ARCH="arm64"
else
  error "unsupported architecture: $ARCH"
  exit 1
fi

if ! command -v "$sevenzip" >/dev/null; then
  error "$sevenzip not found (install 7zip package?)"
  exit 1
fi

if ! command -v dmg2img >/dev/null; then
  error "dmg2img not found"
  exit 1
fi

# shellcheck source=config.sh
source config.sh

rm -rf tmp release 2>/dev/null || true
mkdir deps release tmp 2>/dev/null || true

info "Ensuring electron $ELECTRON_VERSION ..."
if [[ ! -e "deps/electron-$ELECTRON_VERSION.zip" ]]; then
  wget "https://github.com/electron/electron/releases/download/$ELECTRON_VERSION/electron-$ELECTRON_VERSION-$OS-$ARCH.zip" -O "deps/electron-$ELECTRON_VERSION.zip"
fi

info "Ensuring notion $NOTION_VERSION ..."
if [[ ! -e "deps/notion-$NOTION_VERSION.dmg" ]]; then
  wget "https://desktop-release.notion-static.com/Notion-$NOTION_VERSION.dmg" -O "deps/notion-$NOTION_VERSION.dmg"
  dmg2img "deps/notion-$NOTION_VERSION.dmg" "deps/notion-$NOTION_VERSION.img"
fi

info "Building Electron app ..."
rm -rf tmp/build 2>/dev/null || true
mkdir -p tmp/build 2>/dev/null || true

"$sevenzip" x "deps/electron-$ELECTRON_VERSION.zip" -y -otmp/build >/dev/null
# This will usually yell about an /Applications symlink, but it's fine. So,
# ignore errors here.
"$sevenzip" x "deps/notion-$NOTION_VERSION.img" -y -otmp/notion >/dev/null || true

appExtractPath=""
if [[ "$OS" == "darwin" ]]; then
  appExtractPath="tmp/build/Electron.app/Contents/Resources"
elif [[ "$OS" == "linux" ]]; then
  appExtractPath="tmp/build/resources"
elif [[ "$appExtractPath" == "" ]]; then
  error "unsupported OS: $OS"
  exit 1
fi

# Install the app.asar into the electron package we downloaded
# earlier.
cp -rp tmp/notion/Notion**/*.app/Contents/Resources/app "$appExtractPath"
cp notion LICENSE install.sh tmp/build

# Build the archive
rm -rf release/*
"$sevenzip" a "release/notion-$NOTION_VERSION.tar" tmp/build
"$sevenzip" rn "release/notion-$NOTION_VERSION.tar" tmp/build "notion-$NOTION_VERSION"

# Remove stock app.asar
rm "$appExtractPath/default_app.asar"

# Skip compression
if [[ "$1" != "--no-compress" ]]; then
  xz --threads=0 "release/notion-$NOTION_VERSION.tar"
fi

set +x

info "Built in 'release/notion-$NOTION_VERSION.tar.xz'"
