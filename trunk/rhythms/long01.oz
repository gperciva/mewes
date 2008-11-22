functor
import
   FD
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
      if (Interesting) then
	 {RhythmFuncs.noTwoIdenticalAdjacentBeats Durs BeatDivisions}
	 {RhythmFuncs.noAdjacentRests Events Durs}
	 {HasLongOrTie Durs}
	 {NumNotes Events Durs}
      end

      {FD.distribute ff {Append Events Durs}}
   end



   proc {HasLongOrTie Durs}
      {FD.disj
       ({Nth Durs 3} =: 0)
       ({Nth Durs 7} =: 0)
       1}
   end

   proc {NumNotes Events Durs}
      {RhythmFuncs.minDurs Events 2 1}
      {RhythmFuncs.maxDurs Durs 1 2}
      {RhythmFuncs.minDurs {LUtils.butLast Events} 1 2}
   end


   Beats=4
   BeatDivisions=2
   BaseFilename='rhythms/long01/'
end

