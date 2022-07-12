#Include %A_ScriptDir%\Inputs\CInput.class.ahk
#Include %A_ScriptDir%\Inputs\CPseudoInputAxis.class.ahk
#Include %A_ScriptDir%\Inputs\CRealInputAxis.class.ahk

class CInputAxis extends CInput {
	isInverted := false

	__New( inputString ) {
		if ( ! InStr( inputString, "," ) )
			return New CRealInputAxis( inputString )
		else
			return := New CPseudoInputAxis( inputString )
		}
	}
