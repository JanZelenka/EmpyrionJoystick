#Include %A_ScriptDir%\Inputs\CPressableInput.class.ahk

class CInputHat extends CPressableInput {
	pressed := false

	__New() {
		this.inputString := inputString
		}

	activate() {
		active := true
		}

	deactivate() {
		active := false
		}

	getState() {
		return pressed
		}
	}
