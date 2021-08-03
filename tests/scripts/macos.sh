#!/usr/bin/env bash

# Dir which will contain all tests
TESTS_DIR="$HOME/tmp/docksal-tests"

# ---
yellow='\033[0;33m'
NC='\033[0m'

# Current script path
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
# Path of the checked out repo
DOCKSAL_REPO_PATH="$SCRIPT_PATH/../.."
# Emulate GITHUB_WORKSPACE
export GITHUB_WORKSPACE="$TESTS_DIR/build-dir"

# Output a message and exit. Analogue of perl's die function
die () {
	echo "$1"
	exit 1
}

# Warn about working dir
echo -e "${yellow}[Initialize]${NC}"
echo -e "Going to work in ${yellow}$TESTS_DIR${NC}"
echo -n "Press Enter to continue..."
read -p ""

set -euo pipefail

# Cleanup tests dir
rm -rf "$TESTS_DIR"
mkdir -p "$GITHUB_WORKSPACE"
cd "$GITHUB_WORKSPACE" || die "[Error] creating $GITHUB_WORKSPACE"

# Copy over Docksal stacks
echo -e "Going to ${yellow}overwrite${NC} current branch development stacks over home dir stacks."
echo -n "Press Enter to continue..."
read -p ""
cp "$DOCKSAL_REPO_PATH/stacks/"*".yml" "$HOME/.docksal/stacks" || die "[Error] copying stacks"

# Override bats binary
# NOTE: you can run interactively for debug
cat << EOF > "$TESTS_DIR/bats"
#!/usr/bin/env bash
# NOTE: To debug tests add -i switch here for interactivity
"${GITHUB_WORKSPACE}/tests/scripts/bats/bin/bats" "\$@"
EOF
chmod +x "$TESTS_DIR/bats"
export PATH="$TESTS_DIR:$PATH"

# Use fin version from repo
export PATH="$DOCKSAL_REPO_PATH/bin:$PATH"

# Copy over test files
cp -R "$DOCKSAL_REPO_PATH/tests" "$GITHUB_WORKSPACE/" || die "[Error] copying $DOCKSAL_REPO_PATH/tests to $GITHUB_WORKSPACE/"

# Install bats
echo "Installing bats..."
git clone https://github.com/docksal/bats.git tests/scripts/bats --quiet

# Run
echo
echo -e "${yellow}[Pre-test rundown]${NC}"
echo "  bats: $(which bats) - $(bats -v)"
echo "  fin: $(fin -v)"
echo
sleep 3

echo -e "${yellow}[Running Project tests]${NC}"
tests/scripts/project.sh
tests/scripts/config.sh
tests/scripts/db.sh
tests/scripts/system.sh
tests/scripts/commands.sh

echo
echo -e "${yellow}[CLEANUP]${NC}"
echo "TESTS HAVE FINISHED"
echo -e "Going to remove: ${yellow}$TESTS_DIR${NC}"
echo "Press Enter to continue..."
read -p ""
rm -rf "$TESTS_DIR"
fin cleanup
