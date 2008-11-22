functor
import
   FD
   Search
   Explorer
%   Pattern at 'x-ozlib://anders/strasheela/Pattern/Pattern.ozf'
%   LUtils at 'x-ozlib://anders/strasheela/source/ListUtils.ozf'
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
      {ForAll Fingers proc {$ X} X :: [0 1 2 3 4] end}

      {IntonationFuncs.inMinorKey Pitches 69}
      Key = "\\key a \\minor"

      {IntonationFuncs.noFingeredFifths Strings Fingers}

      if (Interesting) then
	 {Nth Strings 1} =: 2
	 {Nth Fingers 1} =: 0
	 {IntonationFuncs.hasMinor Pitches 69}
	 {MinValues Strings Positions Fingers}
      end

      {FD.distribute
       ff {Append Pitches {Append Strings {Append Positions Fingers}}}}
   end

   proc {MinValues Strings Positions Fingers}
%      {IntonationFuncs.minChanges Strings 2}
      {IntonationFuncs.atLeast Strings 1 2}
      {IntonationFuncs.atLeast Strings 2 2}
      {IntonationFuncs.atMost Fingers 0 1}
      {IntonationFuncs.atMost Fingers 1 2}
      {IntonationFuncs.atMost Fingers 2 2}
      {IntonationFuncs.atMost Fingers 3 2}
      {IntonationFuncs.atMost Fingers 4 2}
   end

   NumNotes = 4
   BaseFilename='intonation/minor1/'
end
