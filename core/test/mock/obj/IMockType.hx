package mock.obj;

interface IMockType
{
    var a(get, never):Int;
    var b(get, never):Int;
    var clazz(get, never):Class<Dynamic>;
}

class MockType_1 implements IMockType
{
    public var a(get, never):Int;
    public var b(get, never):Int;
    public var clazz(get, never):Class<Dynamic>;

    private var _a:Int;
    private var _b:Int;

    @Inject
    private var _clazz:Class<Dynamic>;

    public function MockType_1(a:Int, b:Int)
    {
        _a = a;
        _b = b;
    }

    public function get_a():Int
    {
        return _a;
    }

    public function get_b():Int
    {
        return _b;
    }

    public function get_clazz():Class<Dynamic>
    {
        return _clazz;
    }
}

class MockType_2 implements IMockType
{
    public var a(get, never):Int;
    public var b(get, never):Int;
    public var clazz(get, never):Class<Dynamic>;

    public function MockType_2()
    {
    }

    public function get_a():Int
    {
        return 500;
    }

    public function get_b():Int
    {
        return 700;
    }

    public function get_clazz():Class<Dynamic>
    {
        return null;
    }
}

class MockType_3
{
    public var a(get, never):Int;

    private var _a:Int;

    public function MyType3(a:Int)
    {
        _a = a;
    }

    public function get_a():Int
    {
        return _a;
    }
}
