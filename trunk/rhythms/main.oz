%% ozmake -vm Makefile.oz

functor
import
   %% basic Oz stuff
   System Application Property
   %% beginner
   Quarter00
   Eighth01
   Sixteen01
   Sixteen02
   Rest01
   Long01
   %% moderate
   Triplet01
   Triplet02
   Triplet03
   Rest02
   Long02

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
      elseif (Args.level == "quarter00") then
	 {Quarter00.doStuff Args.view Args.boring}
      elseif (Args.level == "eighth01") then
	 {Eighth01.doStuff Args.view Args.boring}
      elseif (Args.level == "sixteen01") then
	 {Sixteen01.doStuff Args.view Args.boring}
      elseif (Args.level == "sixteen02") then
	 {Sixteen02.doStuff Args.view Args.boring}
      elseif (Args.level == "rest01") then
	 {Rest01.doStuff Args.view Args.boring}
      elseif (Args.level == "long01") then
	 {Long01.doStuff Args.view Args.boring}

      elseif (Args.level == "triplet01") then
	 {Triplet01.doStuff Args.view Args.boring}
      elseif (Args.level == "triplet02") then
	 {Triplet02.doStuff Args.view Args.boring}
      elseif (Args.level == "triplet03") then
	 {Triplet03.doStuff Args.view Args.boring}
      elseif (Args.level == "rest02") then
	 {Rest02.doStuff Args.view Args.boring}
      elseif (Args.level == "long02") then
	 {Long02.doStuff Args.view Args.boring}
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

