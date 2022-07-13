#Include %A_ScriptDir%\Inputs\CPressableInput.class.ahk

class CInputHat extends CPressableInput {
	pressed := false

	__New( inputString ) {
		this.inputString := inputString
		}

	activate() {
		Global hatWatcher
		
		hatWatcher.addHatButton( this )
		this.active := true
		}

	deactivate() {
		Global hatWatcher
		
		hatWatcher.removeHatButton( this )
		this.active := false
		}

	getState() {
		return this.pressed
		}
	}
