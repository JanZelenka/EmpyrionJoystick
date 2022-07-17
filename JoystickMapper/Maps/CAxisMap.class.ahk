class CAxisMap {
    convertedRange := 0
    correctedInput := 0
    deadZone := 0
    hasCenter := 0
    inputAxis := ""
    lastState := 0
    maxZone := 0
    outputKeyHigh := ""
    outputKeyLow := ""
    ratio := 1
    ratioOffset := 0
    reversing := 0

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

        this.lastState := this.ratioOffset + this.absoluteThrustPercent * this.sensitivity
        return this.lastState
        }

    load( configFileName, sectionName ) {
        IniRead, deadZone, %configFileName%, %sectionName%, DeadZone, 0
        this.deadZone := deadZone
        IniRead, hasCenter, %configFileName%, %sectionName%, HasCenter, 0
        this.hasCenter := hasCenter

        IniRead, maxZone, %configFileName%, %sectionName%, MaxZone, 0
        this.maxZone := maxZone
        IniRead, ratio, %configFileName%, %sectionName%, RationPercent, 100
        this.ratio := ratio / 100
        IniRead, ratioOffset, %configFileName%, %sectionName%, ratioOffsetPercent, 0
        this.ratioOffset := ratioOffset / 100
        this.convertedRange := 100 - 50 * this.hasCenter - this.deadZone - this.maxZone
        IniRead, inputString, %configFileName%, %sectionName%, Input

        if ( inputString = "ERROR" )
            throw Exception( 1000, "Section: " . sectionName . "`nKey: Input" )

        this.inputAxis := New CInputAxis( inputString )
        IniRead, outputString, %configFileName%, %sectionName%, Output

        if ( outputString = "ERROR" )
            throw Exception( 1000, "Section: " . sectionName . "`nKey: Output" )

        spacePosition := InStr( outputString, " " )

        if ( ! spacePosition )
            throw Exception( 1001, "Axis output definition: " . outputString, "This is not a valid 2 button output definition." )

        this.outputKeyHigh := New COutput( SubStr( outputString, 1, spacePosition - 1 ) )
        this.outputKeyLow := New COutput( SubStr( outputString, spacePosition + 1 ) )
        }
    }
