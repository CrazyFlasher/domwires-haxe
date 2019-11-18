package mock.mvc.mediators;

import mock.common.MockMessageType;
import com.domwires.core.mvc.mediator.AbstractMediator;

class MockMediator_2 extends AbstractMediator
{
    public function dispatch():Void
    {
        dispatchMessage(MockMessageType.Hello, null, true);
    }
}
