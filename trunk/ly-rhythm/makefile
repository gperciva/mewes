DESTDIR = ${HOME}

all:


install:
	cp gettiming.sh ${DESTDIR}/bin/
	cp collect-bars.py ${DESTDIR}/bin/

test:
	lilypond -dbackend=null unit_test_rhythms.ly > /tmp/timing.txt 2> /dev/null
	python collect-bars.py /tmp/timing.txt

clean:
	rm -f timing.txt

