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
   {EventOnEveryTwoBeats Events}
   {AllowedDurs Durs}
   %%
   {HasLongNote Durs}
   {ExtraStuff Events Durs}

   
   {FD.distribute ff {Append Events Durs}}
end

proc {EventOnEveryTwoBeats Events}
   {ForAll {LUtils.everyNth Events 2*BeatDivisions}
    proc {$ X}
       X \=: 0
    end}
end

% quarter divided in 4
% therefore
% 2 = 8   = 1/2
% 4.. = 7  = 7/16
% 4. = 6   = 3/8
% 4 =  4  = 1/4
% 8. = 3  = 3/16
% 8 =  2   = 1/8
% 16 =  1   = 1/16

proc {AllowedDurs Durs}
   {ForAll Durs proc {$ X} X :: [0 1 2 3 4 6 7 8] end}
   %% only allow long durs that begin or end a twobeat
   {ForAll
    {Pattern.adjoinedSublists Durs 2*BeatDivisions}
    proc {$ TwoBeat}
       {List.forAllInd
	TwoBeat
	proc {$ I X}
	   if {And (I \= 1) (I \=2)} then
	      X \=: 7
	   end
	   if {And (I \= 1) (I \=3)} then
	      X \=: 6
	   end
	end}
    end}
end



%%  one note longer than a beat
proc {HasLongNote Durs}
      {FD.sum {Map Durs fun {$ X} (X >: 4) end} '=:' 2}
end

%% at least three rests
%% at least eight notes
%% at least 8 sixteenth durs
proc {ExtraStuff Events Durs}
   {FD.sum {Map Events fun {$ X} (X =: 2) end} '>=:' 3}
   {FD.sum {Map Events fun {$ X} (X =: 1) end} '>=:' 8}
   {FD.sum {Map Durs fun {$ X} (X =: 1) end} '>=:' 8}
end

Beats=8
BeatDivisions=4
BaseFilename='rhythms/hard01/'
end

