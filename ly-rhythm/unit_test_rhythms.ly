\version "2.13.0"
\include "getdurs.ly"

music = \relative c' {
  \partial 4. e8 d des
  \time 3/4
  c4 c c
  c4 c c
  <c g>2 <c f>4
  <c e>2 <c d>4
  \grace {e16 d} e2.
  \afterGrace f2. {e16 d}
} 

%\displayMusic \music 
\getDurations \music

