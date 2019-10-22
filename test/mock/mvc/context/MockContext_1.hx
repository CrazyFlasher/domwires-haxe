package mock.mvc.context;

import com.domwires.core.mvc.context.AbstractContext;
import com.domwires.core.mvc.message.IMessage;

class MockContext_1 extends AbstractContext
{
    override public function onMessageBubbled(message:IMessage):Bool
    {
        super.onMessageBubbled(message);

        //bubble up!
        return true;
    }
}