package mock.mvc.commands.guards;

import com.domwires.core.mvc.command.AbstractGuards;

class MockAllowGuards_2 extends AbstractGuards
{
    override private function get_allows():Bool
    {
        return true;
    }
}
