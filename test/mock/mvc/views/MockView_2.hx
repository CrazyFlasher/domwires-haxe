package mock.mvc.views;

import mock.common.MockMessageType;
import com.domwires.core.mvc.view.AbstractView;

class MockView_2 extends AbstractView
{
    public function dispatch():Void
    {
        dispatchMessage(MockMessageType.Hello, null, true);
    }
}
