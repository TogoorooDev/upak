#! /bin/sh

echo "UPAK Packed File Creator"
if [ "$1" != "" ]; then
  FILENAME="$1"
else
  read -p "Please Enter In File To Pack: " FILENAME
fi

test -d "obj" || mkdir obj

if test -f "$FILENAME"; then
  echo "Packing file: $FILENAME"
  cp "$FILENAME" obj/executable.tmp
  make
  make genclean

  echo "This should be complete"
fi