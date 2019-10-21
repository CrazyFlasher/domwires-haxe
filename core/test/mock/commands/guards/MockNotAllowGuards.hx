package mock.commands.guards;

import com.domwires.core.mvc.command.AbstractGuards;

class MockNotAllowGuards extends AbstractGuards
{
    override private function get_allows():Bool
    {
        return false;
    }
}
