package mock.mvc.commands;

import mock.mvc.models.MockModel_6;
import com.domwires.core.mvc.command.AbstractCommand;
import mock.mvc.models.MockModel_2;

class MockCommand_16 extends AbstractCommand implements IMockCommand
{
    @Inject
    private var m:MockModel_6;

    override public function execute():Void
    {
        super.execute();

        m.v++;
    }
}
