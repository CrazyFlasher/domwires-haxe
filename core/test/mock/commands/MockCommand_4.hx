package mock.commands;

import com.domwires.core.mvc.command.AbstractCommand;
import mock.obj.MockObj_1;

class MockCommand_4 extends AbstractCommand
{
    @Inject
    private var obj:MockObj_1;

    @Inject("olo")
    @Optional
    private var olo:String;

    override public function execute():Void
    {
        obj.s = olo;
    }
}
