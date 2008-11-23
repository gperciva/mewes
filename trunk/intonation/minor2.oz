/*
 MEWES - MEWsician's Exercise Selector
 Copyright (C) 2008  Graham Percival <graham@percival-music.ca>

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
      {ForAll Strings proc {$ X} X :: [3 4] end}
      {IntonationFuncs.firstPos Positions}
      {ForAll Fingers proc {$ X} X :: [0 1 2 3 4] end}

      {IntonationFuncs.inMinorKey Pitches 55}
      Key = "\\key g \\minor"

      if (Interesting) then
	 {Nth Strings 1} =: 4
	 {Nth Fingers 1} =: 0
	 {IntonationFuncs.hasMinor Pitches 55}
	 {MinValues Strings Positions Fingers}
      end

      {FD.distribute
       ff {Append Pitches {Append Strings {Append Positions Fingers}}}}
   end

   proc {MinValues Strings Positions Fingers}
%      {IntonationFuncs.minChanges Strings 2}
      {IntonationFuncs.atLeast Strings 3 2}
      {IntonationFuncs.atLeast Strings 4 2}
      {IntonationFuncs.atMost Fingers 0 1}
      {IntonationFuncs.atMost Fingers 1 2}
      {IntonationFuncs.atMost Fingers 2 2}
      {IntonationFuncs.atMost Fingers 3 2}
      {IntonationFuncs.atMost Fingers 4 2}
   end

   NumNotes = 4
   BaseFilename='intonation/minor2/'
end

