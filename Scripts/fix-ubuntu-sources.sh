#!/usr/bin/env bash
set -e

echo "==> Fixing Ubuntu APT sources (clean + multi-mirror)"

# Require root
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo)"
  exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

APT_DIR="/etc/apt"
SOURCES_D="$APT_DIR/sources.list.d"
UBUNTU_SOURCES="$SOURCES_D/ubuntu.sources"

# Backup existing ubuntu.sources if it exists
if [[ -f "$UBUNTU_SOURCES" ]]; then
  echo "==> Backing up existing ubuntu.sources"
  cp "$UBUNTU_SOURCES" "$UBUNTU_SOURCES.backup.$TIMESTAMP"
fi

# Backup legacy sources.list if it exists
if [[ -f "$APT_DIR/sources.list" ]]; then
  echo "==> Backing up legacy sources.list"
  cp "$APT_DIR/sources.list" "$APT_DIR/sources.list.backup.$TIMESTAMP"
fi

echo "==> Writing clean ubuntu.sources"

cat > "$UBUNTU_SOURCES" <<'EOF'
Types: deb
URIs:
  http://ir.archive.ubuntu.com/ubuntu/
  http://ftp.fau.de/ubuntu/
  http://mirror.nl.leaseweb.net/ubuntu/
  http://ftp.linux.org.tr/ubuntu/
  http://security.ubuntu.com/ubuntu/
Suites: questing questing-updates questing-backports questing-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

echo "==> Updating package lists"
apt update

echo "==> Done. Sources are clean, backed up, and warning-free."
