package com.domwires.core.mvc.message;

import haxe.Timer;
import mock.common.MockMessageType;
import com.domwires.core.mvc.context.IContext;
import com.domwires.core.factory.AppFactory;
import com.domwires.core.factory.IAppFactory;
import com.domwires.core.mvc.context.AbstractContext;
import mock.mvc.context.MockContext_1;
import com.domwires.core.mvc.model.AbstractModel;
import com.domwires.core.mvc.model.ModelContainer;
import com.domwires.core.mvc.mediator.AbstractMediator;
import massive.munit.Assert;
import mock.mvc.models.MockModel_1;
import mock.mvc.mediators.MockMediator_1;

class BubblingMessageTest
{
    private var m1:AbstractModel;
    private var c1:AbstractContext;
    private var c2:AbstractContext;
    private var c3:AbstractContext;
    private var c4:AbstractContext;
    private var mc1:ModelContainer;
    private var mc2:ModelContainer;
    private var mc3:ModelContainer;
    private var mc4:ModelContainer;
    private var v1:AbstractMediator;

    private var factory:IAppFactory;

    /**
		 * 			c1
		 * 		 /	|  \
		 * 		c2	c3	c4
		 * 		|	|	|
		 * 		mc1	mc3	mc4
		 * 		|
		 * 		mc2
		 * 		|
		 * 		m1
		 */

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
        factory = new AppFactory();
        factory.mapToValue(IAppFactory, factory);

        c1 = factory.instantiateUnmapped(MockContext_1);
        c2 = factory.instantiateUnmapped(MockContext_1);
        c3 = factory.instantiateUnmapped(MockContext_1);
        c4 = factory.instantiateUnmapped(MockContext_1);
        mc1 = factory.instantiateUnmapped(ModelContainer);
        mc2 = factory.instantiateUnmapped(ModelContainer);
        mc3 = factory.instantiateUnmapped(ModelContainer);
        mc4 = factory.instantiateUnmapped(ModelContainer);
        m1 = factory.instantiateUnmapped(MockModel_1);
        v1 = factory.instantiateUnmapped(MockMediator_1);

        mc2.addModel(m1);
        mc1.addModel(mc2);
        c4.addModel(mc4);
        c3.addModel(mc3);
        c2.addModel(mc1);
        c1.add(c2);
        c1.add(c3);
        c1.add(c4);
        c1.addMediator(v1);
    }

    @After
    public function tearDown():Void
    {
        c1.dispose();
        factory.dispose();
    }

    @Test
    public function testBubblingFromBottomToTop():Void
    {
        var bubbledEventType:EnumValue;

        var successFunc:IMessage -> Void = (m:IMessage) ->
        {
            //message came from bottom to top
            bubbledEventType = m.type;
        };

        //top element
        c1.addMessageListener(MockMessageType.Hello, successFunc);

        //bottom element
        m1.dispatchMessage(MockMessageType.Hello, {name: "Anton"}, true);

        Assert.areEqual(bubbledEventType, MockMessageType.Hello);

        bubbledEventType = null;

        v1.dispatchMessage(MockMessageType.Hello, {name: "Anton"}, true);

        Assert.areEqual(bubbledEventType, MockMessageType.Hello);
    }

    @Test
    public function testBubblingFromBottomToTopPerf():Void
    {
        var bubbledEventType:EnumValue;
        var count:Int;

        var successFunc:IMessage -> Void = m -> {};

        var c1:IContext = factory.instantiateUnmapped(MockContext_1);
        var c2:IContext = factory.instantiateUnmapped(MockContext_1);
        var c3:IContext = factory.instantiateUnmapped(MockContext_1);
        var c4:IContext = factory.instantiateUnmapped(MockContext_1);
        var c5:IContext = factory.instantiateUnmapped(MockContext_1);
        var c6:IContext = factory.instantiateUnmapped(MockContext_1);
        var c7:IContext = factory.instantiateUnmapped(MockContext_1);
        var c8:IContext = factory.instantiateUnmapped(MockContext_1);
        var c9:IContext = factory.instantiateUnmapped(MockContext_1);
        var c10:IContext = factory.instantiateUnmapped(MockContext_1);

        c1.addModel(
            c2.addModel(
                c3.addModel(
                    c4.addModel(
                        c5.addModel(
                            c6.addModel(
                                c7.addModel(
                                    c8.addModel(
                                        c9.addModel(
                                            c10)))))))));


        var time:Float = Timer.stamp();

        for (i in 0...100000)
        {
            count = 0;
            bubbledEventType = null;

            //top element
            c1.addMessageListener(MockMessageType.Hello, successFunc);
            c2.addMessageListener(MockMessageType.Hello, successFunc);
            c3.addMessageListener(MockMessageType.Hello, successFunc);
            c4.addMessageListener(MockMessageType.Hello, successFunc);
            c5.addMessageListener(MockMessageType.Hello, successFunc);
            c6.addMessageListener(MockMessageType.Hello, successFunc);
            c7.addMessageListener(MockMessageType.Hello, successFunc);
            c8.addMessageListener(MockMessageType.Hello, successFunc);
            c9.addMessageListener(MockMessageType.Hello, successFunc);
            c10.addMessageListener(MockMessageType.Hello, successFunc);

            //bottom element
            c10.dispatchMessage(MockMessageType.Hello, {name: "Anton"}, false);
        }

        var timePassed:Float = Timer.stamp() - time;
        trace("timePassed", timePassed);
        Assert.isTrue(timePassed < 5.0);
    }

    @Test
    public function testHierarchy():Void
    {
        Assert.areEqual(mc3.parent, c3);
        Assert.areEqual(mc4.parent, c4);
        Assert.areEqual(m1.parent, mc2);
        Assert.areNotEqual(m1.parent, mc1);
        Assert.areEqual(mc2.parent, mc1);
        Assert.areNotEqual(mc2.parent, c2);
        Assert.areNotEqual(m1.parent, c1);
    }
}
