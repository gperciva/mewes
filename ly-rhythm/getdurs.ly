\version "2.12.0"
\pointAndClickOff

% FIXME: prints double durs for chords
% FIXME: doesn't handle grace notes

#(define (TimeSig? x)
  (eq? (ly:music-property x 'symbol) 'timeSignatureFraction))

#(define (Timing? x)
  (eq? (ly:music-property x 'symbol) 'measurePosition))

#(define-public (music-property-value? music property value)
  "Return true iff MUSIC's PROPERTY is equal to VALUE."
  (equal? (ly:music-property music property) value))


#(define-public (music-name? music name)
  "Return true iff MUSIC's name is NAME."
  (if (list? name)
      (member (ly:music-property music 'name) name)
      (music-property-value? music 'name name)))

#(define (Chord? x)
  (music-name? x 'EventChord))

#(define (Grace? x)
  (music-name? x 'GraceMusic))

#(define (Simultaneous? x)
  (music-name? x 'SimultaneousMusic))

#(define (durations music)
  (let ((es (ly:music-property music 'elements))
        (e (ly:music-property music 'element))
	(ml (ly:music-property music 'symbol))
        (d (ly:music-property music 'duration)))
    (if (pair? es)
         ; only print one duration for chords
         (if (or (Chord? music)
	         (Simultaneous? music))
           (durations (car es))
           (ly:music-set-property!
              music 'elements
              (map (lambda (x) (durations x)) es))))
    (if (ly:music? e)
       ; don't do grace notes
       (if (not (Grace? music))
        (ly:music-set-property!
          music 'element
          (durations e))))
    (if (ly:duration? d)
       (begin
	 (display "d: ")
         (display (ly:duration->string d))
	 (display "\n")))
    (if (TimeSig? music)
       (begin
	 (display "t: ")
         (display (ly:music-property music 'value))
	 (display "\n")))
    (if (Timing? music)
       (begin
         (display "p: ")
         (display (ly:music-property music 'value))
	 (display "\n")))
    music))

getDurations =
#(define-music-function (parser location m)
  (ly:music?)
  (durations m))



