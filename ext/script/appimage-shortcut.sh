#!/bin/sh

sed -i 's/fmt::format("flatpak run {}", env_flatpak_id)/env_appimage/g' citra_qt/citra_qt.cpp
sed -i 's/env_flatpak_id/env_appimage/g' citra_qt/citra_qt.cpp
sed -i 's/FLATPAK_ID/APPIMAGE/g' citra_qt/citra_qt.cpp
