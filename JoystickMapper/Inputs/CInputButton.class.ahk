#Include %A_ScriptDir%\Inputs\CPressableInput.class.ahk

class CInputButton extends CPressableInput {
	watchMethod := {}
	
	; BUILT IN METHODS
	__New( inputString ) {
		this.inputString := inputString
		this.watchMethod := ObjBindMethod( this, "watch" )
		}

	; CUSTOM METHODS
	activate() {
		watchMethod := this.watchMethod
		HotKey, % this.inputString, % watchMethod
		this.active := true
		}

	deactivate() {
		HotKey, % this.inputString, Off
		this.active := false
		}

	getState() {
		return GetKeyState( this.inputString )
		}
		
	watch() {
		if ( scriptDisabled() )
			return

		this.onButtonPressed.Call()

		while( this.getState() )
			Sleep 10

		this.onButtonReleased.Call()
		}
	}
