class CHatWatcher {
	hats := {}

	; BUILT IN METHODS
	Call() {
		If ( scriptDisabled() )
			Return

		For joystickNumber, hat In this.hats {
			state := GetKeyState( joystickNumber . "POV" )

			if ( state = -1 )
				break

			For inputId, inputHat In hat {
				alreadyPressed := inputHat.pressed
				inputHat.pressed :=	( inputId = "HatUp"
						&& ( state Between 0 And 4500
							|| state Between 31500 And 36000 ) )
					 || ( inputId = "HatRight"
						&& state Between 4500 And 13500 )
					 || ( inputId = "HatDown"
						&& state Between 13500 And 22500 )
					 || ( inputId = "HatLeft"
						&& state Between 22500 And 31500 )
				if ( inputHat.pressed && ! alreadyPressed )
					inputHat.onButtonPressed.Call()
				}
			}
		}
	}

	; CUSTOM METHODS
	addHatButton( inputHat ) {
		isActive := this.hats.Count()
		this.hats[ inputHat.joystickNumber, inputHat.controlId ] := inputHat

		If( ! isActive )
			SetTimer, %this%(), 10
	}

	removeHatButton( inputHat ) {
		hat := this.hats[ inputHat.joystickNumber ]
		hat.Delete( inputHat.controlId )

		If ( ! hat.Count() )
			this.hats.Delete( inputHat.joystickNumber )

		If ( ! this.hats.Count() )
			SetTimer, %this%(), Delete
		}
	}
