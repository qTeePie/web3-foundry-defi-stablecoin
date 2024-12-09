#!/bin/bash
echo "Cleaning up lib/..."
git rm -r --cached --staged lib/ -f >/dev/null 2>&1
git restore --staged .gitmodules
git add .gitmodules
echo "Done!"