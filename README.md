# Multi-Platform Development Tools Installer

This repository contains a multi-platform installer to help set up your development environment on **Linux**, **macOS**, and **Windows**. It installs a collection of terminal enhancements and development tools in a customizable way.

## Features

### Terminal Enhancements
- **zsh**
- **oh-my-zsh** with plugins (syntax highlighting and autosuggestions)
- **Starship Prompt** (with Nerd Font preset)
- **fzf**
- **zoxide** (initialized in `.zshrc` with `--cmd cd`)

### Development Environment Tools
- **nvm** and **Node.js**
- **Python** with **pip**
- **Docker**
- **Git**
- **Visual Studio Code**
- **PyCharm Community Edition**

### Customizable Installation
Choose to install all tools or select by categories:
1. Terminal Enhancements  
2. Development Environment Tools  

### Platform-Specific Installers
- **Linux:** Uses `apt` (Debian/Ubuntu based) and requests `sudo` privileges upfront.
- **macOS:** Uses [Homebrew](https://brew.sh/).
- **Windows:** Uses [winget](https://github.com/microsoft/winget-cli) and includes a batch file to request admin privileges when double-clicked.

## File Structure

```plaintext
project/
├── install.sh
├── linux/
│   └── install_linux.sh
├── macos/
│   └── install_macos.sh
└── windows/
    ├── install_windows.sh
    └── run_install_windows.bat
```

### File Descriptions
- **install.sh** - The master installer script. It sets executable permissions for all sub-scripts and prompts you to select your operating system, then launches the appropriate installer.
- **linux/install_linux.sh** - Installs development tools on Linux. It asks for `sudo` privileges at the beginning and maintains them during execution.
- **macos/install_macos.sh** - Installs development tools on macOS using Homebrew.
- **windows/install_windows.sh** - Installs development tools on Windows using `winget`. Intended to be run in a Bash environment (e.g., Git Bash).
- **windows/run_install_windows.bat** - A batch file wrapper that requests administrative privileges via UAC and then launches the Windows Bash installer.

## Prerequisites

### Linux
- A Debian/Ubuntu-based system (or similar) is assumed.
- `sudo` privileges are required.
- Internet connectivity for downloading packages.

### macOS
- [Homebrew](https://brew.sh/) must be installed.
- Internet connectivity for downloading packages.

### Windows
- A Bash environment (e.g., [Git Bash](https://gitforwindows.org/)) must be available.
- [winget](https://github.com/microsoft/winget-cli) must be installed.
- To run the installer with admin privileges, double-click `windows/run_install_windows.bat`.

## Usage

### Clone the Repository

```sh
git clone https://github.com/yourusername/your-repo.git
cd your-repo
```

### Run the Master Installer

The master installer (`install.sh`) automatically sets executable permissions for all sub-scripts. Before running, make it executable on macOS and Linux:

```sh
chmod +x install.sh
./install.sh
```

### Installation Options
You will be prompted to select your operating system and choose an installation option:
- **Install All** - Installs both terminal enhancements and development environment tools.
- **Customize Installation** - Allows you to choose one or both categories.

### Windows Users
Instead of running the Bash script directly, you can double-click the batch file:

1. Double-click `windows/run_install_windows.bat`.
2. This file will request administrative privileges and then launch the Windows installer.

## Customization

The installer scripts are organized by categories. When prompted, you can choose to install:
- **Category 1:** Terminal Enhancements
- **Category 2:** Development Environment Tools

Feel free to modify the scripts to add, remove, or adjust tools according to your personal setup.

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with any improvements or bug fixes.

## Disclaimer

These scripts are provided as examples. They may need adjustments to work correctly on your specific system or with different versions of the tools.

