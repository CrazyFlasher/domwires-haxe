package mock.mvc.context;

import com.domwires.core.mvc.context.AbstractContext;
import mock.common.MockMessageType;
import mock.mvc.commands.MockCommand_10;
import mock.mvc.models.MockModel_2;

class MockContext_2 extends AbstractContext
{
    private var testModel:MockModel_2;

    override private function init():Void
    {
        super.init();

        testModel = cast factory.instantiateUnmapped(MockModel_2);
        addModel(testModel);

        factory.mapToValue(MockModel_2, testModel);

        map(MockMessageType.Hello, MockCommand_10);
    }

    public function getTestModel():MockModel_2
    {
        return testModel;
    }
}