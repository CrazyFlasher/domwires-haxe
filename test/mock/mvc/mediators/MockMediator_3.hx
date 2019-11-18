package mock.mvc.mediators;

import com.domwires.core.mvc.message.IMessage;
import com.domwires.core.mvc.mediator.AbstractMediator;
import mock.common.MockMessageType;

class MockMediator_3 extends AbstractMediator
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
