#!bin/bash

if [ -z "$1" ]
then
    echo "Missing argument for target Qt version tag."
    exit 1
fi

pacman -Syu --needed --noconfirm git cmake ninja \
    libjpeg-turbo xcb-util-keysyms xcb-util-cursor libgl fontconfig xdg-utils \
    shared-mime-info xcb-util-wm libxrender libxi sqlite mesa \
    tslib libinput libxkbcommon-x11 libproxy libcups double-conversion brotli libb2 \
    libfbclient mariadb-libs unixodbc postgresql alsa-lib gst-plugins-base-libs \
    gtk3 libpulse cups freetds vulkan-headers xmlstarlet \
    python at-spi2-core \
    libxcomposite

git clone https://github.com/qt/qtbase --branch $1 --verbose --depth 1
mkdir qt-build && cd qt-build
cmake ../qtbase \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DQT_FEATURE_sql=OFF \
    -DQT_FEATURE_dbus=OFF \
    -DQT_FEATURE_testlib=OFF \
    -DQT_FEATURE_qmake=OFF \
    -DCMAKE_INSTALL_PREFIX=../installed-static \
    -GNinja
cmake --build . --parallel
cmake --install .
cd ..

git clone https://github.com/qt/qtsvg --branch $1 --verbose --depth 1
mkdir qtsvg-build && cd qtsvg-build
../installed-static/bin/qt-configure-module ../qtsvg/
cmake --build . --parallel
cmake --install .
cd ..

git clone https://github.com/qt/qtdeclarative --branch $1 --verbose --depth 1
mkdir qtdeclarative-build && cd qtdeclarative-build
../installed-static/bin/qt-configure-module ../qtdeclarative/
cmake --build . --parallel
cmake --install .
cd ..

git clone https://github.com/qt/qtwayland --branch $1 --verbose --depth 1
mkdir qtwayland-build && cd qtwayland-build
../installed-static/bin/qt-configure-module ../qtwayland/
cmake --build . --parallel
cmake --install .
cd ..

git clone https://github.com/qt/qt5compat --branch $1 --verbose --depth 1
mkdir qt5compat-build && cd qt5compat-build
../installed-static/bin/qt-configure-module ../qt5compat/
cmake --build . --parallel
cmake --install .
cd ..
