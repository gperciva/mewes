functor
import
   FD
   Pattern at 'x-ozlib://anders/strasheela/Pattern/Pattern.ozf'
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
      {SixteenthsTogether Durs}

      if (Interesting) then
	 {RhythmFuncs.noTwoIdenticalAdjacentBeats Durs BeatDivisions}
	 {NumDurs Durs}
	 {HasEighthSixteenth Durs}
	 {NoEighthEighth Durs}
      end

      {FD.distribute ff {Append Events Durs}}
   end

   proc {SixteenthsTogether Durs}
      {ForAll
       {Pattern.adjoinedSublists Durs 2}
       proc {$ X}
	  {FD.equi
	   ( {Nth X 1} =: 1 )
	   ( {Nth X 2} =: 1 )
	   1}
       end}            
   end

   proc {HasEighthSixteenth Durs}
      {FD.sum
       {Map
	{Pattern.adjoinedSublists Durs BeatDivisions}
	fun {$ X}
	   {FD.disj
	    {FD.conj
	     {FD.conj
	      ( {Nth X 1} =: 1 )
	      ( {Nth X 2} =: 1 )
	     }
	     ({Nth X 3} =: 2)
	    }
	    {FD.conj
	     {FD.conj
	      ( {Nth X 3} =: 1 )
	      ( {Nth X 4} =: 1 )
	     }
	     ({Nth X 1} =: 2)
	    }
	   }
	end}
       '>=:' 1}
   end

   proc {NoEighthEighth Durs}
       {ForAll
	{Pattern.adjoinedSublists Durs BeatDivisions}
	proc {$ X}
	   {FD.conj
	     ( {Nth X 1} =: 2 )
	     ( {Nth X 3} =: 2 )
	0}
	end}
   end

   proc {NumDurs Durs}
      {RhythmFuncs.minDurs Durs 1 6}
      {RhythmFuncs.minDurs Durs 2 2}
      {RhythmFuncs.minDursOnBeats Durs BeatDivisions 4 1}
   end

   Beats=4
   BeatDivisions=4
   BaseFilename='rhythms/sixteen02/'
end

