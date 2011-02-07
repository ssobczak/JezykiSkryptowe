#!/bin/tcsh

alias print_help 'echo "Ahuku application"; echo "Super cool help message!"'

foreach param ($*)
	if ("$param" == "-h" || "$param" == "--help") then 
		print_help
		exit 0
	endif
end

foreach param ($*)
	switch ("$param")
	case "-q": | --quiet)
		exit 0
	default:
		echo Unknown parameters!
		print_help
		exit 1;;
	endsw	
end

echo Akuku!
