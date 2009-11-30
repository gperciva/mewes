all:
	lilypond -dbackend=null unit_test_rhythms.ly > timing.txt
	#lilypond -dbackend=null score.ly > timing.txt
	python collect-bars.py timing.txt

clean:
	rm -f timing.txt

