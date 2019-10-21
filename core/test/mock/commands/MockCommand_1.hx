package mock.commands;

import com.domwires.core.mvc.command.AbstractCommand;
import mock.obj.MockObj_1;

class MockCommand_1 extends AbstractCommand
{
    @Inject
    private var obj:MockObj_1;

    override public function execute():Void
    {
        obj.d += 7;
    }
}
