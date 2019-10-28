package com.domwires.core.mvc.message;

import com.domwires.core.common.AbstractDisposable;
import com.domwires.core.mvc.message.IMessage;
import haxe.ds.EnumValueMap;

class MessageDispatcher extends AbstractDisposable implements IMessageDispatcher
{
    private var _messageMap:MessageMap;
    private var _message:Message;

    private var isBubbling:Bool;

    public function addMessageListener(type:EnumValue, listener:IMessage -> Void, priority:Int = 0):Void
    {
        if (_messageMap == null)
        {
            _messageMap = new MessageMap();
        }

        var messageMapForType:Array<Listener> = _messageMap.get(type);
        var listenerWithPriority:Listener;
        if (messageMapForType == null)
        {
            messageMapForType = [];
            //To avoid check in this case, if vector contains element
            messageMapForType.push(new Listener(listener, priority));

            _messageMap.set(type, messageMapForType);
        } else
        if (getListenerWithPriority(messageMapForType, listener) == null)
        {
            messageMapForType.push(new Listener(listener, priority));
            sortOnPriority(messageMapForType);
        }
    }

    private function sortOnPriority(messageMapForType:Array<Listener>):Void
    {
        messageMapForType.sort((e_1:Listener, e_2:Listener) -> {
            if (e_1.priority < e_2.priority) return 1;
            if (e_1.priority > e_2.priority) return -1;
            return 0;
        });
    }

    private function getListenerWithPriority(messageMapForType:Array<Listener>, listener:IMessage -> Void):Listener
    {
        for (l in messageMapForType)
        {
            if (l.func == listener)
            {
                return l;
            }
        }

        return null;
    }

    public function removeMessageListener(type:EnumValue, listener:IMessage -> Void):Void
    {
        if (_messageMap != null)
        {
            if (_messageMap.get(type) != null)
            {
                var l:Listener = getListenerWithPriority(_messageMap.get(type), listener);
                if (l != null)
                {
                    _messageMap.get(type).remove(l);
                    if (_messageMap.get(type).length == 0)
                    {
                        _messageMap.remove(type);
                    }
                }
            }
        }
    }

    public function removeAllMessageListeners():Void
    {
        if (_messageMap != null)
        {
            for (v in _messageMap)
            {
                untyped v.length = 0;
            }

            _messageMap = null;
        }
    }

    public function dispatchMessage(type:EnumValue, data:Dynamic = null, bubbles:Bool = true):Void
    {
        if (isBubbling)
        {
            trace("WARNING: You try to dispatch '" + Std.string(type) + "' while '" + Std.string(_message.type) +
                "' is bubbling. Making new instance of IMessage");
        }

        _message = getMessage(type, data, bubbles, isBubbling);
        _message._target = this;
        _message.setCurrentTarget(this);

        handleMessage(_message);

        if (!isDisposed)
        {
            bubbleUpMessage(_message);
        }
    }

    private function bubbleUpMessage(message:Message):Void
    {
        if (message.bubbles)
        {
            isBubbling = true;
            var currentTarget:Dynamic = message._target;
            var bubbleUp:Bool;

            while (currentTarget != null && Reflect.hasField(currentTarget, "_parent"))
            {
                currentTarget = currentTarget._parent;

                if (currentTarget == null)
                {
                    break;
                }

                if (Std.is(currentTarget, IBubbleMessageHandler))
                {
                    // onMessageBubbled() can stop the bubbling by returning false.{

                    bubbleUp = cast((message.setCurrentTarget(currentTarget)), IBubbleMessageHandler)
                        .onMessageBubbled(message);

                    if (!bubbleUp)
                    {
                        break;
                    }
                }
            }
        }

        isBubbling = false;
    }

    public function handleMessage(message:IMessage):Void
    {
        if (_messageMap != null)
        {
            var messageMapForType:Array<Listener> = _messageMap.get(message.type);

            if (messageMapForType != null)
            {
                for (listener in messageMapForType)
                {
                    listener.func(message);
                }
            }
        }
    }

    public function hasMessageListener(type:EnumValue):Bool
    {
        if (_messageMap != null)
        {
            return _messageMap.get(type) != null;
        }

        return false;
    }

    private function getMessage(type:EnumValue, data:Dynamic, bubbles:Bool, forceReturnNew:Bool = false):Message
    {
        if (_message == null || forceReturnNew)
        {
            _message = new Message(type, data, bubbles);
        } else
        {
            _message._type = type;
            _message._data = data;
            _message._bubbles = bubbles;
        }

        return _message;
    }

    override public function dispose():Void
    {
        removeAllMessageListeners();

        _message = null;

        if (_messageMap != null)
        {
            _messageMap.clear();
            _messageMap = null;
        }

        super.dispose();
    }

    public function new()
    {
        super();
    }
}

private class Listener
{

    public var func(get, never):IMessage -> Void;
    public var priority(get, never):Int;

    private var _func:IMessage -> Void;
    private var _priority:Int;

    public function new(func:IMessage -> Void, priority:Int = 0)
    {
        _func = func;
        _priority = priority;
    }

    private function get_priority():Int
    {
        return _priority;
    }

    private function get_func():IMessage -> Void
    {
        return _func;
    }
}

private class MessageMap extends EnumValueMap<EnumValue, Array<Listener>>
{
    override function compare(k1:EnumValue, k2:EnumValue):Int
    {
        var t1 = Type.getEnumName(Type.getEnum(k1));
        var t2 = Type.getEnumName(Type.getEnum(k2));
        if (t1 != t2)
        {
            return t1 < t2 ? -1 : 1;
        }
        return super.compare(k1, k2);
    }
}