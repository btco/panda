#!/bin/bash
if ! [ -f './tic.exe' ]; then
  echo "** TIC.EXE not found."
  exit 1
fi

if grep -q 'DBG=true' panda.lua; then
 echo "*** WARNING: Debug is ENABLED on this build."
 echo -n "Is this really what you want? (y/N)"
 read ans
 [ "$ans" != "y" ] && exit 1
fi

echo "Creating export cartridge."
cp -vf panda.tic panda-export.tic
echo "Injecting LUA code."
echo "panda-export.tic generated."
echo
echo "ATTENTION"
echo "We will now launch TIC. In TIC, use the EXPORT command to generate HTML."
echo "Call the file 'cartridge.html' and save to THIS DIRECTORY ($PWD)."
echo "Press ENTER"
read foo
rm -vf panda.html
./tic.exe panda-export.tic -code panda.lua 

if ! [ -f "cartridge.html" ]; then
 echo "*** cartridge.html not found."
 exit 1
fi

echo "Found cartridge.html."
echo "Injecting our HTML snippets..."
perl inject_html_snippets.pl <cartridge.html >panda.html

echo "Generated panda.html."

