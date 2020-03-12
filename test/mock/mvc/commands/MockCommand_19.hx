package mock.mvc.commands;

import mock.mvc.models.MockModel_2;
import com.domwires.core.mvc.command.AbstractCommand;

class MockCommand_19 extends AbstractCommand implements IMockCommand
{
    @Inject
    private var model:MockModel_2;

    private var id:Int = 0;

    @PostConstruct
    private function init():Void
    {
        id++;

        trace(id);

        model.testVar = id;
    }
}
