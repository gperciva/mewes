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
      {TripletOrDupleOrQuarter Durs}

      if (Interesting) then
	 {RhythmFuncs.noTwoIdenticalAdjacentBeats Durs BeatDivisions}
	 {HasAdjacentTwoThree Durs}
	 {NumDurs Durs}
      end

      {FD.distribute ff {Append Events Durs}}
   end

   proc {TripletOrDupleOrQuarter Durs}
      {ForAll Durs proc {$ X} X :: [0 2 3 4 6] end}
   end


   proc {NumDurs Durs}
      {RhythmFuncs.minDurs Durs 4 1}
      {RhythmFuncs.minDurs Durs 2 3}
      {RhythmFuncs.minDurs Durs 3 1}
      {RhythmFuncs.minDursOnBeats Durs BeatDivisions BeatDivisions 1}
   end

   proc {HasAdjacentTwoThree Durs}
      {FD.sum
       {Pattern.mapNeighbours
	{LUtils.everyNth Durs BeatDivisions}
	2
	fun {$ X}
	   X1 = X.1
	   X2 = {Nth X.2 1}
	in
	   {FD.disj
	    {FD.conj
	     (X1 :: [2 4])
	     (X2 =: 3)
	    }
	    {FD.conj
	     (X2 :: [2 4])
	     (X1 =: 3)
	    }
	   }
	end}
       '>=:' 1}
   end

   Beats=4
   BeatDivisions=6
   BaseFilename='rhythms/triplet02/'
end
