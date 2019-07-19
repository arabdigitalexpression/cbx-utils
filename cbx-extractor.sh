# start with unrar

# file name by order then pass it to the the unrar command
# $PageNumber
shopt -s extglob
OPTIND=1
outputFile=""
verbose=0

while getopts "p:o:" opt; do
  case "$opt" in
    o)
      outputFile="$OPTARG"
      ;;
    p)
      pageNumber="$OPTARG"
      ;;
   esac
done
shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift
cbxFileName=$1

mime=$(file -ib "$cbxFileName")
case "$mime" in
  application/zip*)
    pageFileName=$(zipinfo -1 "$cbxFileName" |sort |head -n $pageNumber | tail -n 1)
    unzip  "$cbxFileName" $pageFileName 
    ;;
  application/x-rar*)
    pageFileName=$(unrar lb "$cbxFileName" | head -n $pageNumber | tail -n 1)
    unrar p "$cbxFileName" $pageFileName -idq
    ;;
  *)
    echo unexpected mime $mime
    exit 1
    ;;
esac
