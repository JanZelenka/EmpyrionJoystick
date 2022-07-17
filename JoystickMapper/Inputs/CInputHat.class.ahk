#Include %A_ScriptDir%\Inputs\CInputPressable.class.ahk
#Include %A_ScriptDir%\Watchers\CHatWatcher.class.ahk

class CInputHat extends CInputPressable {
    hatWatcher := ""
    pressed := false

    __New( inputString ) {
        this.inputString := inputString
        }

    activate() {
        this.hatWatcher := New CHatWatcher( this )
        this.active := true
        }

    deactivate() {
        this.hatWatcher.removeHatButton( this )
        this.hatWatcher := ""
        this.active := false
        }

    getState() {
        return this.pressed
        }
    }
