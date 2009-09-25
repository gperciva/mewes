\version "2.12.0"

#(define (TimeSig? x)
  (eq? (ly:music-property x 'symbol) 'timeSignatureFraction))

#(define (durations music)
  (let ((es (ly:music-property music 'elements))
        (e (ly:music-property music 'element))
	(ml (ly:music-property music 'symbol))
        (d (ly:music-property music 'duration)))
    (if (pair? es)
       (ly:music-set-property!
         music 'elements
         (map (lambda (x) (durations x)) es)))
    (if (ly:music? e)
       (ly:music-set-property!
         music 'element
         (durations e)))
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
    music))

getDurations =
#(define-music-function (parser location m)
  (ly:music?)
  (durations m))



