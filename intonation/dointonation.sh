#!/bin/sh
TEMPDIR=/tmp/intonation
rm -rf $TEMPDIR
mkdir -p $TEMPDIR

NOVICE="open0 fingers12 fingers34 string1"
BEGINNER="minor1 fifths1 string2 minor2"
SHIFT="third1 shift1 shift2 shift3"

ozmake
for lvl in $NOVICE $BEGINNER $SHIFT
do
  mkdir -p "$TEMPDIR/$lvl"
  ./intonation.exe -l $lvl
done

for f in $TEMPDIR/minor2/*.ly
do
  ./make-minor.py $f
done

