 #!/bin/bash
# macos/install_macos.sh – macOS Development Tools Installer

# --- Terminal Enhancements Functions ---

function install_zsh() {
    if ! command -v zsh >/dev/null 2>&1; then
      echo "Installing zsh..."
      brew install zsh
    else
      echo "zsh is already installed."
    fi
}

function install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
      echo "Installing oh‑my‑zsh (unattended)..."
      sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
      if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting ]; then
          git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
      fi
      if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions ]; then
          git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
      fi
      if ! grep -q "zsh-syntax-highlighting" "$HOME/.zshrc"; then
          sed -i '' 's/plugins=(\(.*\))/plugins=(\1 zsh-syntax-highlighting zsh-autosuggestions)/' "$HOME/.zshrc"
      fi
    else
      echo "oh‑my‑zsh is already installed."
    fi
}

function install_starship() {
    if ! command -v starship >/dev/null 2>&1; then
      echo "Installing starship..."
      brew install starship
    else
      echo "starship is already installed."
    fi
    if ! grep -q "starship init zsh" "$HOME/.zshrc"; then
      echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
    fi
}

function install_fzf() {
    if ! command -v fzf >/dev/null 2>&1; then
      echo "Installing fzf..."
      brew install fzf
      # Optionally run the fzf install script to set up key bindings (non‑interactive):
      "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
    else
      echo "fzf is already installed."
    fi
}

function install_zoxide() {
    if ! command -v zoxide >/dev/null 2>&1; then
      echo "Installing zoxide..."
      brew install zoxide
    else
      echo "zoxide is already installed."
    fi
    if ! grep -q "zoxide init zsh" "$HOME/.zshrc"; then
      echo 'eval "$(zoxide init zsh --cmd cd)"' >> "$HOME/.zshrc"
    fi
}

# --- Development Environment Functions ---

function install_nvm_and_node() {
    if [ -z "$NVM_DIR" ]; then
      export NVM_DIR="$HOME/.nvm"
    fi
    if [ ! -d "$NVM_DIR" ]; then
      echo "Installing nvm..."
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
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

function install_python_and_pip() {
    if ! command -v python3 >/dev/null 2>&1; then
      echo "Installing python3..."
      brew install python
    else
      echo "python3 is already installed."
    fi
    # pip3 is included with Homebrew’s Python
}

function install_docker() {
    if ! command -v docker >/dev/null 2>&1; then
      echo "Installing Docker Desktop..."
      brew install --cask docker
      echo "Please launch Docker Desktop manually to finish setup."
    else
      echo "docker is already installed."
    fi
}

function install_git() {
    if ! command -v git >/dev/null 2>&1; then
      echo "Installing git..."
      brew install git
    else
      echo "git is already installed."
    fi
}

function install_vscode() {
    if ! command -v code >/dev/null 2>&1; then
      echo "Installing Visual Studio Code..."
      brew install --cask visual-studio-code
    else
      echo "Visual Studio Code is already installed."
    fi
}

function install_pycharm() {
    if [ -z "$(brew list --cask | grep pycharm-ce)" ]; then
      echo "Installing PyCharm Community Edition..."
      brew install --cask pycharm-ce
    else
      echo "PyCharm Community Edition is already installed."
    fi
}

# --- Grouping Functions ---

function install_terminal_tools() {
    echo "Installing Terminal Enhancements..."
    install_zsh
    install_oh_my_zsh
    install_starship
    install_fzf
    install_zoxide
}

function install_dev_environment() {
    echo "Installing Development Environment tools..."
    install_nvm_and_node
    install_python_and_pip
    install_docker
    install_git
    install_vscode
    install_pycharm
}

function check_installations() {
    echo "Verifying installations..."
    declare -A tools=(
      ["zsh"]="zsh"
      ["oh‑my‑zsh"]="~/.oh-my-zsh"
      ["starship"]="starship"
      ["fzf"]="fzf"
      ["zoxide"]="zoxide"
      ["nvm"]="nvm"
      ["node"]="node"
      ["python3"]="python3"
      ["docker"]="docker"
      ["git"]="git"
      ["code"]="code"
      ["pycharm"]="brew list --cask | grep pycharm-ce"
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
         if brew list --cask | grep -q pycharm-ce; then
            echo "PyCharm Community is installed."
         else
            echo "PyCharm Community is NOT installed."
         fi
      elif command -v $cmd >/dev/null 2>&1; then
         echo "$tool is installed."
      else
         echo "$tool is NOT installed."
      fi
    done
}

# --- Main Installer Menu ---

echo "macOS Development Tools Installer"
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
    echo "1) Terminal Enhancements (zsh, oh‑my‑zsh, starship, fzf, zoxide)"
    echo "2) Development Environment (nvm, node, python, docker, git, vscode, pycharm)"
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
