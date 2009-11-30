echo "Please wait for lilypond to analyze the file"
lilypond -dbackend=null $1 > /tmp/timing.txt 2> /dev/null
$HOME/bin/collect-bars.py /tmp/timing.txt

