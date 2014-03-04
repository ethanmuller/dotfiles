function wreck() {
  pushd .

  WRECKDIR=`mktemp -d /tmp/wreckXXXXXXXXX` && {
    cd $WRECKDIR
  }
}
