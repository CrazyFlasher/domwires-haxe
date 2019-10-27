package mock.mvc.commands;

import com.domwires.core.mvc.command.AbstractCommand;

class MockCommand_17 extends AbstractCommand implements IMockCommand
{
    @Inject("e")
    private var value:EnumValue;

    override public function execute():Void
    {
        super.execute();

        trace("value", value);
    }
}
