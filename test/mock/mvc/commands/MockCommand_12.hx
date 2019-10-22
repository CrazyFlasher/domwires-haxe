package mock.mvc.commands;

import com.domwires.core.mvc.command.AbstractCommand;
import mock.mvc.models.MockModel_4;

class MockCommand_12 extends AbstractCommand
{
    @Inject
    private var testModel:MockModel_4;

    override public function execute():Void
    {
        super.execute();

        testModel.testVar++;
    }
}
