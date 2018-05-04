#!/bin/sh

# Invokes ctags with my preferred additional
# options

# Add tags for basenames of files (f)
# and qualified class names (q)
EXTRA_FIELDS=fq

# Use `git ls-files` to only index source files in the repo.
git ls-files | ctags -L - --extra=+$EXTRA_FIELDS
