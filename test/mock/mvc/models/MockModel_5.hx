package mock.mvc.models;

import com.domwires.core.mvc.model.AbstractModel;
import mock.common.MockMessageType;

class MockModel_5 extends AbstractModel
{
    public var testVar:Int;

    public function dispatch():Void
    {
        dispatchMessage(MockMessageType.Hello, null, true);
    }
}
