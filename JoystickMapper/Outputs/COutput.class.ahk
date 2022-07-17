#Include %A_ScriptDir%\Outputs\COutputKey.class.ahk
#Include %A_ScriptDir%\Outputs\COutputMouseWheel.class.ahk

class COutput {
    outputString := ""

    ;BUILT IN METHODS
    __New( outputString ) {
        If ( SubStr( outputString, 1, 5 ) = "wheel" )
            result := New COutputMouseWheel( outputString )
        Else
            result:= New COutputKey( outputString )

        if ( result.outputString = "" )
            result.outputString := outputString

        Return result
        }
    }
