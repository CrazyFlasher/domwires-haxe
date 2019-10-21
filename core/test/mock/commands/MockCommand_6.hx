package mock.commands;

import com.domwires.core.mvc.command.AbstractCommand;
import haxe.io.Error;

class MockCommand_6 extends AbstractCommand
{
    @Inject("bool")
    @Optional
    private var bool:Bool = true;

    @Inject("iint")
    @Optional
    private var iint:Int = 1;

    override public function execute():Void
    {
        if (!bool || iint != 1)
        {
            throw Error.Custom("invalid values");
        }
    }
}
