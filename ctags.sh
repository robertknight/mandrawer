#!/bin/sh

# Invokes ctags with my preferred additional
# options

# Add tags for basenames of files (f)
# and qualified class names (q)
EXTRA_FIELDS=fq

ctags --recurse --extra=+$EXTRA_FIELDS
