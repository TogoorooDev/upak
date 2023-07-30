#! /bin/bash

# if [ "$1" = "--se" || "$2" == "--se" || "$3" == "--se" || "$4" = "--se" ];

if [ "$FILE" = "" ]; then
  FILE="upakbin"
fi

echo "UPAK Packed File Creator"
if [ "$1" != "" ]; then
  FILENAME="$1"
else
  read -p "Please Enter In File To Pack: " FILENAME
fi

if [ "$2" = "--secure" ] || [ "$3" = "-s" ]; then
  ENCRYPTION=1
  SE=" -DSECURITY_ENHANCED "
  echo "Security Enhanced Binary"
  read -p "Enter encryption passphrase: " -s PASSWORD
  printf "\n$PASSWORD\n"
fi

if [ "$3" = "--quiet" ] || [ "$3" = "-q" ]; then
  SE+=" -DQUIET "
  echo "Quiet Binary"
fi

test -d "obj" || mkdir obj


if test -f "$FILENAME"; then
  echo "Packing file: $FILENAME"
  # cp "$FILENAME" obj/executable.
  
  if [ "$4" = "--no-compress" ] || [ "$4" = "-n" ]; then
    C=" -DNO_COMPRESS "
    cp "$FILENAME" obj/executable.tmp
  else
    zstd "$FILENAME" -o obj/executable.tmp
  fi
  FILE="$FILE" CFLAGS="$SE $C" make

  UNPAKFS=$(stat --printf="%s" obj/executable.tmp)
  PAKFS=$(stat --printf="%s" "$FILE")

  if [ $PAKFS -gt $UNPAKFS ]; then
    echo "NOTICE: Packed file is larger than unpacked file"
  fi

  make genclean

  echo "This should be complete"

else 
  echo "$FILENAME does not exist..."
fi

