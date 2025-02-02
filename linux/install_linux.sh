#!/bin/bash
# linux/install_linux.sh – Linux Development Tools Installer (Universal Version)

# Request sudo privileges upfront.
sudo -v

# Keep-alive: update existing sudo timestamp until the script finishes.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# -------------------------------
# Detect Package Manager & Set Commands
# -------------------------------
if command -v apt >/dev/null 2>&1; then
    PM="apt"
    UPDATE_CMD="sudo apt update"
    INSTALL_CMD="sudo apt install -y"
    DOCKER_PKG="docker.io"
    PYTHON_PIP_PKG="python3-pip"
elif command -v dnf >/dev/null 2>&1; then
    PM="dnf"
    UPDATE_CMD="sudo dnf check-update"
    INSTALL_CMD="sudo dnf install -y"
    DOCKER_PKG="docker"
    PYTHON_PIP_PKG="python3-pip"
elif command -v yum >/dev/null 2>&1; then
    PM="yum"
    UPDATE_CMD="sudo yum check-update"
    INSTALL_CMD="sudo yum install -y"
    DOCKER_PKG="docker"
    PYTHON_PIP_PKG="python3-pip"
elif command -v pacman >/dev/null 2>&1; then
    PM="pacman"
    UPDATE_CMD="sudo pacman -Sy"
    INSTALL_CMD="sudo pacman -S --noconfirm"
    DOCKER_PKG="docker"
    PYTHON_PIP_PKG="python-pip"  # Arch Linux: Python 3 is "python"; pip is in "python-pip"
elif command -v zypper >/dev/null 2>&1; then
    PM="zypper"
    UPDATE_CMD="sudo zypper refresh"
    INSTALL_CMD="sudo zypper install -y"
    DOCKER_PKG="docker"
    PYTHON_PIP_PKG="python3-pip"
else
    echo "No supported package manager found on your system."
    exit 1
fi

echo "Detected package manager: $PM"
echo "Updating package lists..."
$UPDATE_CMD

# -------------------------------
# Terminal Enhancement Functions
# -------------------------------
install_zsh() {
    if ! command -v zsh >/dev/null 2>&1; then
        echo "Installing zsh..."
        $INSTALL_CMD zsh
    else
        echo "zsh is already installed."
    fi
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing oh-my-zsh (unattended)..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        # Install plugins for syntax highlighting and autosuggestions
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
        fi
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
        fi
        # Append plugins to .zshrc if not already present
        if ! grep -q "zsh-syntax-highlighting" "$HOME/.zshrc"; then
            sed -i "s/plugins=(\(.*\))/plugins=(\1 zsh-syntax-highlighting zsh-autosuggestions)/" "$HOME/.zshrc"
        fi
    else
        echo "oh-my-zsh is already installed."
    fi
}

install_starship() {
    if ! command -v starship >/dev/null 2>&1; then
        echo "Installing starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    else
        echo "starship is already installed."
    fi
    # Append starship initialization to .zshrc if missing
    if ! grep -q "starship init zsh" "$HOME/.zshrc"; then
        echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
    fi
}

install_fzf() {
    if ! command -v fzf >/dev/null 2>&1; then
        echo "Installing fzf..."
        $INSTALL_CMD fzf
    else
        echo "fzf is already installed."
    fi
}

install_zoxide() {
    if ! command -v zoxide >/dev/null 2>&1; then
        echo "Installing zoxide..."
        $INSTALL_CMD zoxide
    else
        echo "zoxide is already installed."
    fi
    # Append zoxide initialization to .zshrc if missing
    if ! grep -q "zoxide init zsh" "$HOME/.zshrc"; then
        echo 'eval "$(zoxide init zsh --cmd cd)"' >> "$HOME/.zshrc"
    fi
}

# -------------------------------
# Development Environment Functions
# -------------------------------
install_nvm_and_node() {
    if [ -z "$NVM_DIR" ]; then
        export NVM_DIR="$HOME/.nvm"
    fi
    if [ ! -d "$NVM_DIR" ]; then
        echo "Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
        # Load nvm into current shell session
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    else
        echo "nvm is already installed."
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
    if ! command -v node >/dev/null 2>&1; then
        echo "Installing latest Node.js via nvm..."
        nvm install node
    else
        echo "Node.js is already installed."
    fi
}

install_python_and_pip() {
    if ! command -v python3 >/dev/null 2>&1; then
        echo "Installing python3..."
        $INSTALL_CMD python3
    else
        echo "python3 is already installed."
    fi
    if ! command -v pip3 >/dev/null 2>&1; then
        echo "Installing pip3..."
        $INSTALL_CMD $PYTHON_PIP_PKG
    else
        echo "pip3 is already installed."
    fi
}

install_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        echo "Installing docker..."
        $INSTALL_CMD $DOCKER_PKG
        if command -v systemctl >/dev/null 2>&1; then
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo usermod -aG docker "$USER"
        else
            echo "systemctl not found; please start and enable docker manually if required."
        fi
    else
        echo "docker is already installed."
    fi
}

install_git() {
    if ! command -v git >/dev/null 2>&1; then
        echo "Installing git..."
        $INSTALL_CMD git
    else
        echo "git is already installed."
    fi
}

install_vscode() {
    if ! command -v code >/dev/null 2>&1; then
        echo "Installing Visual Studio Code..."
        if command -v snap >/dev/null 2>&1; then
            sudo snap install --classic code
        else
            echo "Snap is not installed. Please install Visual Studio Code manually."
        fi
    else
        echo "Visual Studio Code is already installed."
    fi
}

install_pycharm() {
    if command -v snap >/dev/null 2>&1; then
        if ! snap list | grep -q pycharm-community; then
            echo "Installing PyCharm Community Edition..."
            sudo snap install pycharm-community --classic
        else
            echo "PyCharm Community Edition is already installed."
        fi
    else
        echo "Snap is not installed. Please install PyCharm Community Edition manually."
    fi
}

# -------------------------------
# Grouping Functions
# -------------------------------
install_terminal_tools() {
    echo "Installing Terminal Enhancements..."
    install_zsh
    install_oh_my_zsh
    install_starship
    install_fzf
    install_zoxide
}

install_dev_environment() {
    echo "Installing Development Environment tools..."
    install_nvm_and_node
    install_python_and_pip
    install_docker
    install_git
    install_vscode
    install_pycharm
}

check_installations() {
    echo "Verifying installations..."
    declare -A tools=(
        ["zsh"]="zsh"
        ["oh-my-zsh"]="~/.oh-my-zsh"
        ["starship"]="starship"
        ["fzf"]="fzf"
        ["zoxide"]="zoxide"
        ["nvm"]="nvm"
        ["node"]="node"
        ["python3"]="python3"
        ["pip3"]="pip3"
        ["docker"]="docker"
        ["git"]="git"
        ["code"]="code"
        ["pycharm"]="snap list | grep pycharm-community"
    )
    for tool in "${!tools[@]}"; do
        cmd=${tools[$tool]}
        if [[ $cmd == "~/.oh-my-zsh" ]]; then
            if [ -d "$HOME/.oh-my-zsh" ]; then
                echo "$tool is installed."
            else
                echo "$tool is NOT installed."
            fi
        elif [[ $tool == "pycharm" ]]; then
            if command -v snap >/dev/null 2>&1 && snap list | grep -q pycharm-community; then
                echo "PyCharm Community Edition is installed."
            else
                echo "PyCharm Community Edition is NOT installed."
            fi
        elif command -v $cmd >/dev/null 2>&1; then
            echo "$tool is installed."
        else
            echo "$tool is NOT installed."
        fi
    done
}

# -------------------------------
# Main Installer Menu
# -------------------------------
echo "Linux Development Tools Installer"
echo "Choose installation option:"
echo "1) Install All"
echo "2) Customize Installation (Choose Categories)"
read -rp "Enter choice [1-2]: " install_choice

case $install_choice in
    1)
        install_terminal_tools
        install_dev_environment
        ;;
    2)
        echo "Select categories to install (separated by space):"
        echo "1) Terminal Enhancements (zsh, oh-my-zsh, starship, fzf, zoxide)"
        echo "2) Development Environment (nvm, node, python, pip, docker, git, vscode, pycharm)"
        read -rp "Enter choices (e.g. 1 2): " -a categories
        for cat in "${categories[@]}"; do
            if [ "$cat" == "1" ]; then
                install_terminal_tools
            elif [ "$cat" == "2" ]; then
                install_dev_environment
            else
                echo "Invalid category: $cat"
            fi
        done
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "Installation complete. Verifying installed tools..."
check_installations

echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
