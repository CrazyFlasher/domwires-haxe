package mock.mvc.views;

import com.domwires.core.mvc.message.IMessage;
import com.domwires.core.mvc.view.AbstractView;
import mock.common.MockMessageType;

class MockView_4 extends AbstractView
{
    public static var VAL:Int;

    @PostConstruct
    private function init():Void
    {
        addMessageListener(MockMessageType.Shalom, onShalom);
    }

    private function onShalom(m:IMessage):Void
    {
        MockView_4.VAL++;
    }
}
