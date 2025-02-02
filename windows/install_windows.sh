 #!/bin/bash
# windows/install_windows.sh – Windows Development Tools Installer
# (Run this from Git Bash or another Unix‑like shell on Windows.)
# Make sure winget is installed and available in PATH.

# --- Terminal Enhancements Functions ---
# (zsh and oh‑my‑zsh are skipped on Windows.)

function install_zsh() {
    echo "Note: zsh and oh‑my‑zsh are not natively supported on Windows PowerShell. Skipping."
}

function install_starship() {
    if ! command -v starship >/dev/null 2>&1; then
      echo "Installing starship..."
      winget install --id Starship.Starship -e --silent
    else
      echo "starship is already installed."
    fi
    update_powershell_profile "starship" "Invoke-Expression (&starship init powershell)"
}

function install_fzf() {
    if ! command -v fzf >/dev/null 2>&1; then
      echo "Installing fzf..."
      winget install --id junegunn.fzf -e --silent
    else
      echo "fzf is already installed."
    fi
}

function install_zoxide() {
    if ! command -v zoxide >/dev/null 2>&1; then
      echo "Installing zoxide..."
      winget install --id Romkatv.Zoxide -e --silent
    else
      echo "zoxide is already installed."
    fi
    update_powershell_profile "zoxide" 'if (Get-Command zoxide -ErrorAction SilentlyContinue) { zoxide init powershell | Invoke-Expression }'
}

# --- Development Environment Functions ---

function install_nvm_and_node() {
    # For Windows, we use nvm‑windows
    if ! command -v nvm >/dev/null 2>&1; then
      echo "Installing nvm‑windows..."
      winget install --id nvm-windows.nvm -e --silent
    else
      echo "nvm is already installed."
    fi
    if ! command -v node >/dev/null 2>&1; then
      echo "Installing latest Node.js via nvm..."
      nvm install latest
      nvm use latest
    else
      echo "Node.js is already installed."
    fi
}

function install_python_and_pip() {
    if ! command -v python >/dev/null 2>&1; then
      echo "Installing Python..."
      winget install --id Python.Python.3 -e --silent
    else
      echo "Python is already installed."
    fi
    # pip comes with Python
}

function install_docker() {
    if ! command -v docker >/dev/null 2>&1; then
      echo "Installing Docker Desktop..."
      winget install --id Docker.DockerDesktop -e --silent
    else
      echo "Docker is already installed."
    fi
}

function install_git() {
    if ! command -v git >/dev/null 2>&1; then
      echo "Installing Git..."
      winget install --id Git.Git -e --silent
    else
      echo "Git is already installed."
    fi
}

function install_vscode() {
    if ! command -v code >/dev/null 2>&1; then
      echo "Installing Visual Studio Code..."
      winget install --id Microsoft.VisualStudioCode -e --silent
    else
      echo "Visual Studio Code is already installed."
    fi
}

function install_pycharm() {
    # For PyCharm, we use the Community Edition
    # (A detailed check might require more work; here we simply run the install command if not already found.)
    if ! (cmd.exe /c "if exist \"%LOCALAPPDATA%\\JetBrains\\PyCharm Community Edition*\\bin\\pycharm64.exe\" (exit 0) else (exit 1)"); then
      echo "Installing PyCharm Community Edition..."
      winget install --id JetBrains.PyCharm.Community -e --silent
    else
      echo "PyCharm Community Edition is already installed."
    fi
}

# --- Helper Function to Update PowerShell Profile ---

function update_powershell_profile() {
    # $1 is a keyword, $2 is the line to add.
    local keyword="$1"
    local line="$2"
    local profile_path="$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
    if [ ! -d "$(dirname "$profile_path")" ]; then
      mkdir -p "$(dirname "$profile_path")"
    fi
    if [ ! -f "$profile_path" ]; then
      touch "$profile_path"
    fi
    if ! grep -q "$keyword" "$profile_path"; then
      echo "$line" >> "$profile_path"
      echo "Added $keyword initialization to PowerShell profile."
    else
      echo "$keyword initialization already present in PowerShell profile."
    fi
}

# --- Grouping Functions ---

function install_terminal_enhancements() {
    echo "Installing Terminal Enhancements..."
    install_zsh   # (This will simply output a note.)
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
      ["starship"]="starship"
      ["fzf"]="fzf"
      ["zoxide"]="zoxide"
      ["nvm"]="nvm"
      ["node"]="node"
      ["python"]="python"
      ["docker"]="docker"
      ["git"]="git"
      ["vscode"]="code"
      # (PyCharm check is omitted here.)
    )
    for tool in "${!tools[@]}"; do
      cmd=${tools[$tool]}
      if command -v $cmd >/dev/null 2>&1; then
         echo "$tool is installed."
      else
         echo "$tool is NOT installed."
      fi
    done
}

# --- Main Installer Menu ---

echo "Windows Development Tools Installer"
echo "Choose installation option:"
echo "1) Install All"
echo "2) Customize Installation (Choose Categories)"
read -rp "Enter choice [1-2]: " install_choice

case $install_choice in
  1)
    install_terminal_enhancements
    install_dev_environment
    ;;
  2)
    echo "Select categories to install (separated by space):"
    echo "1) Terminal Enhancements (starship, fzf, zoxide)"
    echo "2) Development Environment (nvm, node, python, docker, git, vscode, pycharm)"
    read -rp "Enter choices (e.g. 1 2): " -a categories
    for cat in "${categories[@]}"; do
      if [ "$cat" == "1" ]; then
         install_terminal_enhancements
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

echo "Please restart your PowerShell terminal to apply changes."
