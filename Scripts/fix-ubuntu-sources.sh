#!/usr/bin/env bash

set -e

echo "🔍 Detecting Ubuntu codename..."
CODENAME=$(lsb_release -sc)

echo "📦 Ubuntu codename detected: $CODENAME"
echo

SOURCES_FILE="/etc/apt/sources.list"
BACKUP_FILE="/etc/apt/sources.list.backup.$(date +%F_%H-%M-%S)"

echo "🗂 Backing up current sources.list to:"
echo "   $BACKUP_FILE"
sudo cp "$SOURCES_FILE" "$BACKUP_FILE"

echo
echo "✏️ Writing optimized sources.list ..."

sudo tee "$SOURCES_FILE" > /dev/null <<EOF
#############################################
# Optimized Ubuntu Sources
# Generated automatically
# Codename: $CODENAME
#############################################

# 🇹🇷 Turkey
deb http://ftp.linux.org.tr/ubuntu/ $CODENAME main restricted universe multiverse
deb http://ftp.linux.org.tr/ubuntu/ $CODENAME-updates main restricted universe multiverse
deb http://ftp.linux.org.tr/ubuntu/ $CODENAME-backports main restricted universe multiverse
deb http://ftp.linux.org.tr/ubuntu/ $CODENAME-security main restricted universe multiverse

# 🇩🇪 Germany (FAU)
deb http://ftp.fau.de/ubuntu/ $CODENAME main restricted universe multiverse
deb http://ftp.fau.de/ubuntu/ $CODENAME-updates main restricted universe multiverse
deb http://ftp.fau.de/ubuntu/ $CODENAME-backports main restricted universe multiverse
deb http://ftp.fau.de/ubuntu/ $CODENAME-security main restricted universe multiverse

# 🇷🇺 Russia (Yandex)
deb http://mirror.yandex.ru/ubuntu/ $CODENAME main restricted universe multiverse
deb http://mirror.yandex.ru/ubuntu/ $CODENAME-updates main restricted universe multiverse
deb http://mirror.yandex.ru/ubuntu/ $CODENAME-backports main restricted universe multiverse
deb http://mirror.yandex.ru/ubuntu/ $CODENAME-security main restricted universe multiverse

# 🇳🇱 Netherlands (Leaseweb)
deb http://mirror.nl.leaseweb.net/ubuntu/ $CODENAME main restricted universe multiverse
deb http://mirror.nl.leaseweb.net/ubuntu/ $CODENAME-updates main restricted universe multiverse
deb http://mirror.nl.leaseweb.net/ubuntu/ $CODENAME-backports main restricted universe multiverse
deb http://mirror.nl.leaseweb.net/ubuntu/ $CODENAME-security main restricted universe multiverse

# 🌐 Official Ubuntu CDN (fallback)
deb http://ir.archive.ubuntu.com/ubuntu/ $CODENAME main restricted universe multiverse
deb http://ir.archive.ubuntu.com/ubuntu/ $CODENAME-updates main restricted universe multiverse
deb http://ir.archive.ubuntu.com/ubuntu/ $CODENAME-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu/ $CODENAME-security main restricted universe multiverse
EOF

echo
echo "🔄 Updating package lists..."
sudo apt update

echo
echo "✅ Done!"
echo "🧾 Backup saved as:"
echo "   $BACKUP_FILE"
