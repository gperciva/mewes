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
      {RhythmFuncs.eventEvery Events 2*BeatDivisions}
      {RhythmFuncs.restsOnlyOnBeats Events BeatDivisions}
      {AllowedDurs Durs}

      if (Interesting) then
	 {RhythmFuncs.noTwoIdenticalAdjacentBeats Durs BeatDivisions}
	 {RhythmFuncs.noAdjacentRests Events Durs}
   	 {NoSecondOrFourthBeats Durs}
	 {NumNotes Events Durs}
      end

      {FD.distribute ff {Append Events Durs}}
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


   proc {NoSecondOrFourthBeats Durs}
       {Nth Durs 5} =: 0
       {Nth Durs 13} =: 0
   end

   proc {NumNotes Events Durs}
      {RhythmFuncs.minDurs Events 2 1}
      {RhythmFuncs.minDurs {LUtils.butLast Events} 1 3}
      {RhythmFuncs.maxDurs Durs 4 1}
      {RhythmFuncs.maxDurs Durs 3 2}
      {RhythmFuncs.maxDurs Durs 2 1}
      {RhythmFuncs.maxDurs Durs 1 1}
      {RhythmFuncs.minDurs Durs 1 1}
%      {FD.sum {Map Durs fun {$ X} (X >: 2) end} '=:' 1}
   end

   Beats=4
   BeatDivisions=4
   BaseFilename='rhythms/long02/'
end

