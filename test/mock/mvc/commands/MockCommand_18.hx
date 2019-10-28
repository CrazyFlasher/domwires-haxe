package mock.mvc.commands;

import com.domwires.core.mvc.command.AbstractCommand;

class MockCommand_18 extends AbstractCommand implements IMockCommand
{
    @Inject("i")
    private var i:Int;

    @Inject("f")
    private var f:Float;

    @Inject("s")
    private var s:String;

    @Inject("b")
    private var b:Bool;

    @Inject("e")
    private var e:EnumValue;

    override public function execute():Void
    {
        super.execute();

        trace(i, f, s, b, e);
    }
}
