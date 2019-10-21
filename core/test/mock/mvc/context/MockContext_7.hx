package mock.mvc.context;

import com.domwires.core.mvc.message.IMessage;
import mock.mvc.commands.IMockCommand;
import com.domwires.core.mvc.context.AbstractContext;
import mock.common.MockMessageType;
import mock.mvc.models.MockModel_2;
import mock.mvc.views.MockView_2;

class MockContext_7 extends AbstractContext
{
    @Inject
    private var commandImpl:Class<Dynamic>;

    private var testView:MockView_2;
    private var testModel:MockModel_2;

    override private function init():Void
    {
        super.init();

        testView = cast factory.instantiateUnmapped(MockView_2);
        addView(testView);

        testModel = cast factory.instantiateUnmapped(MockModel_2);
        addModel(testModel);

        factory.mapToType(IMockCommand, cast commandImpl);
        factory.mapToValue(MockModel_2, testModel);

        map(MockMessageType.Hello, IMockCommand);
    }

    public function getTestModel():MockModel_2
    {
        return testModel;
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