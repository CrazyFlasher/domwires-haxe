package mock.obj;

class MockPool_1 implements IMockPool_1
{
    public var value(get, never):Int;

    private function get_value():Int
    {
        return 1;
    }
}
