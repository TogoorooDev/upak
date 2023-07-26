#! /bin/sh

echo "UPAK Packed File Creator"
read -p "Please Enter In File To Pack: " FILENAME

if test -f "$FILENAME"; then
  echo "Packing file: $FILENAME"
  cp "$FILENAME" obj/executable.tmp
  make
  make genclean

  echo "This should be complete"
fi