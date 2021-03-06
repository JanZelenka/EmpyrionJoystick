#Include %A_ScriptDir%\Inputs\CInputPressable.class.ahk

class CInputButton extends CInputPressable {
    watchMethod := ""
    
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
        KeyWait % this.inputString
        this.onButtonReleased.Call()
        }
    }
