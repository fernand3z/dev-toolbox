#!/bin/bash
# install.sh – Master installer

# Ensure all sub-scripts are executable.
chmod +x linux/install_linux.sh macos/install_macos.sh windows/install_windows.sh

echo "Select your operating system:"
echo "1) Linux"
echo "2) macOS"
echo "3) Windows"

read -rp "Enter choice [1-3]: " choice

case $choice in
  1)
    bash linux/install_linux.sh
    ;;
  2)
    bash macos/install_macos.sh
    ;;
  3)
    bash windows/install_windows.sh
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac
