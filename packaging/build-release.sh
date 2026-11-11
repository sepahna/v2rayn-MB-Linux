#!/usr/bin/env bash
# Assemble a portable directory, a .tar.gz and an Ubuntu/Debian .deb.
# Usage: ./packaging/build-release.sh <publish-dir> <version> <output-dir>
set -euo pipefail

publish_dir=${1:?publish directory}
version=${2:?version}
out_dir=${3:?output directory}
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT

app="$stage/barani-core"
mkdir -p "$app/bin"
cp -a "$publish_dir"/. "$app/"
install -m 755 "$root/packaging/barani-core.sh" "$app/barani-core"
chmod +x "$app/v2rayN" || true

core_zip="$stage/core.zip"
if [ -n "${CORE_ZIP:-}" ] && [ -f "$CORE_ZIP" ]; then
  cp "$CORE_ZIP" "$core_zip"
else
  echo "Downloading core binaries..."
  curl -fL --retry 3 --retry-delay 2 -o "$core_zip" \
    "https://github.com/2dust/v2rayN-core-bin/raw/refs/heads/master/v2rayN-linux-64.zip"
fi
unzip -q "$core_zip" -d "$stage/core"
if [ -d "$stage/core/bin" ]; then
  cp -a "$stage/core/bin"/. "$app/bin/"
elif [ -d "$stage/core/v2rayN-linux-64/bin" ]; then
  cp -a "$stage/core/v2rayN-linux-64/bin"/. "$app/bin/"
else
  found=$(find "$stage/core" -type d -name bin | head -n 1)
  [ -n "$found" ]
  cp -a "$found"/. "$app/bin/"
fi
find "$app/bin" -type f -exec chmod +x {} + 2>/dev/null || true

mkdir -p "$out_dir"
tar -C "$stage" -czf "$out_dir/barani-core-linux-x64.tar.gz" barani-core

deb_root="$stage/deb"
mkdir -p \
  "$deb_root/opt" \
  "$deb_root/usr/bin" \
  "$deb_root/usr/share/applications" \
  "$deb_root/usr/share/icons/hicolor/256x256/apps" \
  "$deb_root/DEBIAN"
cp -a "$app" "$deb_root/opt/barani-core"
ln -s /opt/barani-core/barani-core "$deb_root/usr/bin/barani-core"
install -m 644 "$root/packaging/barani-core.desktop" "$deb_root/usr/share/applications/barani-core.desktop"
if [ -f "$app/v2rayN.png" ]; then
  install -m 644 "$app/v2rayN.png" "$deb_root/usr/share/icons/hicolor/256x256/apps/barani-core.png"
fi
installed_size=$(du -sk "$deb_root" | awk '{print $1}')
cat > "$deb_root/DEBIAN/control" <<EOF
Package: barani-core
Version: ${version}
Section: net
Priority: optional
Architecture: amd64
Maintainer: Barani Core <sepahna@users.noreply.github.com>
Installed-Size: ${installed_size}
Depends: libc6, libgcc-s1, libstdc++6, zlib1g, libfontconfig1, libfreetype6, libx11-6, libxrandr2, libxi6, libxcursor1, libxext6, libice6, libsm6, libgl1, libgtk-3-0 | libgtk-3-0t64, libdbus-1-3, ca-certificates, desktop-file-utils, xdg-utils
Description: Barani Core desktop client for Linux
 A self-contained v2rayN desktop build branded as Barani Core.
EOF
cat > "$deb_root/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e
chmod +x /opt/barani-core/v2rayN /opt/barani-core/barani-core || true
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database /usr/share/applications >/dev/null 2>&1 || true
fi
exit 0
EOF
chmod 755 "$deb_root/DEBIAN/postinst"
dpkg-deb --root-owner-group --build "$deb_root" "$out_dir/barani-core_${version}_amd64.deb"
echo "Wrote:"
ls -lh "$out_dir"
