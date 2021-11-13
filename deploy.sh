#!/usr/bin/env sh
set -eu

trap "trap - TERM && kill -- -$$" INT TERM

case "$(uname -s)" in
	"Darwin") SCRIPT_PATH="$(readlink "$0")" ;;
	"FreeBSD") SCRIPT_PATH="$(readlink -f "$0")" ;;
	"Linux") SCRIPT_PATH="$(readlink -f "$0")" ;;
	*) echo "ERROR: Unknown OS type: ${OS_TYPE}. If you believe that our script should work on your machine, please let us know."; exit 1
esac

SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

cd "$SCRIPT_DIR"

CURRENT_VERSION="$(git rev-parse HEAD)"

echo "Pulling latest main version..."
git pull origin main -q

NEW_VERSION="$(git rev-parse HEAD)"

if [ -d "_site" ] && [ "$CURRENT_VERSION" = "$NEW_VERSION" ]; then
    echo "No deployment needed."
else
    echo "Installing jekyll and bundler..."
    gem install bundler jekyll -q --conservative --silent

    echo "Installing gems..."
    bundle install --quiet

    echo "Building website..."
    bundle exec jekyll build
fi

echo "All done! :3"
