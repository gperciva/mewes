%% ozmake -vm Makefile.oz

functor
import
   %% basic Oz stuff
   System Application Property
   %% novice 
   Open0
   Fingers12
   Fingers34
   String1

   %% beginner
   Minor1 
   Fifths1
   String2
   Minor2

   %% shifting
   Third1
   Shift1
   Shift2

define

   %% Show help message
   proc{ShowHelp M}
      {System.printError
       if M==unit then nil else "Command line option error: "#M#"\n" end#
       "Usage: "#{Property.get 'application.url'}#" [OPTIONS]\n"#
       "   -l --level <STRING>	Level name\n"#
       "   -v --view		View output (1) instead of writing files\n"#
       "   -b --boring		Disable \"interesting\" constraints.\n"
      }
      {Application.exit 0}
   end

   try
      %% Args is record of parsed commandline arguments 
      Args = {Application.getArgs record(
				     level(single char:&l type:string default:"none")
				     view(single char:&v type:bool default:false)
				     boring(single char:&b type:bool default:false)
				     help(single char:&h type:bool default:false)
				     )} 
   in
      if (Args.help==true) then
	 {ShowHelp unit}
      end	   


      if (Args.level == "none") then
	 {ShowHelp unit}
      elseif (Args.level == "open0") then
	 {Open0.doStuff Args.view Args.boring}
      elseif (Args.level == "fingers12") then
	 {Fingers12.doStuff Args.view Args.boring}
      elseif (Args.level == "fingers34") then
	 {Fingers34.doStuff Args.view Args.boring}
      elseif (Args.level == "string1") then
	 {String1.doStuff Args.view Args.boring}

      elseif (Args.level == "minor1") then
	 {Minor1.doStuff Args.view Args.boring}
      elseif (Args.level == "fifths1") then
	 {Fifths1.doStuff Args.view Args.boring}
      elseif (Args.level == "string2") then
	 {String2.doStuff Args.view Args.boring}
      elseif (Args.level == "minor2") then
	 {Minor2.doStuff Args.view Args.boring}

      elseif (Args.level == "third1") then
	 {Third1.doStuff Args.view Args.boring}
      elseif (Args.level == "shift1") then
	 {Shift1.doStuff Args.view Args.boring}
      elseif (Args.level == "shift2") then
	 {Shift2.doStuff Args.view Args.boring}
      end

      {Application.exit 0}

      %% handling of exceptions
   catch X then
      case X of quit then
	 {Application.exit 0}
      elseof error(ap(usage M) ...) then
	 {ShowHelp M}
	 {Application.exit 2}
      elseof E then
	 raise E end
      end
   end

end

