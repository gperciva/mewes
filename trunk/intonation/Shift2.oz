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
      {ForAll Strings proc {$ X} X :: [1 2] end}
      {ForAll Positions proc {$ X} X :: [2 5] end}
      {ForAll Fingers proc {$ X} X :: [0 1 2 3 4] end}

      {IntonationFuncs.inMajorKey Pitches 69}
      Key = "\\key a \\major"

      {IntonationFuncs.thirdPositionNoStretchBack Pitches Positions Fingers}

      if (Interesting) then
	 {Nth Strings 1} =: 2
	 {Nth Fingers 1} =: 0
%	 {Nth Positions 1} =: 2
 {NoDownShiftTo Fingers Positions 3}
 {NoDownShiftTo Fingers Positions 4}
	 {NoSameFingerShift Fingers Positions Strings}
	 {MinValues Strings Positions Fingers}
      end

      {FD.distribute
       ff {Append Pitches {Append Strings {Append Positions Fingers}}}}
   end

   proc {MinValues Strings Positions Fingers}
      {IntonationFuncs.atMost Fingers 0 1}
      %{IntonationFuncs.minChanges Positions 2}
      {IntonationFuncs.atLeast Positions 2 2}
      {IntonationFuncs.atLeast Positions 5 2}
   end

   proc {NoDownShiftTo Fingers Positions Number}
      for X in 1..({Length Fingers}-1) do
%         FA = {Nth Fingers X}
         FB = {Nth Fingers X+1}
         PA = {Nth Positions X}
         PB = {Nth Positions X+1}
      in
	 {FD.impl
	  (PB <: PA)
	  (FB \=: Number)
	 1}
      end
   end

   proc {NoSameFingerShift Fingers Positions Strings}
      for X in 1..({Length Fingers}-1) do
         FA = {Nth Fingers X}
         FB = {Nth Fingers X+1}
         PA = {Nth Positions X}
         PB = {Nth Positions X+1}
	 SA = {Nth Strings X}
	 SB = {Nth Strings X+1}
      in
	 {FD.impl
	  (PA \=: PB)
	  {FD.conj
	   (FA \=: FB)
 	   (SA \=: SB)}
	 1}
      end
   end

   NumNotes = 4
   BaseFilename='intonation/shift2/'
end

