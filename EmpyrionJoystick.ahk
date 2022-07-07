#SingleInstance force
#Persistent

;  FLIGHT STICK/HOTAS MAPPING SCRIPT FOR EMPYRION - GALACTIC SURVIVAL (v12 tested)

;--------------------
class ButtonMap
{
	joyInput := ""
	keyOutput := ""
	
	activate ()
	{
		Hotkey % this.joyInput, ButtonPressed.Bind( this ) 
	}
	
	deactivate ()
	{
		Hotkey % this.joyInput, Off
	}
}

;--------------------
class Profile
{
	activate ()
	{
	}
	
	deactivate ()
	{
	}
	
	load ( profileSection )
	{
		
	}
}

settingsFile := "config.ini"
IniRead, SupressJoystickOutputAwayFromGame, %settingsFile%, Main, TestMode
IniRead, GameWindowName, %settingsFile%, Main, GameWindowName, "Empyrion - Galactic Survival"
IniRead, ProfileToggleKey, %settingsFile%, Main, ProfileToggleKey, "-"
IniRead, activeProfileNumber, %settingsFile%, Main, ActiveProfile, 1
profiles := []

loop
{
	IniRead, iniSection, %settingsFile%, Profile%A_Index%
	
	if ( iniSection = "" )
		break

	profiles[ A_Index ] := new Profile
	profiles[ A_Index ].load( "Profile" . A_Index )
}

activeProfile := profiles[ activeProfileNumber ]

; Assignments of Axes from joystick inputs
;   Options are:
;		Joystick X Axis: 			JoyX
;		Joystick Y Axis: 			JoyY
;		Joystick Z Axis: 			JoyR   ;R and Z are backwards because AHK has them reversed
;		Joystick Throttle Axis: 	JoyZ

; Profile 1
YawInputAxisProfile1 := "1JoyR"									
PitchInputAxisProfile1 := "3JoyY"								
RollInputAxisProfile1 := "3JoyX"										
ThrottleInputAxisProfile1 := "2JoyZ"									
PitchInvertedProfile1 := 0


; Profile 2  currently set up to switch roll and yaw (leaning stick side to side turns instead of rolls) and does not invert the joystick
YawInputAxisProfile2 := "3JoyX"								
PitchInputAxisProfile2 := "3JoyY"							
RollInputAxisProfile2 := "1JoyR"								
ThrottleInputAxisProfile2 := "2JoyZ"
PitchInvertedProfile2 := 0

; Button That Switches Between Profile 1 and Profile 2 Axis Assignments
ProfileToggleKey := "-"										


; Dead Zone adjustments (prevents drift when an analog axis is centered but still sending a tiny signal)
PitchDeadZone := 15											; Percentage of deadzones per axis 
RollDeadZone := 15
YawDeadZone := 20
ThrottleDeadZone := 20

; Sensitivity Adjustments.  Use 0.1 to 2 or so. will depend on your preferred mouse sensitivity in-game.
RollSensitivity := 0.2										
PitchSensitivity := 0.2
YawSensitivity := 0.2										

RollAxisOutputKeys := ["q", "e"]							; Array of keys to map to the Roll Axis
ThrottleOutputKeys := ["w", "s"]							; Array of keys to map to the Throttle axis

; Assign a button that turns the thrust control on and off in-game
ThrottleControlDisableEnableKey := "2Joy1"					; Assign a button or key that will enable/disable the throttle control in-game (makes the analog control more friendly - you don't have to center it to use menus or switch windows)
															; If you Assign a Joystick Button Here, put the number of the joystick, then "Joy", then the button number: 1Joy9 for Joystick 1 button 9 (joystick 1 is default)
															
; Set this to 0 to disable throttle function entirely															
EnableThrottleBinding := 1									; Throttle works well, but can't work when in menus and will prevent Alt+Tab to switch apps in windows... (due to empyrion limitations)

HatKeysX := ["a","d"]										; Array of keys to map to the POV hat X axis
HatKeysY := ["space","c"]									; Array of keys to map to the POV hat Y axis

						; NOTES ON HOW TO CHANGE KEYBINDINGS:
buttonKeys := []
buttonKeys[ 1 ] := { joyNr: 3, buttonNr: 1, output: "LButton" }			; 	LButton, MButton, RButton are the middle, left, and right mouse buttons
buttonKeys[ 2 ] := { joyNr: 3, buttonNr: 2, output: "o" }				; 	enter lowercase letters or numbers in the quotes for binds 
buttonKeys[ 3 ] := { joyNr: 2, buttonNr: 4, output: "Space" }			; 	Space, Tab, Enter, Escape, LShift, RShift, LAlt, RAlt, LControl, RControl, F1, F2, ...,  are other common keynames for keys
buttonKeys[ 4 ] := { joyNr: 2, buttonNr: 5, output: "c" }				; 	use a carat before a key to bind a control+keypress:   	^p 	would bind Ctrl+p 
buttonKeys[ 5 ] := { joyNr: 2, buttonNr: 3, output: "y" }				;   use a plus before a key to bind a Shift+keypress:   	+p 	would bind Shift+p 
buttonKeys[ 6 ] := { joyNr: 3, buttonNr: 4, output: "r" }				;   use an exclamation mark before a key for Alt+keypress:	!p	would bind Alt+p 

																		; For more info on what to put in for keys, visit: https://www.autohotkey.com/docs/KeyList.htm

; These adjust how long the pulse interval is for analog conversions of Yaw and Thrust.  Leave alone unless you're tinkering with the performance of this function 
AxisSendModulationTimeZ := 50                              	; total time of keypress pulse loops for Roll (the key will be pressed down a fraction of this time depending on analog input
AxisSendModulationTimeT := 50                       		; total time of keypress pulse loops for Thrust (the key will be pressed down a fraction of this time depending on analog input						
minimumSendDurationRatioT := 0.40 							; Minimum ratio of full that Throttle starts on (lower values weren't working in empyrion, glitching)
															
;====== End vars intended to be modified =======

throttleKeyPressTime := 100 ; Number of ms the throttle key will be held down. The rate is achieved by modifying the release time only.
throttleMaxZone := 5 ; The percentage of the Throttle axis that is treated as full throttle. So when the value is say 5, above 95% and below 5% will be treated as full throttle in the respective dirrection.

InvertY := PitchInvertedProfile1							; assigning profile 1 bindings do not change these 					
YawInputAxis := InputStick YawInputAxisProfile1
PitchInputAxis := InputStick PitchInputAxisProfile1							
RollInputAxis := InputStick RollInputAxisProfile1							
ThrottleInputAxis := InputStick ThrottleInputAxisProfile1

Hotkey, %ThrottleControlDisableEnableKey%, ToggleThrottle	; linking hotkey to function for this binding
Hotkey, %ProfileToggleKey%, ToggleProfile					; linking hotkey to function for this binding
ThrottleControlEnabled := 1   	; tracks whether user has disabled or enabled throttle control 
CurrentControlProfile := 1   	; tracks whether user is currently on control Profile 1 or 2 (don't change this)
ThrottleKeyState := 0   		; internal program use
RollKeyState := 0				; internal program use
PitchDeadZone := PitchDeadZone/2							; convert deadzone percentages to raw numbers (0-50 range)
RollDeadZone := RollDeadZone/2
YawDeadZone := YawDeadZone/2
ThrottleDeadZone := ThrottleDeadZone/2

if (HatKeysX.length() && HatKeysY.length()){
	HatKeys := []
	HatKeys[1] := [{down: "{" HatKeysX[1] " down}", up: "{" HatKeysX[1] " up}"},{down: "{" HatKeysX[2] " down}", up: "{" HatKeysX[2] " up}"}]
	HatKeys[2] := [{down: "{" HatKeysY[1] " down}", up: "{" HatKeysY[1] " up}"},{down: "{" HatKeysY[2] " down}", up: "{" HatKeysY[2] " up}"}]
	HatEnabled := 1
} else {
	HatEnabled := 0
}
HatState := [0,0]											; The current state of the hat X and Y axes
; Build an "Associative Array" map of hat angles to X and Y directions
HatMap := {-1: [0,0], 0: [0,1], 4500: [2,1], 9000: [2,0], 13500: [2,2], 18000: [0,2], 22500: [1,2], 27000: [1,0], 31500: [1,1]}
; Pre-assemble GetKeyState strings for performance optimization
JoyString := InputStick "Joy"
HatString := JoyString "POV"



; Bind Normal Joystick Buttons 1-32


ButtonStrings := []
ButtonKeyStrings := []

for buttonNr, buttonInfo in buttonKeys
{
	currJoyButton := buttonInfo.joyNr "Joy" buttonInfo.buttonNr
	currJoyButtonTarget := buttonInfo.output
	ButtonStrings[ buttonNr ] := currJoyButton
	ButtonKeyStrings[ buttonNr ] := {down: "{" currJoyButtonTarget " down}", up: "{" currJoyButtonTarget " up}"}
	fn := Func("ButtonPressed").Bind( buttonNr )
	hotkey, % currJoyButton, % fn
}

SetKeyDelay -1  ; Avoid delays between keystrokes.
throttleToggledOn := A_TickCount
lastThrottleInput := GetKeyState( ThrottleInputAxis )
timeLeftOver := 0
throttleFullForward := 50 - throttleMaxZone
throttleFullBackward := throttleMaxZone - 50

; start functions that loop and handle axis inputs
SetTimer, WatchHat, 5
SetTimer, WatchTwoAxesForMouseOutput, 5
SetTimer, WatchRoll, 5
if (EnableThrottleBinding = 1)
	SetTimer, WatchThrottle, 10
	
return

WatchHat:
	if (!WinActive(GameWindowName) && SupressJoystickOutputAwayFromGame = 1)
		return

	; === Hat ===
	if (!HatEnabled)
		return
	state := GetKeyState(HatString)
	; Process Hat X axis then Y Axis
	Loop 2 {
		new_state := HatMap[state,A_Index]
		old_state := HatState[A_Index]
		if (old_state != new_state){
			if (old_state)
				Send % HatKeys[A_Index, old_state].up
			if (new_state)
				Send % HatKeys[A_Index, new_state].down
			HatState[A_Index] := new_state
		}
	}
	
	return
	
	
WatchTwoAxesForMouseOutput:
	if (!WinActive(GameWindowName) && SupressJoystickOutputAwayFromGame = 1)
		return

	mouseAxisX := GetKeyState(YawInputAxis)-50  ; Get position of axis assigned for X, centered.
	MouseAxisY := GetKeyState(PitchInputAxis)-50  ; Get position of axis assigned for Y, centered.

	if (abs(mouseAxisX) > YawDeadZone || abs(MouseAxisY) > PitchDeadZone)
	{   

		if (InvertY = 1)
			MouseAxisY := -1 * MouseAxisY

		;//factor in deadzone and scale back up
		if (mouseAxisX > YawDeadZone)
			mouseAxisX := (mouseAxisX - YawDeadZone) * 50 / (50-YawDeadZone)
		else if (mouseAxisX < 0 - YawDeadZone)
			mouseAxisX := (mouseAxisX + YawDeadZone) * 50 / (50-YawDeadZone)
		else
			mouseAxisX := 0
		
		if (MouseAxisY > PitchDeadZone)
			MouseAxisY := (MouseAxisY - PitchDeadZone) * 50 / (50-PitchDeadZone)
		else if (MouseAxisY < 0 - PitchDeadZone)
			MouseAxisY := (MouseAxisY + PitchDeadZone) * 50 / (50-PitchDeadZone)
		else
			MouseAxisY := 0
			
		DllCall("mouse_event", uint, 1, int, mouseAxisX * YawSensitivity, int, MouseAxisY * PitchSensitivity)
	}

	return
	
WatchRoll:
	KeyToHoldDownRollR := RollAxisOutputKeys[2]
	KeyToHoldDownRollL := RollAxisOutputKeys[1]
	if (!WinActive(GameWindowName) && SupressJoystickOutputAwayFromGame = 1)
	{
		if (RollKeyState = 1)
		{
			Send, {%KeyToHoldDownRollR% up}
			Send, {%KeyToHoldDownRollL% up}	
			RollKeyState := 0
		}
		return
	}
		
	RollAxis := GetKeyState(RollInputAxis)  ; Get position of assigned roll axis.
	
	if (RollAxis > 50 + RollDeadZone)
		KeyToHoldDownRoll := RollAxisOutputKeys[2]			
	else if (RollAxis < 50 - RollDeadZone)
		KeyToHoldDownRoll := RollAxisOutputKeys[1]
	else
	{	
		if (RollKeyState = 1)
		{
			Send, {%KeyToHoldDownRollR% up}
			Send, {%KeyToHoldDownRollL% up}	
			RollKeyState := 0
		}
		return
	}
	
	if (RollAxis > 90 || RollAxis <10)  ; just holds key down when at max versus pulsing it 
	{
		RollKeyState := 1
		Send, {%KeyToHoldDownRoll% down}	
		return
	}

	possibleZ := 50 - RollDeadZone
	rawAmountZ := abs(RollAxis - 50) ; Range is now -50 to +50
	correctedAmountZ := rawAmountZ - RollDeadZone
	
	Send, {%KeyToHoldDownRoll% down}  ; Press it down.
	Sleep, (correctedAmountZ/possibleZ) * AxisSendModulationTimeZ * RollSensitivity
	Send, {%KeyToHoldDownRoll% up}  ; Release it.
	Sleep, (1- correctedAmountZ/possibleZ) * AxisSendModulationTimeZ * RollSensitivity

	return
	
ToggleThrottle:
	ThrottleControlEnabled := abs( ThrottleControlEnabled - 1 )
	return
	
ChangeProfile:
	activeProfile.deactivate()
	activeProfileNumber := ( activeProfileNumber = profileCount ? 1 : activeProfileNumber + 1 )
	activeProfile := profiles[ activeProfileNumber ]
	activeProfile.activate()
	return
	
WatchThrottle:
	ThrottleUpKey := ThrottleOutputKeys[2]
	ThrottleDownKey := ThrottleOutputKeys[1]
	if ((!WinActive(GameWindowName) && SupressJoystickOutputAwayFromGame = 1) || (!ThrottleControlEnabled))
	{	
		if (ThrottleKeyState = 1)
		{
			Send, {%ThrottleUpKey% up}
			Send, {%ThrottleDownKey% up}	
			ThrottleKeyState := 0
		}
		
		throttleToggledOn := A_TickCount
		lastThrottleInput := 50
		return
	}

	ThrottleAxis := GetKeyState( ThrottleInputAxis ) - 50  ; Get position of Throttle axis.
	
	if ( ThrottleAxis > ThrottleDeadZone)
		KeyToHoldDownT := ThrottleUpKey
	else if ( ThrottleAxis < -ThrottleDeadZone)
		KeyToHoldDownT := ThrottleDownKey
	else
	{
		if (ThrottleKeyState = 1)
		{
			Send, {%ThrottleUpKey% up}
			Send, {%ThrottleDownKey% up}	
			ThrottleKeyState := 0
		}

		throttleToggledOn := A_TickCount
		GoTo, exitWatchThrottle
	}

	if ( ThrottleAxis > throttleFullForward || ThrottleAxis < throttleFullBackward ) 
	{
		if ( ThrottleKeyState = 0 )
		{
			Send, {%KeyToHoldDownT% down}
			ThrottleKeyState := 1
		}

		throttleToggledOn := A_TickCount
		GoTo, exitWatchThrottle
	}

	throttleToggledBefore := A_TickCount - throttleToggledOn
	absoluteThrottleInput := abs( ThrottleAxis )
	absoluteCorrectedInput := absoluteThrottleInput - ThrottleDeadZone
	absoluteThrustPercent := absoluteCorrectedInput / ( 50 - ThrottleDeadZone - throttleMaxZone ) ;
	throttleDelta := absoluteThrottleInput - abs ( lastThrottleInput )
	
	if ( ThrottleKeyState = 1 )
	{
		keyDownTime := timeLeftOver + ( throttleKeyPressTime * absoluteThrustPercent )
		
		if ( keyDownTime <= throttleToggledBefore ) ;The throttle has been pressed long enough, releasing the key.
		{
			Send, {%KeyToHoldDownT% up}
			throttleToggledOn := A_TickCount
			timeLeftOver := throttleToggledBefore - keyDownTime
			ThrottleKeyState := 0
			GoTo, exitWatchThrottle
		}
	} else {
		
		if ( absoluteCorrectedInput <= 0 )
			GoTo, exitWatchThrottle
		else
		{
			keyUpTime := timeLeftOver + ( throttleKeyPressTime * ( 1 - absoluteThrustPercent ) )
			
			if ( keyUpTime <= throttleToggledBefore )
			{
				Send, {%KeyToHoldDownT% down}
				throttleToggledOn := A_TickCount
				timeLeftOver := throttleToggledBefore - keyUpTime
				ThrottleKeyState := 1
				GoTo, exitWatchThrottle
			}
		}
	}

exitWatchThrottle:
;	ToolTip, Thrust: %absoluteThrustPercent%`nKey down time: %keyDownTime%`nKey up time: %keyUpTime%`n
	lastThrottleInput := ThrottleAxis
	return

; Remap buttons, and make up event of buttons fire when button is actually released
ButtonPressed ( buttonMap ){
	Send % buttonMap.keyOutput.down

	while( GetKeyState( buttonMap.joyInput ) ) {
		Sleep 10
	}
	
	Send % buttonMap.keyOutput.down
}



