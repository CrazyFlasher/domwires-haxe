package mock.commands;

import com.domwires.core.mvc.command.AbstractCommand;
import mock.obj.MockObj_1;

class MockCommand_5 extends AbstractCommand
{
    @Inject
    @Optional
    private var obj:MockObj_1;

    @Inject("olo")
    private var olo:String;

    override public function execute():Void
    {
        if (obj != null) obj.s = olo;
    }
}
