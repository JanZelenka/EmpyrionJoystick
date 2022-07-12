class COutputKey {
	outputString := ""
	pressed := false
	pressString := ""
	releaseString := ""

	;BUILT IN METHODS
	__New( outputString ) {
		this.outputString := outputString
		this.pressString := "{" . this.outputString . " down}"
		this.releaseString := "{" . this.outputString . " up}"
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
