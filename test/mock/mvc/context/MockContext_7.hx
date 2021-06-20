package mock.mvc.context;

import com.domwires.core.mvc.command.ICommand;
import com.domwires.core.mvc.context.AbstractContext;
import com.domwires.core.mvc.message.IMessage;
import mock.common.MockMessageType;
import mock.mvc.mediators.MockMediator_2;
import mock.mvc.models.MockModel_2;

class MockContext_7 extends AbstractContext
{
    @Inject
    private var commandImpl:Class<ICommand>;

    private var testMediator:MockMediator_2;
    private var testModel:MockModel_2;

    override private function init():Void
    {
        super.init();

        testMediator = factory.instantiateUnmapped(MockMediator_2);
        addMediator(testMediator);

        testModel = factory.instantiateUnmapped(MockModel_2);
        addModel(testModel);

//        factory.mapToType(IMockCommand, cast commandImpl);
        factory.mapToValue(MockModel_2, testModel);

        map(MockMessageType.Hello, commandImpl);
    }

    public function getTestModel():MockModel_2
    {
        return testModel;
    }

    public function ready():Void
    {
        testMediator.dispatch();
    }

    override public function onMessageBubbled(message:IMessage):Bool
    {
        super.onMessageBubbled(message);

        //to pass message to parent context
        return true;
    }
}