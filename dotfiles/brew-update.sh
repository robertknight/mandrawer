#!/bin/sh

# Synchronize installed Homebrew dependencies with the list in Brewfile.
#
# See https://github.com/Homebrew/homebrew-bundle.

set -eu

# Use Brewfile in same dir as this script
basedir=$(dirname "$0")
cd "$basedir"

brew bundle install
brew bundle cleanup --force
