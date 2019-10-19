package com.domwires.core.mvc.message;

import massive.munit.Assert;
import mock.MockMessage;

class MessageDispatcherTest {
    private var d:MessageDispatcher;

    @BeforeClass
    public function beforeClass():Void {
    }

    @AfterClass
    public function afterClass():Void {
    }

    @Before
    public function setup():Void {
        d = new MessageDispatcher();
    }

    @After
    public function tearDown():Void {
        if (!d.isDisposed) {
            d.dispose();
        }
    }

    @Test
    public function testDispatchMessage():Void {
        var gotMessage:Bool = false;
        var gotMessageType:EnumValue = MockMessage.GoodBye;
        var gotMessageTarget:IMessageDispatcher = null;
        var gotMessageData:Dynamic = {};

        d.addMessageListener(MockMessage.Hello, (event:IMessage) -> {
            gotMessage = true;
            gotMessageType = event.type;
            gotMessageTarget = cast(event.target, IMessageDispatcher);
            gotMessageData.prop = event.data.prop;
        });

        d.dispatchMessage(MockMessage.Hello, {prop:"prop1"});

        Assert.isTrue(gotMessage);
        Assert.areEqual(gotMessageType, MockMessage.Hello);
        Assert.areEqual(gotMessageTarget, d);
        Assert.areEqual(gotMessageData.prop, "prop1");
    }

    @Test
    public function testAddMessageListener():Void
    {
        Assert.isFalse(d.hasMessageListener(MockMessage.Hello));
        d.addMessageListener(MockMessage.Hello, message -> {});
        Assert.isTrue(d.hasMessageListener(MockMessage.Hello));
    }

    @Test
    public function testRemoveAllMessages():Void
    {
        var listener:IMessage -> Void = message -> {};
        d.addMessageListener(MockMessage.Hello, listener);
        d.addMessageListener(MockMessage.Shalom, listener);
        Assert.isTrue(d.hasMessageListener(MockMessage.Hello));
        Assert.isTrue(d.hasMessageListener(MockMessage.Shalom));

        d.removeAllMessageListeners();
        Assert.isFalse(d.hasMessageListener(MockMessage.Hello));
        Assert.isFalse(d.hasMessageListener(MockMessage.Shalom));
    }

    @Test
    public function testRemoveMessageListener():Void
    {
        Assert.isFalse(d.hasMessageListener(MockMessage.Hello));

        var listener:IMessage -> Void = m -> {};
        d.addMessageListener(MockMessage.Hello, listener);
        Assert.isTrue(d.hasMessageListener(MockMessage.Hello));
        Assert.isFalse(d.hasMessageListener(MockMessage.GoodBye));

        d.addMessageListener(MockMessage.GoodBye, listener);
        d.removeMessageListener(MockMessage.Hello, listener);
        Assert.isFalse(d.hasMessageListener(MockMessage.Hello));
        Assert.isTrue(d.hasMessageListener(MockMessage.GoodBye));

        d.removeMessageListener(MockMessage.GoodBye, listener);
        Assert.isFalse(d.hasMessageListener(MockMessage.GoodBye));
    }

    @Test
    public function testDispose():Void
    {
        d.addMessageListener(MockMessage.Hello, m -> {});
        d.addMessageListener(MockMessage.GoodBye, m -> {});
        d.addMessageListener(MockMessage.Shalom, m -> {});
        d.dispose();

        Assert.isFalse(d.hasMessageListener(MockMessage.Hello));
        Assert.isFalse(d.hasMessageListener(MockMessage.GoodBye));
        Assert.isFalse(d.hasMessageListener(MockMessage.Shalom));

        Assert.isTrue(d.isDisposed);
    }

    @Test
    public function testHasMessageListener():Void
    {
        var listener:IMessage -> Void = m -> {};
        d.addMessageListener(MockMessage.Hello, listener);
        Assert.isTrue(d.hasMessageListener(MockMessage.Hello));
    }

    @Test
    public function testEveryBodyReceivedMessage():Void
    {
        var a:Bool;
        var b:Bool;

        var listener_1:IMessage -> Void = m -> a = true;
        var listener_2:IMessage -> Void = m -> b = true;

        d.addMessageListener(MockMessage.Hello, listener_1);
        d.addMessageListener(MockMessage.Hello, listener_2);

        d.dispatchMessage(MockMessage.Hello);

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