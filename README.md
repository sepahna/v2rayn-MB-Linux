# Barani Core برای لینوکس

این مخزن نسخهٔ دسکتاپ لینوکس [Barani Core](https://github.com/sepahna/v2rayn-MB) است. برنامه داخل خودش اجرا می‌شود و لازم نیست دات‌نت جدا نصب کنید. هسته‌های پروکسی هم داخل بسته هستند.

آخرین فایل‌ها:

- بستهٔ اوبونتو و دبیان: `barani-core_<نسخه>_amd64.deb`
- آرشیو عمومی: `barani-core-linux-x64.tar.gz`
- دستور ساخت آرچ: `PKGBUILD`

این بسته برای پردازندهٔ ۶۴بیتی معمولی (`x86_64` / `amd64`) است.

## اوبونتو، دبیان، لینوکس مینت، Pop!_OS و زورین

بستهٔ `.deb` را از [بخش Releases](https://github.com/sepahna/v2rayn-MB-Linux/releases) دانلود کنید، بعد:

```bash
sudo apt update
sudo apt install ./barani-core_7.25.8_amd64.deb
barani-core
```

`apt` کتابخانه‌های لازم را هم نصب می‌کند. میانبر **Barani Core** در منوی برنامه‌ها، بخش شبکه، ساخته می‌شود.

حذف:

```bash
sudo apt remove barani-core
```

تنظیمات در پوشهٔ `guiConfigs` کنار محل اجرا می‌ماند. در نصب بسته‌ای این پوشه این‌جاست:

`/opt/barani-core/guiConfigs`

## آرچ، مانجارو، EndeavourOS و CachyOS

اول کتابخانه‌های گرافیکی را نصب کنید، بعد برنامه را از آرشیو بسازید.

```bash
sudo pacman -Sy --needed fontconfig freetype2 libx11 libxrandr libxi libxcursor libxext libice libsm libgl gtk3 dbus ca-certificates xdg-utils base-devel
```

فایل `PKGBUILD` همین مخزن را بگیرید و بسازید:

```bash
curl -fL -o PKGBUILD https://raw.githubusercontent.com/sepahna/v2rayn-MB-Linux/master/packaging/PKGBUILD
makepkg -si
barani-core
```

`makepkg` آرشیو نسخهٔ `7.25.8` را دانلود و نصب می‌کند. برای نسخهٔ بعدی، مقدار `pkgver` داخل `PKGBUILD` را عوض کنید.

حذف:

```bash
sudo pacman -R barani-core
```

## فدورا، RHEL و توزیع‌های rpm

```bash
sudo dnf install fontconfig freetype libX11 libXrandr libXi libXcursor libXext libICE libSM mesa-libGL gtk3 dbus ca-certificates xdg-utils tar
curl -fL -o barani-core-linux-x64.tar.gz \
  https://github.com/sepahna/v2rayn-MB-Linux/releases/download/7.25.8/barani-core-linux-x64.tar.gz
sudo mkdir -p /opt
sudo tar -C /opt -xzf barani-core-linux-x64.tar.gz
sudo ln -sf /opt/barani-core/barani-core /usr/local/bin/barani-core
barani-core
```

## openSUSE

```bash
sudo zypper install fontconfig freetype2 gtk3 libX11-6 ca-certificates tar
```

اگر `zypper` نام یک بسته را نشناخت، با `zypper search نام` معادلش را پیدا کنید. بعد همان دستورهای `curl`، `tar` و `ln` بخش فدورا را اجرا کنید.

## اجرای بدون نصب، روی هر توزیع

اگر بستهٔ توزیع را نمی‌خواهید، فقط آرشیو را باز کنید:

```bash
tar -xzf barani-core-linux-x64.tar.gz
cd barani-core
./barani-core
```

اگر برنامه باز نشد، این کتابخانه‌ها را با مدیر بستهٔ همان توزیع نصب کنید: `fontconfig`، `freetype`، `libx11`، `libxrandr`، `libxi`، `libxcursor`، `libxext`، `libice`، `libsm`، `libgl`، `gtk3` و `dbus`.

پیام خطای کتابخانهٔ گم‌شده را با این دستور می‌بینید:

```bash
ldd ./v2rayN | grep 'not found'
```

## حالت TUN

پروکسی سیستم از داخل برنامه، بدون دسترسی ریشه کار می‌کند. حالت TUN کارت شبکهٔ مجازی می‌سازد و روی بیشتر توزیع‌ها به دسترسی مدیر نیاز دارد. در آن حالت برنامه را یک بار با `sudo -E barani-core` اجرا کنید، یا قابلیت شبکه را فقط به همان فایل بدهید:

```bash
sudo setcap cap_net_admin,cap_net_bind_service=+ep /opt/barani-core/v2rayN
```

## ساخت دوباره

سورس برنامه در [sepahna/v2rayn-MB](https://github.com/sepahna/v2rayn-MB) است. از تب Actions همین مخزن، workflow به نام **Release Linux** را اجرا کنید تا بستهٔ `.deb` و `.tar.gz` تازه ساخته شود.
