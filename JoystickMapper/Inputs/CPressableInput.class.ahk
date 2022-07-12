#Include %A_ScriptDir%\Inputs\CInput.class.ahk
#Include %A_ScriptDir%\Inputs\CInputButton.class.ahk
#Include %A_ScriptDir%\Inputs\CInputHat.class.ahk


class CPressableInput extends CInput {
	active := false
	onButtonPressed := {}

	;BUILT IN METHODS
	__New( inputString , onButtonPressed ) {
		if ( InStr( inputString, "Hat" ) )
			result := New CInputHat( inputString )
		else
			result := New CInputButton( inputString )
			
		result.onButtonPressed := onButtonPressed
		return result
		}
	}
