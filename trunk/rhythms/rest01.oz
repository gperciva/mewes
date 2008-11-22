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
      {EventDurs.setup Beats BeatDivisions Events Durs} 
      %% level
      {RhythmFuncs.eventEvery Events BeatDivisions}
      {RhythmFuncs.restsOnlyOnBeats Events BeatDivisions}
      %% interesting
      if (Interesting) then
	 {RhythmFuncs.noAdjacentRests Events Durs}
	 {NumDurs Events Durs}
	 {RhythmFuncs.noThreeIdenticalAdjacentBeats Durs BeatDivisions}
      end

      {FD.distribute ff {Append Events Durs}}
   end


   proc {NumDurs Events Durs}
      % at least one r8 and r4
      {RhythmFuncs.atLeastTwin {LUtils.butLast Events} 2 Durs 2 1}
      {RhythmFuncs.atLeastTwin {LUtils.butLast Events} 2 Durs 1 1}
      % at least one c8 and c4
      {RhythmFuncs.atLeastTwin {LUtils.butLast Events} 1 Durs 2 1}
      {RhythmFuncs.atLeastTwin {LUtils.butLast Events} 1 Durs 1 1}
   end

   Beats=4
   BeatDivisions=2
   BaseFilename='rhythms/rest01/'
end

