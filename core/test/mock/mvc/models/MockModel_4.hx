package mock.mvc.models;

import mock.common.MockMessageType;
import com.domwires.core.mvc.model.AbstractModel;

class MockModel_4 extends AbstractModel
{
    public var testVar(get, set):Int;

    private var _testVar:Int = 0;

    private function get_testVar():Int
    {
        return _testVar;
    }

    private function set_testVar(value:Int):Int
    {
        _testVar = value;

        dispatchMessage(MockMessageType.GoodBye, null, true);

        return _testVar;
    }
}
