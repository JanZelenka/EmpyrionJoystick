#Include %A_ScriptDir%\Outputs\COutput.class.ahk

class COutputKey Extends COutput {
	pressed := false
	pressString := ""
	releaseString := ""

	;BUILT IN METHODS
	__New( outputString ) {
		this.pressString := "{" . outputString . " down}"
		this.releaseString := "{" . outputString . " up}"
		}

	; CUSTOM METHODS
	press() {
		Send % this.pressString 
		this.pressed := true
		}

	release() {
		Send % this.releaseString
		this.pressed := false
		}
	}
