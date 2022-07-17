class CInput {
    _inputString := ""
    controlId := ""
    joystickNumber := ""

    inputString[] {
        get {
            return this._inputString
            }

        set {
            this._inputString := value
            joyPosition := InStr( value, "Joy" )

            if ( ! joyPosition )
                throw Exception( 1001, "Input: " . value, "This is not a properly constructed joystick input identification." )

            if ( --joyPosition )
                this.joystickNumber := SubStr( value, 1, joyPosition )

            this.controlId := SubStr( value, joyPosition + 4 )
            }
        }
    }
