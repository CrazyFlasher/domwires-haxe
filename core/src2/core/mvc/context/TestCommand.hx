package com.domwires.core.mvc.context;
import com.domwires.core.mvc.command.AbstractCommand;
class TestCommand  extends AbstractCommand
{
    public var itemId:String;

    override public function execute():Void {
        super.execute();

        trace("itemId " + itemId);
    }

    public function new(context:IContext)
    {
        super(context);
    }

}
