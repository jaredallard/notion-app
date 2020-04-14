#!/usr/bin/env bash
#
# Pull notion and build a fresh linux build

set -e

info() {
  echo -e "\\033[36mINFO\\033[0m: $@"
}

error() {
  echo -e "\\033[31mERROR\\033[0m: $@"
}

if ! 7z --help 2>/dev/null >/dev/null; then
  error "7z not found (pz7ip?)"
  exit 1
fi

if ! dmg2img >/dev/null; then
  error "dmg2img not found"
  exit 1
fi

# shellcheck source=config.sh
source config.sh

mkdir deps release tmp 2>/dev/null || true

info "fetching electron $ELECTRON_VERSION ..."
if [[ ! -e "deps/electron-$ELECTRON_VERSION.zip" ]]; then
  wget "https://github.com/electron/electron/releases/download/$ELECTRON_VERSION/electron-$ELECTRON_VERSION-linux-x64.zip" -O "deps/electron-$ELECTRON_VERSION.zip"
fi

info "fetching notion $NOTION_VERSION ..."
if [[ ! -e "deps/notion-$NOTION_VERSION.dmg" ]]; then
  wget "https://desktop-release.notion-static.com/Notion-$NOTION_VERSION.dmg" -O "deps/notion-$NOTION_VERSION.dmg"
  dmg2img "deps/notion-$NOTION_VERSION.dmg" "deps/notion-$NOTION_VERSION.img"
fi

info "building electron build ..."
rm -rf tmp/build 2>/dev/null || true
mkdir -p tmp/build 2>/dev/null || true

set -x
7z x "deps/electron-$ELECTRON_VERSION.zip" -y -otmp/build >/dev/null
7z x "deps/notion-$NOTION_VERSION.img" -y  -otmp/notion >/dev/null
cp -r tmp/notion/Notion**/*.app/Contents/Resources/* tmp/build
cp notion tmp/build

# Skip compression
if [[ "$1" != "--no-compress" ]]; then
  rm -rf release/*
  7z a "release/notion-$NOTION_VERSION.tar" tmp/build
  7z rn "release/notion-$NOTION_VERSION.tar" tmp/build "notion-$NOTION_VERSION"
  xz --threads=0 "release/notion-$NOTION_VERSION.tar"
fi

set +x

info "built in 'release/notion-$NOTION_VERSION.tar.xz'"

tar xf "release/notion-$NOTION_VERSION.tar.xz" -C tmp
cp Notion_app_logo.png "tmp/notion-$NOTION_VERSION"

sudo mv "tmp/notion-$NOTION_VERSION" /opt/notion

source create_shortcut.sh

sudo cp notion /usr/bin/notion