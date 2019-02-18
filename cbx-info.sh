#!/bin/bash
#cbxinfo -enc UTF-8 -meta
if [ $# -lt 4 ]
then
   echo "too few arguments" >&2
   exit 1
fi
if [ $3 == "-meta" ]
then
  fileCount=$(unrar lb "$4" | wc -l)
  echo -e "Pages:\t$fileCount"
fi
if [ $3 == "-l" ]
then
  filesInArchive=$(unrar lb "$5")
  count=1
  IFS=$'\n'
  for file in $(unrar lb "$5")
  do
      echo -e "Page\t$count size: $(unrar p "$5" "$file" -idq | identify -format "%[fx:w] x %[fx:h] px" - )"
      count=$(expr $count + 1)
  done
  #fileCount=$(unrar lb "$4" | wc -l)
  #echo -e "Pages:\t$fileCount"
  echo ""
fi

exit $?

