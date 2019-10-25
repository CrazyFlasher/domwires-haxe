package com.domwires.core.mvc.message;

import com.domwires.core.common.AbstractDisposable;
import com.domwires.core.mvc.message.IMessage;

class MessageDispatcher extends AbstractDisposable implements IMessageDispatcher
{
    private var _messageMap:Map<EnumValue, Array<IMessage -> Void>>;
    private var _message:Message;

    private var isBubbling:Bool;

    public function addMessageListener(type:EnumValue, listener:IMessage -> Void):Void
    {
        if (_messageMap == null)
        {
            _messageMap = new Map<EnumValue, Array<IMessage -> Void>>();
        }

        var messageMapForType:Array<IMessage -> Void> = _messageMap.get(type);
        if (messageMapForType == null)
        {
            messageMapForType = [];
            //To avoid check in this case, if vector contains element
            messageMapForType.push(listener);

            _messageMap.set(type, messageMapForType);
        } else
        if (messageMapForType.indexOf(listener) == -1)
        {
            messageMapForType.push(listener);
        }
    }

    public function removeMessageListener(type:EnumValue, listener:IMessage -> Void):Void
    {
        if (_messageMap != null)
        {
            if (_messageMap.get(type) != null)
            {
                _messageMap.get(type).remove(listener);
                if (_messageMap.get(type).length == 0)
                {
                    _messageMap.remove(type);
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

            while (currentTarget != null && currentTarget._parent != null)
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
            if (_messageMap.get(message.type) != null)
            {
                for (listener in _messageMap.get(message.type))
                {
                    listener(message);
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
        }
        else
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
