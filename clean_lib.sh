#!/bin/bash
#echo "Cleaning up lib/..."
#git rm -r --cached --staged lib/ -f >/dev/null 2>&1
#git rm -r --cached lib -f
#git restore --staged .gitmodules
#git add .gitmodules
#echo "Done!"

#!/bin/bash
echo "Ensuring lib/ is ignored before commit..."
git rm -r --cached lib/ -f >/dev/null 2>&1