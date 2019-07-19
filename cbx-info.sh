#!/bin/bash
#cbxinfo -enc UTF-8 -meta
if [ $# -lt 4 ]
then
   echo "too few arguments" >&2
   exit 1
fi
cbxFileName="$4"
mime=$(file -ib "$cbxFileName")
case "$mime" in
  application/zip*)
    command="zipinfo -1"
    extractCommand="unzip -p"
    extractCommandSuffix=""
    #pageFileName=$(zipinfo -1 "$cbxFileName" |sort |head -n $pageNumber | tail -n 1)
    #unzip  "$cbxFileName" $pageFileName
    ;;
  application/x-rar*)
    command="unrar lb"
    extractCommand="unrar p"
    extractCommandSuffix="-idq"
    #pageFileName=$(unrar lb "$cbxFileName" | head -n $pageNumber | tail -n 1)
    #unrar p "$cbxFileName" $pageFileName -idq
    ;;
  *)
    echo unexpected mime $mime
    exit 1
    ;;
esac

    if [ $3 == "-meta" ]
    then
      fileCount=$($command "$cbxFileName" | wc -l)
      echo -e "Pages:\t$fileCount"
    fi
    if [ $3 == "-l" ]
    then
      filesInArchive=$($command "$cbxFileName" | cat)
      count=1
      OLDIFS=$IFS
      #IFS=$'\n'
          for file in $($command "$cbxFileName" | cat)
          do 
              IFS=$OLDIFS
              echo -e "Page\t$count size: $($extractCommand "$cbxFileName" "$file" $extractCommandSuffix | identify -format "%[fx:w] x %[fx:h] px" - )"
              count=$(expr $count + 1)
          done
      IFS=$OLDIFS
          #fileCount=$(unrar lb "$4" | wc -l)
          #echo -e "Pages:\t$fileCount"
      echo ""
    fi
    
    exit $?

