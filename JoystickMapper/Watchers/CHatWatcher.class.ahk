class CHatWatcher {
    hats := {}
    watchFunction := {}

    ; BUILT IN METHODS
    __Delete() {
        watchFunction := this.watchFunction
        SetTimer, % watchFunction, Delete
        }

    __New( inputHat ) {
        Global CHatWatcher

        if ( ! CHatWatcher.HasKey( "hatWatcher" ) ) {
            msgbox Creating hat watcher
            this.watchFunction := ObjBindMethod( this, "watch" )
            CHatWatcher.hatWatcher := this
            }

        CHatWatcher.hatWatcher.addHatButton( inputHat )
        return CHatWatcher.hatWatcher
        }

    ; CUSTOM METHODS
    addHatButton( inputHat ) {
        isActive := this.hats.Count()

        If ( ! this.hats.HasKey( inputHat.joystickNumber ) )
            this.hats[ inputHat.joystickNumber ] := {}

        this.hats[ inputHat.joystickNumber, inputHat.controlId ] := inputHat

        If ( ! isActive ) {
            watchFunction := this.watchFunction
            SetTimer, % watchFunction, 5
            }
        }

    removeHatButton( inputHat ) {
        Global CHatWatcher

        hat := this.hats[ inputHat.joystickNumber ]
        hat.Delete( inputHat.controlId )

        If ( ! hat.Count() )
            this.hats.Delete( inputHat.joystickNumber )

        If ( ! this.hats.Count() )
            CHatWatcher.Delete( "hatWatcher" )
        }

    watch() {
        If ( scriptDisabled() )
            Return

        For joystickNumber, hat In this.hats {
            state := GetKeyState( joystickNumber . "JoyPOV" ) + 0

            For controlId, inputHat In hat {
                alreadyPressed := inputHat.pressed
                inputHat.pressed :=    ( controlId = "HatUp"
                        && ( ( state >= 0 && state <= 4500 )
                            || ( state >= 31500 && state <= 36000 ) ) )
                     || ( controlId = "HatRight"
                        && ( state >= 4500 && state <= 13500 ) )
                     || ( controlId = "HatDown"
                        && ( state >= 13500 && state <= 22500 ) )
                     || ( controlId = "HatLeft"
                        && ( state >= 22500 && state <= 31500 ) )

                if ( inputHat.pressed && ! alreadyPressed )
                    inputHat.onButtonPressed.Call()

                if ( ! inputHat.pressed && alreadyPressed )
                    inputHat.onButtonReleased.Call()
                }
            }
        }
    }
