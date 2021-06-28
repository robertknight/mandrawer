#!/usr/bin/env python

from __future__ import print_function

import argparse

parser = argparse.ArgumentParser("Placeholder text generator")
parser.add_argument(
    "bottles", type=int, action="store", help="Bottles of beer to drink"
)
parser.add_argument(
    "--no-newlines",
    action="store_false",
    dest="newlines",
    default=True,
    help="Omit new lines in output",
)
args = parser.parse_args()

if args.newlines:
    ending = "\n"
else:
    ending = " "

for i in range(args.bottles, 0, -1):
    print(
        "%d bottles of beer on the wall, %d bottles of beer. Take one down, pass it around, %d bottles of beer on the wall."
        % (i, i, i - 1),
        end=ending,
    )
