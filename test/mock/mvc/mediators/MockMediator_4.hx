package mock.mvc.mediators;

import com.domwires.core.mvc.message.IMessage;
import com.domwires.core.mvc.mediator.AbstractMediator;
import mock.common.MockMessageType;

class MockMediator_4 extends AbstractMediator
{
    public static var VAL:Int;

    @PostConstruct
    private function init():Void
    {
        addMessageListener(MockMessageType.Shalom, onShalom);
    }

    private function onShalom(m:IMessage):Void
    {
        MockMediator_4.VAL++;
    }
}
