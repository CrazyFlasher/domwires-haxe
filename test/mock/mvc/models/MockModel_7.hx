package mock.mvc.models;

import mock.mvc.opa.MockTypeDef;
import com.domwires.core.mvc.model.AbstractModel;

class MockModel_7 extends AbstractModel
{
    @Inject
    private var td:MockTypeDef;

    @Inject
    private var i:Int;

    public function getTd():MockTypeDef
    {
        return td;
    }

    public function getI():Int
    {
        return i;
    }
}
