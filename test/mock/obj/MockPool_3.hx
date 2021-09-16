package mock.obj;

import hex.di.IDependencyInjector;
import hex.di.IInjectorContainer;

class MockPool_3 implements IMockPool_1 implements IInjectorContainer
{
    public var pcTimes:Int;

    @Inject("v")
    private var v:Int = 0;

    public var value(get, never):Int;

    @PostConstruct
    private function pc():Void
    {
        v++;
        pcTimes++;
    }

    private function get_value():Int
    {
        return v;
    }

    public function acceptInjector(i:IDependencyInjector):Void
    {
    }
}
