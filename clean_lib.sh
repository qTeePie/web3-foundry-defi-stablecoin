#!/bin/bash
echo "Cleaning up lib/..."
make remove
make clean
git rm -r --cached lib/ >/dev/null 2>&1
echo "Done!"