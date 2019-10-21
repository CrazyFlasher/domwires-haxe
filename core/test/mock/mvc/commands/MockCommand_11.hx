package mock.mvc.commands;

import com.domwires.core.mvc.command.AbstractCommand;
import mock.mvc.models.MockModel_3;

class MockCommand_11 extends AbstractCommand
{
    @Inject
    private var testModel:MockModel_3;

    override public function execute():Void
    {
        super.execute();

        testModel.testVar++;
    }
}
