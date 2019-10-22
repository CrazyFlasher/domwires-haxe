package com.domwires.core.mvc.message;

import massive.munit.Assert;
import mock.common.MockMessageType;

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
        var gotMessage:Bool = false;
        var gotMessageType:EnumValue = MockMessageType.GoodBye;
        var gotMessageTarget:IMessageDispatcher = null;
        var gotMessageData:Dynamic = {};

        d.addMessageListener(MockMessageType.Hello, (event:IMessage) ->
        {
            gotMessage = true;
            gotMessageType = event.type;
            gotMessageTarget = cast(event.target, IMessageDispatcher);
            gotMessageData.prop = event.data.prop;
        });

        d.dispatchMessage(MockMessageType.Hello, {prop:"prop1"});

        Assert.isTrue(gotMessage);
        Assert.areEqual(gotMessageType, MockMessageType.Hello);
        Assert.areEqual(gotMessageTarget, d);
        Assert.areEqual(gotMessageData.prop, "prop1");
    }

    @Test
    public function testAddMessageListener():Void
    {
        Assert.isFalse(d.hasMessageListener(MockMessageType.Hello));
        d.addMessageListener(MockMessageType.Hello, message ->
        {});
        Assert.isTrue(d.hasMessageListener(MockMessageType.Hello));
    }

    @Test
    public function testRemoveAllMessages():Void
    {
        var listener:IMessage -> Void = message ->
        {};
        d.addMessageListener(MockMessageType.Hello, listener);
        d.addMessageListener(MockMessageType.Shalom, listener);
        Assert.isTrue(d.hasMessageListener(MockMessageType.Hello));
        Assert.isTrue(d.hasMessageListener(MockMessageType.Shalom));

        d.removeAllMessageListeners();
        Assert.isFalse(d.hasMessageListener(MockMessageType.Hello));
        Assert.isFalse(d.hasMessageListener(MockMessageType.Shalom));
    }

    @Test
    public function testRemoveMessageListener():Void
    {
        Assert.isFalse(d.hasMessageListener(MockMessageType.Hello));

        var listener:IMessage -> Void = m ->
        {};
        d.addMessageListener(MockMessageType.Hello, listener);
        Assert.isTrue(d.hasMessageListener(MockMessageType.Hello));
        Assert.isFalse(d.hasMessageListener(MockMessageType.GoodBye));

        d.addMessageListener(MockMessageType.GoodBye, listener);
        d.removeMessageListener(MockMessageType.Hello, listener);
        Assert.isFalse(d.hasMessageListener(MockMessageType.Hello));
        Assert.isTrue(d.hasMessageListener(MockMessageType.GoodBye));

        d.removeMessageListener(MockMessageType.GoodBye, listener);
        Assert.isFalse(d.hasMessageListener(MockMessageType.GoodBye));
    }

    @Test
    public function testDispose():Void
    {
        d.addMessageListener(MockMessageType.Hello, m ->
        {});
        d.addMessageListener(MockMessageType.GoodBye, m ->
        {});
        d.addMessageListener(MockMessageType.Shalom, m ->
        {});
        d.dispose();

        Assert.isFalse(d.hasMessageListener(MockMessageType.Hello));
        Assert.isFalse(d.hasMessageListener(MockMessageType.GoodBye));
        Assert.isFalse(d.hasMessageListener(MockMessageType.Shalom));

        Assert.isTrue(d.isDisposed);
    }

    @Test
    public function testHasMessageListener():Void
    {
        var listener:IMessage -> Void = m ->
        {};
        d.addMessageListener(MockMessageType.Hello, listener);
        Assert.isTrue(d.hasMessageListener(MockMessageType.Hello));
    }

    @Test
    public function testEveryBodyReceivedMessage():Void
    {
        var a:Bool;
        var b:Bool;

        var listener_1:IMessage -> Void = m -> a = true;
        var listener_2:IMessage -> Void = m -> b = true;

        d.addMessageListener(MockMessageType.Hello, listener_1);
        d.addMessageListener(MockMessageType.Hello, listener_2);

        d.dispatchMessage(MockMessageType.Hello);

        Assert.isTrue(a);
        Assert.isTrue(b);
    }

    //Expecting no errors
    /*@Test
    @Ignore
    public function testCallBackWithoutMessageArgument():Void
    {
        d.addMessageListener(MockMessage.Hello, handler);
        d.dispatchMessage(MockMessage.Hello);
    }

    private function handler():Void {}*/
}