/**
 * Created by Anton Nefjodov on 30.01.2016.
 */
package com.domwires.core.mvc.message;

import haxe.Constraints.Function;
import com.domwires.core.common.Enum;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import org.flexunit.asserts.AssertEquals;
import org.flexunit.asserts.AssertFalse;
import org.flexunit.asserts.AssertTrue;
import testObject.MyCoolEnum;

class MessageDispatcherTest
{
    
    private var d : MessageDispatcher;
    
    @Before
    public function setUp() : Void
    {
        d = new MessageDispatcher();
    }
    
    @After
    public function tearDown() : Void
    {
        if (!d.isDisposed)
        {
            d.dispose();
        }
    }
    
    @Test
    public function testDispatchMessage() : Void
    {
        var gotMessage : Bool;
        var gotMessageType : Enum;
        var gotMessageTarget : IMessageDispatcher;
        var gotMessageData : Dynamic = { };
        
        d.addMessageListener(MyCoolEnum.PREVED, function(event : IMessage) : Void
                {
                    gotMessage = true;
                    gotMessageType = event.type;
                    gotMessageTarget = try cast(event.target, IMessageDispatcher) catch(e:Dynamic) null;
                    gotMessageData.prop = event.data.prop;
                });
        
        d.dispatchMessage(MyCoolEnum.PREVED, {
                    prop : "prop1"
                });
        
        Assert.isTrue(gotMessage);
        Assert.areEqual(gotMessageType, MyCoolEnum.PREVED);
        Assert.areEqual(gotMessageTarget, d);
        Assert.areEqual(gotMessageData.prop, "prop1");
    }
    
    @Test
    public function testAddMessageListener() : Void
    {
        Assert.isFalse(d.hasMessageListener(MyCoolEnum.PREVED));
        d.addMessageListener(MyCoolEnum.PREVED, function(event : IMessage) : Void
                {
                });
        Assert.isTrue(d.hasMessageListener(MyCoolEnum.PREVED));
    }
    
    @Test
    public function testRemoveAllMessages() : Void
    {
        var listener : Function = function(event : IMessage) : Void
        {
        }
        d.addMessageListener(MyCoolEnum.PREVED, listener);
        d.addMessageListener(MyCoolEnum.BOGA, listener);
        Assert.isTrue(d.hasMessageListener(MyCoolEnum.PREVED));
        Assert.isTrue(d.hasMessageListener(MyCoolEnum.BOGA));
        
        d.removeAllMessageListeners();
        Assert.isFalse(d.hasMessageListener(MyCoolEnum.PREVED));
        Assert.isFalse(d.hasMessageListener(MyCoolEnum.BOGA));
    }
    
    @Test
    public function testRemoveMessageListener() : Void
    {
        Assert.isFalse(d.hasMessageListener(MyCoolEnum.PREVED));
        
        var listener : Function = function(event : IMessage) : Void
        {
        }
        d.addMessageListener(MyCoolEnum.PREVED, listener);
        Assert.isTrue(d.hasMessageListener(MyCoolEnum.PREVED));
        Assert.isFalse(d.hasMessageListener(MyCoolEnum.BOGA));
        
        d.addMessageListener(MyCoolEnum.BOGA, listener);
        d.removeMessageListener(MyCoolEnum.PREVED, listener);
        Assert.isFalse(d.hasMessageListener(MyCoolEnum.PREVED));
        Assert.isTrue(d.hasMessageListener(MyCoolEnum.BOGA));
        
        d.removeMessageListener(MyCoolEnum.BOGA, listener);
        Assert.isFalse(d.hasMessageListener(MyCoolEnum.BOGA));
    }
    
    @Test
    public function testDispose() : Void
    {
        d.addMessageListener(MyCoolEnum.PREVED, function(event : IMessage) : Void
                {
                });
        d.addMessageListener(MyCoolEnum.BOGA, function(event : IMessage) : Void
                {
                });
        d.addMessageListener(MyCoolEnum.SHALOM, function(event : IMessage) : Void
                {
                });
        d.dispose();
        
        Assert.isFalse(d.hasMessageListener(MyCoolEnum.PREVED));
        Assert.isFalse(d.hasMessageListener(MyCoolEnum.BOGA));
        Assert.isFalse(d.hasMessageListener(MyCoolEnum.SHALOM));
        
        Assert.isTrue(d.isDisposed);
    }
    
    @Test
    public function testHasMessageListener() : Void
    {
        var listener : Function = function(event : IMessage) : Void
        {
        }
        d.addMessageListener(MyCoolEnum.PREVED, listener);
        Assert.isTrue(d.hasMessageListener(MyCoolEnum.PREVED));
    }
    
    @Test
    public function testEveryBodyReceivedMessage() : Void
    {
        var a : Bool;
        var b : Bool;
        
        var listener_1 : Function = function(event : IMessage) : Void
        {
            a = true;
        }
        var listener_2 : Function = function(event : IMessage) : Void
        {
            b = true;
        }
        
        d.addMessageListener(MyCoolEnum.PREVED, listener_1);
        d.addMessageListener(MyCoolEnum.PREVED, listener_2);
        
        d.dispatchMessage(MyCoolEnum.PREVED);
        
        Assert.isTrue(a);
        Assert.isTrue(b);
    }
    
    @Test
    public function testEveryBodyReceivedEvent() : Void
    {
        var d : IEventDispatcher = new EventDispatcher();
        var sr_1 : IEventDispatcher = new EventDispatcher();
        var sr_2 : IEventDispatcher = new EventDispatcher();
        
        var a : Bool;
        var b : Bool;
        
        var listener_1 : Function = function(event : Event) : Void
        {
            a = true;
        }
        var listener_2 : Function = function(event : Event) : Void
        {
            b = true;
        }
        
        d.addEventListener("test", listener_1);
        d.addEventListener("test", listener_2);
        
        d.dispatchEvent(new Event("test"));
        
        Assert.isTrue(a);
        Assert.isTrue(b);
    }

    public function new()
    {
    }
}

