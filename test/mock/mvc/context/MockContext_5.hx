package mock.mvc.context;

import com.domwires.core.mvc.context.AbstractContext;
import com.domwires.core.mvc.context.config.ContextConfigVoBuilder;
import mock.common.MockMessageType;
import mock.mvc.commands.MockCommand_12;
import mock.mvc.models.MockModel_4;
import mock.mvc.mediators.MockMediator_3;

class MockContext_5 extends AbstractContext
{
    private var v:MockMediator_3;
    private var m:MockModel_4;

    override private function init():Void
    {
        var cb:ContextConfigVoBuilder = new ContextConfigVoBuilder();
        cb.forwardMessageFromMediatorsToModels = true;

        config = cb.build();

        super.init();

        v = factory.instantiateUnmapped(MockMediator_3);
        addMediator(v);

        m = factory.instantiateUnmapped(MockModel_4);
        factory.mapToValue(MockModel_4, m);
        addModel(m);

        addModel(factory.instantiateUnmapped(MockContext_6));

        map(MockMessageType.Hello, MockCommand_12);

        v.dispatch();
    }

    public function getModel():MockModel_4
    {
        return m;
    }
}