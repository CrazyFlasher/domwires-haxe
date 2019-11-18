package mock.mvc.context;

import com.domwires.core.mvc.context.AbstractContext;
import mock.mvc.mediators.MockMediator_4;

class MockContext_6 extends AbstractContext
{
    override private function init():Void
    {
        super.init();

        addMediator(cast factory.instantiateUnmapped(MockMediator_4));
    }
}