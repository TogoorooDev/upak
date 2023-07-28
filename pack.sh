#! /bin/bash

echo "UPAK Packed File Creator"
if [ "$1" != "" ]; then
  FILENAME="$1"
else
  read -p "Please Enter In File To Pack: " FILENAME
fi

if [ "$2" = "--se" ]; then
  ENCRYPTION=1
  SE="-DSECURITY_ENHANCED"
  echo "Security Enhanced Binary"
  read -p "Enter encryption passphrase: " -s PASSWORD
  printf "\n$PASSWORD\n"
fi

test -d "obj" || mkdir obj

if test -f "$FILENAME"; then
  echo "Packing file: $FILENAME"
  # cp "$FILENAME" obj/executable.
  zstd "$FILENAME" -o obj/executable.tmp
  CFLAGS="$SE" make
  make genclean

  echo "This should be complete"
fi