_pkgname=qmlterm
pkgname=$_pkgname-git
pkgver=0.0.1
pkgrel=1
pkgdesc="QML-based terminal emulator"
arch=("i686" "x86_64")
url="https://github.com/rbn42/qmlterm"
license=("MIT")
provides=("$_pkgname")
conflicts=("$_pkgname")
depends=("qt5-base" "qt5-declarative" "qt5-quickcontrols" "qt5-graphicaleffects")
makedepends=()
conflicts=('qmltermwidget')
source=("git+https://github.com/rbn42/$_pkgname.git")
sha256sums=("SKIP")

prepare() {
  cd "$srcdir/qmlterm"
  git submodule update --init
}

build() {
	mkdir -p build
	cd build
	qmake "$srcdir/$_pkgname" 
	make
        cd ..

	mkdir -p build_process
	cd build_process
	qmake "$srcdir/$_pkgname/QMLProcess" 
	make
        cd ..

	mkdir -p build_qmltermwidget
	cd build_qmltermwidget
	qmake "$srcdir/$_pkgname/qmltermwidget" 
	make
        cd ..
}

package() {
	cd build
        make INSTALL_ROOT="$pkgdir" install
        cd ..

	cd build_process
        make INSTALL_ROOT="$pkgdir" install
        cd ..

	cd build_qmltermwidget
        make INSTALL_ROOT="$pkgdir" install
        cd ..
}
