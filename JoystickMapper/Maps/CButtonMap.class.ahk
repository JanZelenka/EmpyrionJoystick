#Include %A_ScriptDir%\Inputs\CPressableInput.class.ahk
#Include %A_ScriptDir%\Outputs\COutput.class.ahk

class CButtonMap {
	inputJoy := {}
	outputKey := {}

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
			onButtonReleased := ObjBindMethod( this, "onButtonReleased" )
			this.inputJoy := New CPressableInput( inputString, onButtonPressed, onButtonReleased )
			}

		IniRead, outputString, %configFileName%, %sectionName%, Output

		if ( outputString = "ERROR" )
			throw Exception( 1000, "Section: " . sectionName . "`nKey: Output" )

		this.outputKey := New COutput( outputString )
		}

	onButtonPressed() {
		if ( scriptDisabled() )
			return

		this.outputKey.press()
		}

	onButtonReleased() {
		if ( scriptDisabled() )
			return

		this.outputKey.release()
		}
	}
