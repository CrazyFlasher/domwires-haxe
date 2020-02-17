package mock.mvc.context;

import com.domwires.core.mvc.context.AbstractContext;
import mock.common.MockMessageType;
import mock.mvc.commands.MockCommand_16;
import mock.mvc.models.MockModel_6;

class MockContext_8 extends AbstractContext
{
    public var testModel:MockModel_6;

    override private function init():Void
    {
        super.init();

        map(MockMessageType.Hello, MockCommand_16);

        testModel = factory.getInstance(MockModel_6);

        factory.mapToValue(MockModel_6, testModel);

        addModel(testModel);
    }
}