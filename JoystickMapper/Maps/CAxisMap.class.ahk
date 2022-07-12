class CAxisMap {
	convertedRange := 0
	correctedInput := 0
	deadZone := 0
	hasCenter := 0
	inputAxis := {}
	lastState := 0
	maxZone := 0
	reversing := 0
	sensitivity := 1
	sensitivityOffset := 0

	getState() {
		this.correctedInput := this.inputAxis.getState() - 50 * this.hasCenter
		this.reversing := this.correctedInput < 0
		this.correctedInput := Abs( this.correctedInput ) - this.deadZone

		if ( this.correctedInput <= 0 )
			this.correctedInput := 0
		else {
			if ( this.correctedInput > this.convertedRange )
				this.correctedInput := this.convertedRange

			this.correctedInput := this.correctedInput / this.convertedRange
			}

		this.lastState := this.sensitivityOffset + absoluteThrustPercent * this.sensitivity
		return this.lastState
		}

	load( configFileName, sectionName ) {
		IniRead, deadZone, %configFileName%, %sectionName%, DeadZone, 0
		this.deadZone := deadZone
		IniRead, hasCenter, %configFileName%, %sectionName%, HasCenter, 0
		this.hasCenter := hasCenter
		IniRead, inputString, %configFileName%, %sectionName%, JoystickAxis

		if ( inputString = "ERROR" )
			throw Exception( 1000, "Section: " . sectionName . "`nKey: JoystickAxis" )
		else
			this.inputAxis := New CJoystickAxis( inputString )

		IniRead, maxZone, %configFileName%, %sectionName%, MaxZone, 0
		this.maxZone := maxZone
		IniRead, sensitivity, %configFileName%, %sectionName%, SensitivityPercent, 100
		this.sensitivity := sensitivity / 100
		IniRead, sensitivityOffset, %configFileName%, %sectionName%, SensitivityOffsetPercent, 0
		this.sensitivityOffset := sensitivityOffset / 100
		this.convertedRange := 100 - 50 * this.hasCenter - this.deadZone - this.maxZone
		}
	}
