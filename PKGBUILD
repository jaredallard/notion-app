# Maintainer: Jared Allard <jaredallard@outlook.com>

pkgname=notion
pkgver=0.3.0
pkgrel=1
pkgdesc="The all-in-one workspace for your notes and tasks"
arch=('i686' 'x86_64')
url="http://github.com/jaredallard/notion-app"
license=('MIT')
depends=('pacman')
makedepends=('wget', 'img2dmg', 'p7zip')
source=("https://github.com/jaredallard/notion-app")
md5sums=('SKIP')

build() {
  cd "$pkgname-$pkgver"

  make
  sed '/^$/q' src/cower.c >LICENSE
}

package() {
  cd "$pkgname-$pkgver"

  mkdir -p /opt/
  cp -r tmp/build /opt/notion
  cp tmp/build/notion /usr/bin/notion
  chmod +x /usr/bin/notion
}

# vim: ft=sh syn=sh