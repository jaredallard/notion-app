#!/bin/sh
set -e
WORKING_DIR=`pwd`
cat <<EOS > Notion.desktop
[Desktop Entry]
Name=Notion
Name[en_US]=Notion
Comment=Unofficial Notion.so application for Linux
Exec="/opt/notion/notion"
Terminal=false
Categories=Office;TextEditor;Utility
Type=Application
Icon=${WORKING_DIR}/Notion_app_logo.png
StartupWMClass=notion
EOS
chmod +x Notion.desktop

# This can be updated if this path is not valid. 
cp -p Notion.desktop ~/.local/share/applications