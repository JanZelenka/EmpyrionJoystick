#Include %A_ScriptDir%\Inputs\CInputAxis.class.ahk

class CInputRealAxis extends CInputAxis{
    __New( inputString ) {
        this.inputString := inputString
        
        if ( this.controlId = "R" || this.controlId = "Z"
            ; AHK reports these 2 axes reverted. 
            this.inverted := true
        }

    getState() {
        currentState := GetKeyState( this.inputString )
        return (
            this.reverted
            ? 100 - currentState 
            : currentState
            )
        }
    }
