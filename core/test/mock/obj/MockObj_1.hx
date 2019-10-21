package mock.obj;

import hex.di.IInjectorContainer;

class MockObj_1 implements IInjectorContainer
{
    public var d(get, set):Int;
    public var s(get, set):String;

    private var _d:Int = 0;
    private var _s:String;

    public function new()
    {

    }

    private function get_d():Int
    {
        return _d;
    }

    private function get_s():String
    {
        return _s;
    }

    private function set_d(value:Int):Int
    {
        return _d = value;
    }

    private function set_s(value:String):String
    {
        return _s = value;
    }
}
