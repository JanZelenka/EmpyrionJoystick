#Include %A_ScriptDir%\Maps\CButtonMap.class.ahk
#Include %A_ScriptDir%\Maps\CAxisMap.class.ahk

class CProfile {
	buttonMaps := []
	axesMaps := []

	;BUILT IN METHODS
	__New( settingsFile, profileSection ) {
		this.load( settingsFile, profileSection )
		}

	Call() {
		if ( scriptDisabled() )
			return
		}

	;CUSTOM METHODS
	activate() {
		For buttonIndex, buttonMap In this.buttonMaps
			buttonMap.activate()
		}

	deactivate() {
		For buttonIndex, buttonMap In this.buttonMaps
			buttonMap.deactivate()
		}

	load( configFileName, sectionName ) {
		Loop {
			IniRead buttonSection, %configFileName%, %sectionName%, Button%A_Index%

			if ( buttonSection = "ERROR" )
				break

			this.buttonMaps.Push( New CButtonMap() )
			this.buttonMaps[ A_Index ].load( configFileName, buttonSection )
		}
	}

