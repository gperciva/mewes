\version "2.12.0"

\include "getdurs.ly"

music = \relative c' { c4 d e8 f g4 \time 3/4 e4 c2 }

\score {
  \getDurations
    \new Staff {
%{
    \override Staff.BarLine #'stencil = #(lambda (grob)
         (display "|\n"))
    \override Staff.NoteColumn #'stencil = #(lambda (grob)
         (display "*\n"))
%}
    \music
  }
  \layout { }
}
