package mock.mvc.context;

import com.domwires.core.mvc.context.AbstractContext;
import com.domwires.core.mvc.message.IMessage;
import mock.common.MockMessageType;
import mock.mvc.commands.MockCommand_11;
import mock.mvc.models.MockModel_3;
import mock.mvc.views.MockView_2;

class MockContext_3 extends AbstractContext
{
    private var testView:MockView_2;
    private var testModel2:MockModel_3;

    override private function init():Void
    {
        super.init();

        testView = cast factory.instantiateUnmapped(MockView_2);
        addView(testView);

        testModel2 = cast factory.instantiateUnmapped(MockModel_3);
        addModel(testModel2);

        factory.mapToValue(MockModel_3, testModel2);

        map(MockMessageType.Hello, MockCommand_11);
    }

    public function getTestModel():MockModel_3
    {
        return testModel2;
    }

    public function ready():Void
    {
        testView.dispatch();
    }

    override public function onMessageBubbled(message:IMessage):Bool
    {
        super.onMessageBubbled(message);

        //to pass message to parent context
        return true;
    }
}