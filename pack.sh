#! /bin/sh

echo "UPAK Packed File Creator"
if [ "$1" != "" ]; then
  FILENAME="$1"
else
  read -p "Please Enter In File To Pack: " FILENAME
fi

if [ "$2" != "" ]; then
  OUTPUT="$2"
else
  OUTPUT="package"
fi

test -d "obj" || mkdir obj

if test -f "$FILENAME"; then
  echo "Packing file: $FILENAME"
  zstd "$FILENAME" -o obj/executable.tmp
  FILE=$OUTPUT make 
  make genclean

  echo "This should be complete"
fi