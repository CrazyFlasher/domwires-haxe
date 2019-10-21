package mock.mvc.commands;

import com.domwires.core.mvc.command.AbstractCommand;
import mock.obj.MockObj_1;

class MockCommand_3 extends AbstractCommand
{
    @Inject
    private var obj:MockObj_1;

    @Inject("olo")
    private var olo:Int;

    override public function execute():Void
    {
        obj.d += olo;
    }
}
