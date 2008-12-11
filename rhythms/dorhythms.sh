#!/bin/sh
TEMPDIR=/tmp/rhythms
rm -rf $TEMPDIR
mkdir -p $TEMPDIR

BEGINNER="quarter00 eighth01 sixteen01 sixteen02 rest01 long01"
MODERATE="triplet01 triplet02 triplet03 rest02 long02"

ozmake
for lvl in $BEGINNER $MODERATE
do
  mkdir -p "$TEMPDIR/$lvl"
  ./rhythms.exe -l $lvl
done

