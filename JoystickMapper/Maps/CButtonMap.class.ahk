#Include %A_ScriptDir%\Inputs\CPressableInput.class.ahk
#Include %A_ScriptDir%\Outputs\COutputKey.class.ahk

class CButtonMap {
	inputJoy := {}
	outputKey := {}

	; BUILT IN METHODS
	onButtonPressed() {
		MsgBox % "Called"
/*		
		if ( scriptDisabled() )
			return

		this.outputKey.press

		while( this.inputJoy.getState() )
			Sleep 10

		this.outputKey.release
*/
		}

	; CUSTOM METHODS
	activate() {
		this.inputJoy.activate()
		}

	deactivate() {
		this.inputJoy.deactivate()
		}

	load( configFileName, sectionName ) {
		IniRead, inputString, %configFileName%, %sectionName%, Input

		if ( inputString = "ERROR" )
			throw Exception( 1000, "Section: " . sectionName . "`nKey: Input" )

		if ( inputString != "" ) {
			onButtonPressed := ObjBindMethod( this, "onButtonPressed" )
			this.inputJoy := New CPressableInput( inputString, onButtonPressed )
			}

		IniRead, outputString, %configFileName%, %sectionName%, Output

		if ( outputString = "ERROR" )
			throw Exception( 1000, "Section: " . sectionName . "`nKey: Output" )

		this.outputKey := New COutputKey( outputString )
		}
	}
