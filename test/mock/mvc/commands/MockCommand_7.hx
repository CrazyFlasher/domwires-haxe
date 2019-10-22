package mock.mvc.commands;

import haxe.io.Error;
import com.domwires.core.mvc.command.AbstractCommand;

class MockCommand_7 extends AbstractCommand
{
    @Inject("bool")
    private var bool:Bool = true;

    @Inject("iint")
    private var iint:Int = 1;

    override public function execute():Void
    {
        if (bool || iint != 2)
        {
            throw Error.Custom("invalid values");
        }
    }
}
