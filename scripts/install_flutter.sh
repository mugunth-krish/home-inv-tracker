#!/usr/bin/env bash
set -e

# download flutter
git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter
echo "export PATH=\"$HOME/flutter/bin:$PATH\"" >> ~/.bashrc
export PATH="$HOME/flutter/bin:$PATH"

flutter doctor
