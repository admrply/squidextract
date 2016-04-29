#!/bin/bash
# Written by Adam Rapley
# A tool to carve data out of squid logs based on search terms
# Must be run from the squid cache directory
# Usage: ./squidextract.sh term-to-search-for

# Keeps terminal clean (suppresses warnings such as rm dir not found)
exec 2>squidextract.log
# Checks for command line args
if [[ $# -eq 0 ]]; then
  echo "Type the string to exract followed by [ENTER]"
  read string
else
  string=$@
fi

# Magic Numbers
jpg='ffd8'
gif='47494638'
png='89504e47'
html='3c21444f'

# Cleans the output directory
rm -r extracted

# Clones files which contain the searched for string
for path in `grep -rlh $string . | cut -d" " -f 1 | cut -c 3-`; do
  # Everything before the last / in the path
  folder=$(echo "$path" | rev | cut -d "/" -f 2- | rev)
  # Make folder structures
  mkdir -p extracted/raw/$folder
  mkdir -p extracted/reconstructed/$folder
  mkdir -p extracted/tmp/$folder
  cp -r ./$path extracted/raw/$path
  # Strip HTTP headers. They are separated by CRLFCRLF (0x0d0a0d0a)
  xxd -p extracted/raw/$path | tr -d '\n' | awk '{print substr($0,index($0,"0d0a0d0a")+8)}' > extracted/tmp/$path
  # Extract the magic numbers, some a 4 bytes, some are 8.
  magic=$(cat extracted/tmp/$path | cut -c1-8)
  magiccut=$(cat extracted/tmp/$path | cut -c1-4)
  # Append the correct file exts
  if [[ "$magiccut" = "$jpg" ]]; then
    xxd -r -p extracted/tmp/$path > extracted/reconstructed/$path.jpg
  elif [[ "$magic" = "$gif" ]]; then
    xxd -r -p extracted/tmp/$path > extracted/reconstructed/$path.gif
  elif [[ "$magic" = "$png" ]]; then
    xxd -r -p extracted/tmp/$path > extracted/reconstructed/$path.png
  elif [[ "$magic" = "$html" ]]; then
    xxd -r -p extracted/tmp/$path > extracted/reconstructed/$path.html
  else
    xxd -r -p extracted/tmp/$path > extracted/reconstructed/$path.unknownfile
  fi
  # Clean up
  rm extracted/tmp/$path
done
# More cleanup
rm -r extracted/tmp
