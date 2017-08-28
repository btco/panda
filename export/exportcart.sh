#!/bin/bash

if uname | grep -iq darwin; then
  TIC='/Applications/tic.app/Contents/MacOS/tic'
else
  TIC='../tic.exe'
fi

if ! [ -f "$TIC" ]; then
  echo "** not found: $TIC."
  exit 1
fi

echo "Creating export cartridge."
cp -vf ../source/panda.tic panda-export.tic
echo "Injecting LUA code."
echo "panda-export.tic generated."
echo
echo "ATTENTION"
echo "We will now launch TIC. In TIC, use the EXPORT command to generate HTML."
echo "Call the file 'cartridge.html' and save to THIS DIRECTORY ($PWD)."
echo "Press ENTER"
read foo
rm -vf panda.html
"$TIC" panda-export.tic -code ../source/panda.lua 

if ! [ -f "cartridge.html" ]; then
 echo "*** cartridge.html not found."
 exit 1
fi

echo "Found cartridge.html."
echo "Injecting our HTML snippets..."
perl inject_html_snippets.pl <cartridge.html >panda.html

echo "Generated panda.html."

