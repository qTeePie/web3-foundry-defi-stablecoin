#!/bin/bash
echo "Cleaning up lib/..."
git rm -r --cached lib/ >/dev/null 2>&1
echo "Done!"