package mock.mvc.context;

import com.domwires.core.mvc.context.AbstractContext;
import mock.mvc.views.MockView_4;

class MockContext_6 extends AbstractContext
{
    override private function init():Void
    {
        super.init();

        addView(cast factory.instantiateUnmapped(MockView_4));
    }
}