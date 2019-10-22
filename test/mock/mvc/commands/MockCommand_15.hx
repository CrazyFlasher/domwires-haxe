package mock.mvc.commands;

import com.domwires.core.mvc.command.AbstractCommand;
import mock.obj.MockObj_1;

class MockCommand_15 extends AbstractCommand
{
    @Inject
    private var obj:MockObj_1;

    override public function execute():Void
    {
        super.execute();

        obj.d += 7;
    }
}
