#Include %A_ScriptDir%\Inputs\CPressableInput.class.ahk

class CInputButton extends CPressableInput {
	; BUILT IN METHODS
	__New( inputString ) {
		this.inputString := inputString
		}

	; CUSTOM METHODS
	activate() {
		onButtonPressed := this.onButtonPressed
		HotKey, % this.inputString, % onButtonPressed
		active := true
		}

	deactivate() {
		HotKey, % this.inputString, Off
		active := false
		}

	getState() {
		return GetKeyState( this.inputString )
		}
	}
