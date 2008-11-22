functor
import
   FD
   Search
   Explorer
   PitchFingers at 'x-ozlib://gperciva/pitchfingers/pitchfingers.ozf'
   IntonationFuncs at 'x-ozlib://gperciva/intonation-funcs/intonation-funcs.ozf'
%   Browser
export 
   doStuff: DoStuff
define
   Interesting
   proc {DoStuff View Boring}
      Interesting = {Not Boring}
      if (View) then
	 {Explorer.one GetEvents}
	 {Wait _}
      else
	 {ForAll
	  {Map
	   {Search.base.all GetEvents}
	   fun {$ X} {PitchFingers.toScoreDouble X.1 X.4 X.5} end}
	  proc {$ X} {PitchFingers.writeLilyFile BaseFilename X} end}
      end
   end

   %% actual level definition
   proc {GetEvents Sol}
      Pitches Strings Positions Fingers Key
   in
      Sol = Pitches#Strings#Positions#Fingers#Key
      {PitchFingers.setup NumNotes Pitches Strings Positions Fingers}
      %%
      {ForAll Strings proc {$ X} X :: [1 2] end}
      {IntonationFuncs.firstPos Positions}
      {ForAll Fingers proc {$ X} X :: [0 1 2] end}

      {IntonationFuncs.inMajorKey Pitches 69}
      Key = "\\key a \\major"

      {IntonationFuncs.changeToOpenString Strings Fingers}

      if (Interesting) then
	 {Nth Strings 1} =: 2
	 {Nth Fingers 1} =: 0
	 {MinValues Strings Positions Fingers}
      end

      {FD.distribute
       ff {Append Pitches {Append Strings {Append Positions Fingers}}}}
   end

   proc {MinValues Strings Positions Fingers}
      {IntonationFuncs.atLeast Fingers 1 1}
      {IntonationFuncs.atLeast Fingers 2 1}
   end

   NumNotes = 4
   BaseFilename='intonation/fingers12/'
end

