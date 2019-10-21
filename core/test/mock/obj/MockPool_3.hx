package mock.obj;

class MockPool_3 implements IMockPool_1
{
    @Inject("v")
    private var v:Int = 0;

    public var value(get, never):Int;

    @PostConstruct
    private function pc():Void
    {
        v++;
    }

    private function get_value():Int
    {
        return v;
    }
}
