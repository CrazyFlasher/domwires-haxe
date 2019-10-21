package mock.mvc.views;

import com.domwires.core.mvc.message.IMessage;
import com.domwires.core.mvc.view.AbstractView;
import mock.common.MockMessageType;

class MockView_3 extends AbstractView
{
    @PostConstruct
    private function init():Void
    {
        addMessageListener(MockMessageType.GoodBye, onBoga);
    }

    private function onBoga(m:IMessage):Void
    {
        dispatchMessage(MockMessageType.Shalom, null, true);
    }

    public function dispatch():Void
    {
        dispatchMessage(MockMessageType.Hello, null, true);
    }
}
