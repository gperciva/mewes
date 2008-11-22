functor
import
   FD
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
      %% actual level definition
      {RhythmFuncs.eventEvery Events BeatDivisions}
      {RhythmFuncs.noRests Events}
      {RhythmFuncs.beatsAllSame Durs BeatDivisions}

      if (Interesting) then
	 {RhythmFuncs.noTwoIdenticalAdjacentBeats Durs BeatDivisions}
	 {NumDurs Durs}
      end

      {FD.distribute ff {Append Events Durs}}
   end

   proc {NumDurs Durs}
      {RhythmFuncs.minDursOnBeats Durs BeatDivisions 1 2}
   end

   Beats=4
   BeatDivisions=4
   BaseFilename='rhythms/sixteen01/'
end
