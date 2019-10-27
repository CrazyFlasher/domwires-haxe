package com.domwires.core.mvc.context;

import com.domwires.core.factory.AppFactory;
import com.domwires.core.factory.IAppFactory;
import com.domwires.core.mvc.context.config.ContextConfigVo;
import com.domwires.core.mvc.context.config.ContextConfigVoBuilder;
import massive.munit.Assert;
import mock.common.MockMessageType;
import mock.mvc.commands.MockCommand_10;
import mock.mvc.commands.MockCommand_13;
import mock.mvc.commands.MockCommand_14;
import mock.mvc.commands.MockCommand_15;
import mock.mvc.context.MockContext_1;
import mock.mvc.context.MockContext_2;
import mock.mvc.context.MockContext_3;
import mock.mvc.context.MockContext_5;
import mock.mvc.context.MockContext_7;
import mock.mvc.context.MockContext_8;
import mock.mvc.message.MockMessage;
import mock.mvc.models.MockModel_1;
import mock.mvc.views.MockView_1;
import mock.mvc.views.MockView_4;
import mock.obj.MockObj_1;

class ContextTest
{
    private var f:IAppFactory;

    private var c:IContext;

    @BeforeClass
    public function beforeClass():Void
    {
    }

    @AfterClass
    public function afterClass():Void
    {
    }

    @Before
    public function setup():Void
    {
        f = new AppFactory();
        f.mapToType(IContext, MockContext_1);
        f.mapToValue(IAppFactory, f);

        var cb:ContextConfigVoBuilder = new ContextConfigVoBuilder();
        cb.forwardMessageFromViewsToModels = true;
        f.mapToValue(ContextConfigVo, cb.build());

        c = cast f.getInstance(IContext);
        c.addModel(cast f.instantiateUnmapped(MockModel_1));
        c.addView(cast f.instantiateUnmapped(MockView_1));
    }

    @After
    public function tearDown():Void
    {
        if (!c.isDisposed)
        {
            c.disposeWithAllChildren();
        }
    }

    @Test
    public function testDisposeWithAllChildren():Void
    {
        c.disposeWithAllChildren();

        Assert.isTrue(c.isDisposed);
    }

    @Test
    public function testExecuteCommandFromBubbledMessage():Void
    {
        var c1:MockContext_2 = cast f.instantiateUnmapped(MockContext_2);
        var c2:MockContext_3 = cast f.instantiateUnmapped(MockContext_3);
        c.addModel(c1);
        c.addModel(c2);

        c2.ready();

        Assert.areEqual(c1.getTestModel().testVar, 1);
    }

    @Test
    public function testBubbledMessageNotRedirectedToContextItCameFrom():Void
    {
        var c1:MockContext_2 = cast f.instantiateUnmapped(MockContext_2);
        var c2:MockContext_3 = cast f.instantiateUnmapped(MockContext_3);
        c.addModel(c1);
        c.addModel(c2);

        c2.ready();

        Assert.areEqual(c2.getTestModel().testVar, 1);
    }

    @Test
    public function testViewMessageBubbledOnceForChildContext():Void
    {
        MockView_4.VAL = 0;
        var c:MockContext_5 = cast f.instantiateUnmapped(MockContext_5);
        Assert.areEqual(c.getModel().testVar, 1);
        Assert.areEqual(MockView_4.VAL, 1);
    }

    @Test
    public function testMapToInterface():Void
    {
        var f:IAppFactory = new AppFactory();
        f.mapToValue(IAppFactory, f);
        f.mapClassNameToValue("Class<Dynamic>", MockCommand_10);
        var c:MockContext_7 = cast f.instantiateUnmapped(MockContext_7);
        c.ready();
        Assert.areEqual(c.getTestModel().testVar, 1);

        f.mapClassNameToValue("Class<Dynamic>", MockCommand_13);
        var c2:MockContext_7 = cast f.instantiateUnmapped(MockContext_7);
        c2.ready();
        Assert.areEqual(c2.getTestModel().testVar, 2);
    }

    @Test
    public function testStopOnExecute():Void
    {
        var m:MockObj_1 = cast f.instantiateUnmapped(MockObj_1);
        f.mapToValue(MockObj_1, m);
        f.mapToValue(String, "test", "olo");
        c.map(MockMessageType.GoodBye, MockCommand_14, null, false, true);
        c.map(MockMessageType.GoodBye, MockCommand_15);
        c.tryToExecuteCommand(new MockMessage(MockMessageType.GoodBye));
        Assert.areEqual(m.d, 0);
    }

    @Test
    public function testCommandMappedToOtherMessageType():Void
    {
        var c:MockContext_8 = cast f.getInstance(MockContext_8);

        Assert.areEqual(c.testModel.v, 0);
    }
}
