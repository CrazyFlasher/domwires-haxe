package com.domwires.core.mvc.message;

import com.domwires.core.common.AbstractDisposable;
import com.domwires.core.mvc.message.IMessage;

class MessageDispatcher extends AbstractDisposable implements IMessageDispatcher
{
    private var _messageMap:Map<Enum<Dynamic>, Array<IMessage -> Void>>;
    private var _message:Message;

    private var isBubbling:Bool;

    public function addMessageListener(type:Enum<Dynamic>, listener:IMessage -> Void):Void
    {
        if (_messageMap == null)
        {
            _messageMap = new Map<Enum, Array<IMessage -> Void>>();
        }

        if (_messageMap.get(type) == null)
        {
            _messageMap.get(type) = [];
            //To avoid check in this case, if vector contains element
            _messageMap.get(type).push(listener);
        }
        else
        if (_messageMap.get(type).indexOf(listener) == -1)
        {
            _messageMap.get(type).push(listener);
        }
    }

    public function removeMessageListener(type:Enum<Dynamic>, listener:IMessage -> Void):Void
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

    public function dispatchMessage(type:Enum<Dynamic>, data:Dynamic = null, bubbles:Bool = false):Void
    {
        if (isBubbling)
        {
            trace("WARNING: You try to dispatch '" + Std.string(type) + "' while '" + Std.string(_message.type) +
            "' is bubbling. Making new instance of IMessage");

            _message = getMessage(type, data, bubbles, isBubbling);
            _message._target = this;
            _message.setCurrentTarget(this);

            handleMessage(_message);

            if (!isDisposed)
            {
                bubbleUpMessage(_message);
            }
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
                var listener:IMessage -> Void;
                for (listener in _messageMap(message.type))
                {
                    listener(message);
                }
            }
        }
    }

    public function hasMessageListener(type:Enum<Dynamic>):Bool
    {
        if (_messageMap != null)
        {
            return _messageMap.get(type) != null;
        }

        return false;
    }

    private function getMessage(type:Enum<Dynamic>, data:Dynamic, bubbles:Bool, forceReturnNew:Bool = false):Message
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
        _messageMap.clear();
        _messageMap = null;

        super.dispose();
    }

    public function new()
    {
        super();
    }
}
