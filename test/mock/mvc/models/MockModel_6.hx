package mock.mvc.models;

import com.domwires.core.mvc.model.AbstractModel;
import mock.common.MockMessageType_2;

class MockModel_6 extends AbstractModel
{
    public var v:Int = 0;

    override private function addedToHierarchy():Void
    {
        super.addedToHierarchy();

        dispatchMessage(MockMessageType_2.Hello, null, true);
    }
}
