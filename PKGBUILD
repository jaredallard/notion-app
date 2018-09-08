# Maintainer: Jared Allard <jaredallard@outlook.com>

pkgname=notion
pkgver=0.3.0
pkgrel=1
pkgdesc="The all-in-one workspace for your notes and tasks"
arch=('i686' 'x86_64')
url="http://github.com/jaredallard/notion-app"
license=('MIT')
depends=('pacman')
makedepends=('wget' 'dmg2img' 'p7zip' 'patch')
source=('build.sh' 'config.sh' 'notion')
md5sums=('SKIP' 'SKIP' 'SKIP')


pkgver() {
  source config.sh
  echo $NOTION_VERSION
}

build() {
  ./build.sh --no-compress
}

package() {
  echo "$pkgdir"
  mkdir -p "$pkgdir/usr/bin" "$pkgdir/opt/notion"
  cp -r tmp/build/* "$pkgdir/opt/notion/"
  install -D -m755 notion "$pkgdir/usr/bin/notion"
}

# vim: ft=sh syn=sh