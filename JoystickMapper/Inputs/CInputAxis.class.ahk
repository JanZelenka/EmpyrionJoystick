#Include %A_ScriptDir%\Inputs\CInput.class.ahk
#Include %A_ScriptDir%\Inputs\CInputPseudoAxis.class.ahk
#Include %A_ScriptDir%\Inputs\CInputRealAxis.class.ahk

class CInputAxis extends CInput {
    isInverted := false

    __New( inputString ) {
        if ( InStr( inputString, " " ) )
            return := New CInputPseudoAxis( inputString )
        else
            return New CInputRealAxis( inputString )
        }
    }
