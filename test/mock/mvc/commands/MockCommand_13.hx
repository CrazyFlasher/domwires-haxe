package mock.mvc.commands;

import com.domwires.core.mvc.command.AbstractCommand;
import mock.mvc.models.MockModel_2;

class MockCommand_13 extends AbstractCommand implements IMockCommand
{
    @Inject
    private var testModel:MockModel_2;

    override public function execute():Void
    {
        super.execute();

        testModel.testVar += 2;
    }
}
