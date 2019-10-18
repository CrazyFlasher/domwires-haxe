/**
 * Created by Anton Nefjodov on 10.06.2016.
 */
package com.domwires.core.mvc.message;

import com.domwires.core.common.AbstractDisposable;
import com.domwires.core.common.Enum;
import com.domwires.core.mvc.message.IMessage;
import openfl.utils.Dictionary;
import openfl.utils.Function;

/**
	 * Common message dispatcher. Can be used for listening and dispatching messages for views and models.
	 */
class MessageDispatcher extends AbstractDisposable implements IMessageDispatcher
{
    private var _messageMap : Dictionary<Enum, Array<Function>>;
    private var _message : Message;
    
    private var extraMessagesHandlerList : Array<IMessageDispatcher>;
    private var isBubbling : Bool;
    
    /**
		 * @inheritDoc
		 */
    public function addMessageListener(type : Enum, listener : Function) : Void
    {
        if (_messageMap == null)
        {
            _messageMap = new Dictionary();
        }
        
        if (_messageMap[type] == null)
        {
            _messageMap[type] = [];
            //To avoid check in this case, if vector contains element
            _messageMap[type].push(listener);
        }
        else if (_messageMap[type].indexOf(listener) == -1)
        {
            _messageMap[type].push(listener);
        }
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeMessageListener(type : Enum, listener : Function) : Void
    {
        if (_messageMap != null)
        {
            if (_messageMap[type] != null)
            {
                _messageMap[type].remove(listener);
                if (_messageMap[type].length == 0)
                {
                    _messageMap.remove(type);
                }
            }
        }
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeAllMessageListeners() : Void
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
    
    /**
		 * @inheritDoc
		 */
    public function dispatchMessage(type : Enum, data : Dynamic = null, bubbles : Bool = false) : Void
    /*if (isBubbling)
			{
				log("WARNING: You try to dispatch '" + type.toString() + "' while '" + _message.type.toString() + "' is bubbling. Making" +
					" new instance of IMessage");
			}*/
    {
        
        
        _message = getMessage(type, data, bubbles, isBubbling);
        _message._target = this;
        _message.setCurrentTarget(this);
        
        handleMessage(_message);
        
        if (!isDisposed)
        {
            bubbleUpMessage(_message);
        }
    }
    
    private function bubbleUpMessage(message : Message) : Void
    {
        if (message.bubbles)
        {
            isBubbling = true;
            var currentTarget : Dynamic = message._target;
            var bubbleUp : Bool;
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
                    
                    bubbleUp = cast((message.setCurrentTarget(currentTarget)), IBubbleMessageHandler).onMessageBubbled(message);
                    
                    if (!bubbleUp)
                    {
                        break;
                    }
                }
            }
            
            if (extraMessagesHandlerList != null)
            {
                var extraMessagesHandler : IMessageDispatcher;
                for (extraMessagesHandler in extraMessagesHandlerList)
                {
                    currentTarget = extraMessagesHandler;
                    extraMessagesHandler.handleMessage(message);
                }
            }
        }
        isBubbling = false;
    }
    
    /**
		 * @inheritDoc
		 */
    public function registerExtraMessageHandler(object : IMessageDispatcher) : Void
    {
        if (extraMessagesHandlerList == null)
        {
            extraMessagesHandlerList = [object];
        }
        else if (extraMessagesHandlerList.indexOf(object) == -1)
        {
            extraMessagesHandlerList.push(object);
        }
    }
    
    /**
		 * @inheritDoc
		 */
    public function unRegisterExtraMessageHandler(object : IMessageDispatcher) : Void
    {
        if (extraMessagesHandlerList == null)
        {
            return;
        }
        
        var objectIndex : Int = extraMessagesHandlerList.indexOf(object);
        if (objectIndex != -1)
        {
//            extraMessagesHandlerList.splice(objectIndex, 1)[0];
            extraMessagesHandlerList.remove(object);
        }
    }
    
    /**
		 * @inheritDoc
		 */
    public function handleMessage(message : IMessage) : Void
    {
        if (_messageMap != null)
        {
            if (_messageMap[message.type] != null)
            {
                var listener : Function;
                for (listener in _messageMap[message.type])
                {
                    listener(message);
                }
            }
        }
    }

    /**
		 * @inheritDoc
		 */
    public function hasMessageListener(type : Enum) : Bool
    {
        if (_messageMap != null)
        {
            return _messageMap[type] != null;
        }
        
        return false;
    }
    
    private function getMessage(type : Enum, data : Dynamic, bubbles : Bool, forceReturnNew : Bool = false) : Message
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
    
    /**
		 * Disposes and removes all message listeners.
		 */
    override public function dispose() : Void
    {
        removeAllMessageListeners();
        
        extraMessagesHandlerList = null;
        
        _message = null;
        //TODO: memory leaks test
        _messageMap = null;
        
        super.dispose();
    }

    public function new()
    {
        super();
    }
}
