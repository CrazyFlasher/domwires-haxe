package mock.obj;

class MockPool_4 implements IMockPool_2
{
    public var s(get, never):String;
    public var n(get, never):Float;

    private var _s:String;
    private var _n:Float;

    private function get_s():String
    {
        return _s;
    }

    private function get_n():Float
    {
        return _n;
    }
}
