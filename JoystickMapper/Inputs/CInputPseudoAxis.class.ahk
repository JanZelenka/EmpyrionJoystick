#Include %A_ScriptDir%\Inputs\CInputAxis.class.ahk
#Include %A_ScriptDir%\Inputs\CInputPressable.class.ahk

class CInputPseudoAxis extends CInputAxis {
    currentState := 0
    inputButtonDown := ""
    inputButtonUp := ""

    __New( inputString ) {
        if ( ! InStr( inputString, " " ) )
            throw Exception( 1001, "Pseudo axis definition: " . inputString, "This is not a valid pseudo-axis input definition." )

        Loop, Parse, inputString, `,
            this.inputButton%A_Index% := new CInputPressable( A_LoopField, %this%() )
        }

    Call() {
        ; use A_ThisHotkey to determine the trigger.
        }
    activate() {
        this.inputButtonDown.activate()
        this.inputButtonUp.activate()
        }

    deactivate() {
        this.inputButtonDown.deactivate()
        this.inputButtonUp.deactivate()
        }

    getState() {
        return this.currentState
        }
    }
