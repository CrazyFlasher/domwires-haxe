package mock.obj;

class MockBusyPoolObject
{
    public var isBusy(get, set):Bool;

    private var _isBusy:Bool;

    private function get_isBusy():Bool
    {
        return _isBusy;
    }

    private function set_isBusy(value:Bool):Bool
    {
        return _isBusy = value;
    }
}
