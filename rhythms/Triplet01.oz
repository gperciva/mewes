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
   Pattern at 'x-ozlib://anders/strasheela/Pattern/Pattern.ozf'
   LUtils at 'x-ozlib://anders/strasheela/source/ListUtils.ozf'
   Search
   Explorer
   EventDurs at 'x-ozlib://gperciva/eventdurs/eventdurs.ozf'
   RhythmFuncs at 'x-ozlib://gperciva/rhythm-funcs/rhythm-funcs.ozf'
export 
   doStuff: DoStuff
define
   Interesting
   Events
   proc {DoStuff View Boring}
      Interesting = {Not Boring}
      if (View) then
	 {Explorer.one GetEvents}
	 {Wait _}
      else
	 Events = {Search.base.all GetEvents}
	 {ForAll
	  {Map
	   Events
	   fun {$ X} {EventDurs.toScoreDouble X BeatDivisions} end}
	  proc {$ X}
	     {EventDurs.writeLilyFile BaseFilename BeatDivisions X} end}
         {ForAll Events proc {$ X}
              {EventDurs.writeOnsetFile BaseFilename X}
            end
        }
      end
   end

   %% actual level definition
   proc {GetEvents Sol}
      Durs Events
   in
      Sol = Events#Durs
      %% setup defines the Event and Durs list
      {EventDurs.setup Beats BeatDivisions Events Durs} 
      %% actual level definition
      {RhythmFuncs.eventEvery Events BeatDivisions}
      {RhythmFuncs.noRests Events}
      {RhythmFuncs.beatsAllSame Durs BeatDivisions}
      {TripletOrDupleOrQuarter Durs}

      if (Interesting) then
	 {HasAdjacentTwoThree Durs}
	 {NumDurs Durs}
      end

      {FD.distribute ff {Append Events Durs}}
   end

   proc {TripletOrDupleOrQuarter Durs}
      {ForAll Durs proc {$ X} X :: [0 2 3 6] end}
   end


   proc {NumDurs Durs}
      {RhythmFuncs.minDursOnBeats Durs BeatDivisions 2 2}
      {RhythmFuncs.minDursOnBeats Durs BeatDivisions BeatDivisions 1}
   end

   proc {HasAdjacentTwoThree Durs}
      {FD.sum
       {Pattern.mapNeighbours
	{LUtils.everyNth Durs BeatDivisions 0}
	2
	fun {$ X}
	   X1 = X.1
	   X2 = {Nth X.2 1}
	in
	   {FD.disj
	    {FD.conj
	     (X1 =: 2)
	     (X2 =: 3)
	    }
	    {FD.conj
	     (X2 =: 2)
	     (X1 =: 3)
	    }
	   }
	end}
       '>=:' 1}
   end

   Beats=4
   BeatDivisions=6
   BaseFilename='rhythms/triplet01/'
end
