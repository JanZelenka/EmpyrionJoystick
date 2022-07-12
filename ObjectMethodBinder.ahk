funcObject := New CButtonMap
funcObject.call()

class CButtonMap {
    Call() {
        MsgBox Called!
    }

	__New() {
		method := ObjBindMethod( this, "Call")
		method.Call()
		}
}