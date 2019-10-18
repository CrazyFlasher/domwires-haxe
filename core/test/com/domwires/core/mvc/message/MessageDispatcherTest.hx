package com.domwires.core.mvc.message;

import massive.munit.Assert;
import mock.MockMessageType;
class MessageDispatcherTest
{
    private var d:MessageDispatcher;

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
        d = new MessageDispatcher();
    }

    @After
    public function tearDown():Void
    {
        if (!d.isDisposed)
        {
            d.dispose();
        }
    }

    @Test
    public function testDispatchMessage():Void
    {
        var gotMessage:Bool;
        var gotMessageType:Enum;
        var gotMessageTarget:IMessageDispatcher;
        var gotMessageData:Dynamic = {};

        d.addMessageListener(MockMessageType.Preved, (event:IMessage) ->{
            gotMessage = true;
            gotMessageType = event.type;
            gotMessageTarget = cast(event.target, IMessageDispatcher);
            gotMessageData.prop = event.data.prop;
        });

        d.dispatchMessage(MockMessageType.Preved, {prop:"prop1"});

        Assert.isTrue(gotMessage);
        Assert.areEqual(gotMessageType, MockMessageType.Preved);
        Assert.areEqual(gotMessageTarget, d);
        Assert.areEqual(gotMessageData.prop, "prop1");
    }
}
