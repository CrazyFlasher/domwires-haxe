package mock.obj;

@:keep
class MockObj_2
{
    public var prop(get, never):String;
    public var value(get, never):Int;

    private function get_prop():Strin
    {
        return "hello";
    }

    private function get_value():Int
    {
        return 1;
    }
}
