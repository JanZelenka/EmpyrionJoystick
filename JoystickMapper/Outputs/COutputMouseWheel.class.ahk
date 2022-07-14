#Include %A_ScriptDir%\Outputs\COutput.class.ahk

class COutputMouseWheel Extends COutput {
	lastMove := 0
	watchCount := 0
	watchWheelFunction := {}

	;BUILT IN METHODS
	__New( outputString ) {
		this.watchWheelFunction := ObjBindMethod( this, "watchWheel" )
		}

	;CUSTOM METHODS
	moveWheel() {
		Click % this.outputString
		this.lastMove := A_TickCount
		}

	press() {
		this.moveWheel()
		this.watchCount := 1
		watchWheelFunction := this.watchWheelFunction
		SetTimer, % watchWheelFunction, 100
		}

	release() {
		watchWheelFunction := this.watchWheelFunction
		SetTimer, % watchWheelFunction, Delete
		}

	watchWheel() {
		If ( ++this.watchCount > 3 )
			this.moveWheel()
		}
	}
