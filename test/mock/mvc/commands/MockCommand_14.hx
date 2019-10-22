package mock.mvc.commands;

import mock.obj.MockObj_1;
import com.domwires.core.mvc.command.AbstractCommand;
import mock.mvc.models.MockModel_2;

class MockCommand_14 extends AbstractCommand
{
    @Inject
    private var obj:MockObj_1;

    @Inject("olo")
    @Optional
    private var olo:String;

    override public function execute():Void
    {
        super.execute();

        obj.s += olo;
    }
}
