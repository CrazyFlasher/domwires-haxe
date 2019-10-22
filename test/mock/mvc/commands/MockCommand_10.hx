package mock.mvc.commands;

import mock.mvc.models.MockModel_2;
import com.domwires.core.mvc.command.AbstractCommand;

class MockCommand_10 extends AbstractCommand implements IMockCommand
{
    @Inject
    private var testModel:MockModel_2;

    override public function execute():Void
    {
        super.execute();

        testModel.testVar++;
    }
}
