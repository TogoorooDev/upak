#! /bin/bash

usage () {
  echo "usage: ./pack.sh FILENAME --se|--standard --quiet|--loud --no-compress|-compress"

  echo "FILENAME: Path to executable to pack"
  echo ""
  
  echo "--se: Security Enahnced Binary. Blocks ptrace calls and encrypts the executable (ENCRYPTION NOT IMPLEMENTED)"
  echo "--standard: Standard Security Binary. None of these features"
  
  echo ""
  
  echo "--quiet: Disables logging, but keeps error messages"
  echo "--loud: Enables debug logging and error messages"

  echo ""
  
  echo "--no-compress: Disables ZSTD compression of executable"
  echo "--compress: Enables ZSTD compression of executable"

  echo ""

  exit 0;
}
  
echo "UPAK Packed File Creator"

if [ "$1" != "" ]; then  
  FILENAME="$1"
else
  usage
fi

if [ "$2" = "--se" ]; then
  ENCRYPTION=1
  SE=" -DSECURITY_ENHANCED "
  echo "Security Enhanced Binary"
  read -p "Enter encryption passphrase: " -s PASSWORD
  printf "\n$PASSWORD\n"

elif [ "$2" = "--standard" ]; then
    ENCRYPTION=0
    SE=""
    echo "Standard Security Binary"

else
  usage
fi

if [ "$3" = "--quiet" ]; then
  SE+=" -DQUIET "
  echo "Quiet Binary"
elif [ "$3" = "--loud" ]; then
  echo "Loud Binary"
else 
  usage
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


