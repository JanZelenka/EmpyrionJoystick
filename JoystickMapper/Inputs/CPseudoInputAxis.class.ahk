#Include %A_ScriptDir%\Inputs\CInputAxis.class.ahk
#Include %A_ScriptDir%\Inputs\CPressableInput.class.ahk

class CPseudoInputAxis extends CInputAxis {
	currentState := 0
	inputButton1 := {}
	inputButton2 := {}

	__New( inputString ) {
		if ( ! InStr( inputString, "," ) )
			throw Exception( 1001, "Pseudo axis definition: " . inputString, "This is not a valid pseudo-axis input definition" )

		Loop, Parse, inputString, `,
			this.inputButton%A_Index% := new CPressableInput( A_LoopField, %this%() )
		}

	Call() {
		; use A_ThisHotkey to determine the trigger.
		}
/*
	activate() {
		inputJoy1.activate()
		inputJoy2.activate()
		}

	deactivate() {
		inputJoy1.deactivate()
		inputJoy2.deactivate()
		}
*/
	getState() {
		return this.currentState
		}
	}
