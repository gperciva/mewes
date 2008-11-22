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
      %%
      {RhythmFuncs.eventEvery Events BeatDivisions}
      {RhythmFuncs.noRests Events}

      {FD.distribute ff {Append Events Durs}}
   end

   Beats=4
   BeatDivisions=1
   BaseFilename='rhythms/quarter00/'
end

