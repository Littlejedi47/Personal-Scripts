#!/usr/bin/env bash

set -e

echo "🔧 Git automated setup for Linux"
echo "--------------------------------"

# Check for Git
if ! command -v git >/dev/null 2>&1; then
    echo "❌ Git is not installed."
    read -p "👉 Do you want me to install Git now? (y/n): " install_git
    if [[ "$install_git" =~ ^[Yy]$ ]]; then
        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt install -y git
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y git
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --noconfirm git
        else
            echo "⚠️ Package manager not detected. Install Git manually."
            exit 1
        fi
    else
        echo "Aborted."
        exit 1
    fi
fi

echo "✅ Git installed: $(git --version)"
echo

# User info
read -p "👤 Enter your Git username: " GIT_NAME
read -p "📧 Enter your Git email: " GIT_EMAIL

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# Sensible defaults
git config --global init.defaultBranch main
git config --global core.editor nano
git config --global color.ui auto
git config --global pull.rebase false

echo "✅ Git global config set"
echo

# SSH key setup
read -p "🔐 Do you want to generate an SSH key for GitHub/GitLab? (y/n): " gen_ssh

if [[ "$gen_ssh" =~ ^[Yy]$ ]]; then
    SSH_KEY="$HOME/.ssh/id_ed25519"

    if [[ -f "$SSH_KEY" ]]; then
        echo "⚠️ SSH key already exists at $SSH_KEY"
    else
        ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY"
        echo "✅ SSH key generated"
    fi

    # Start agent
    eval "$(ssh-agent -s)"
    ssh-add "$SSH_KEY"

    echo
    echo "📌 Your public SSH key (add this to GitHub/GitLab):"
    echo "-----------------------------------------------"
    cat "$SSH_KEY.pub"
    echo "-----------------------------------------------"
fi

echo
echo "🎉 Git setup completed successfully!"
echo "You can verify with: git config --list"
