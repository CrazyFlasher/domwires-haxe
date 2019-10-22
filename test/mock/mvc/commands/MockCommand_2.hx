package mock.mvc.commands;

import mock.obj.MockVo;
import com.domwires.core.mvc.command.AbstractCommand;
import mock.obj.MockObj_1;

class MockCommand_2 extends AbstractCommand
{
    @Inject("itemId")
    private var itemId:String;

    @Inject("vo")
    private var vo:MockVo;

    override public function execute():Void
    {
        vo.age = 11;
        vo.name = "hi";
        vo.str = itemId;
    }
}
