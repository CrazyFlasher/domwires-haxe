/**
 * Created by Anton Nefjodov on 10.06.2016.
 */
package com.domwires.core.mvc.message;

import haxe.Constraints.Function;
import com.domwires.core.common.AbstractDisposable;
import com.domwires.core.common.Enum;

import com.domwires.core.mvc.message.IMessage;

/**
	 * Common message dispatcher. Can be used for listening and dispatching messages for views and models.
	 */
class MessageDispatcher extends AbstractDisposable implements IMessageDispatcher
{
    private var _messageMap : haxe.ds.ObjectMap<Dynamic, Dynamic>;
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
            _messageMap = new haxe.ds.ObjectMap<Dynamic, Dynamic>();
        }
        
        if (_messageMap.get(type) == null)
        {
            _messageMap.set(type, []);
            //To avoid check in this case, if vector contains element
            _messageMap.get(type).push(listener);
        }
        else if (Lambda.indexOf(_messageMap.get(type), listener) == -1)
        {
            _messageMap.get(type).push(listener);
        }
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeMessageListener(type : Enum, listener : Function) : Void
    {
        if (_messageMap != null)
        {
            if (_messageMap.get(type) != null)
            {
                _messageMap.get(type).removeAt(Lambda.indexOf(_messageMap.get(type), listener));
                if (_messageMap.get(type).length == 0)
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
            for (v/* AS3HX WARNING could not determine type for var: v exp: EIdent(_messageMap) type: haxe.ds.ObjectMap<Dynamic, Dynamic> */ in _messageMap)
            {
                v.length = 0;
            }
            
            _messageMap = null;
        }
    }
    
    /**
		 * @inheritDoc
		 */
    public function dispatchMessage(type : Enum, data : Dynamic = null, bubbles : Bool = false) : Void
    {
        if (isBubbling)
        {
            log("WARNING: You try to dispatch '" + Std.string(type) + "' while '" + Std.string(_message.type) + "' is bubbling. Making" +
                    " new instance of IMessage");
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
    
    private function bubbleUpMessage(message : Message) : Void
    {
        if (message.bubbles)
        {
            isBubbling = true;
            var currentTarget : Dynamic = message._target;
            var bubbleUp : Bool;
            while (currentTarget && currentTarget.exists("parent"))
            {
                currentTarget = Reflect.field(currentTarget, "parent");
                
                if (currentTarget == null)
                {
                    break;
                }
                
                if (Std.is(currentTarget, IBubbleMessageHandler))
                
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
        else if (Lambda.indexOf(extraMessagesHandlerList, object) == -1)
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
        
        var objectIndex : Int = Lambda.indexOf(extraMessagesHandlerList, object);
        if (objectIndex != -1)
        {
            extraMessagesHandlerList.splice(objectIndex, 1)[0];
        }
    }
    
    /**
		 * @inheritDoc
		 */
    public function handleMessage(message : IMessage) : Void
    {
        if (_messageMap != null)
        {
            if (_messageMap.get(message.type) != null)
            {
                var listener : Function;
                for (listener/* AS3HX WARNING could not determine type for var: listener exp: EArray(EIdent(_messageMap),EField(EIdent(message),type)) type: haxe.ds.ObjectMap<Dynamic, Dynamic> */ in _messageMap.get(message.type))
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
            return _messageMap.get(type) != null;
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



class Message implements IMessage
{
    public var type(get, never) : Enum;
    public var data(get, never) : Dynamic;
    public var bubbles(get, never) : Bool;
    public var target(get, never) : Dynamic;
    public var currentTarget(get, never) : Dynamic;
    public var previousTarget(get, never) : Dynamic;

    @:allow(com.domwires.core.mvc.message)
    private var _type : Enum;
    @:allow(com.domwires.core.mvc.message)
    private var _data : Dynamic;
    @:allow(com.domwires.core.mvc.message)
    private var _bubbles : Bool;
    @:allow(com.domwires.core.mvc.message)
    private var _target : Dynamic;
    @:allow(com.domwires.core.mvc.message)
    private var _previousTarget : Dynamic;
    
    private var _currentTarget : Dynamic;
    
    @:allow(com.domwires.core.mvc.message)
    private function new(type : Enum, data : Dynamic = null, bubbles : Bool = true)
    {
        _type = type;
        _data = data;
        _bubbles = bubbles;
    }
    
    @:allow(com.domwires.core.mvc.message)
    private function setCurrentTarget(value : Dynamic) : Dynamic
    {
        _previousTarget = _currentTarget;
        
        _currentTarget = value;
        
        return _currentTarget;
    }
    
    private function get_type() : Enum
    {
        return _type;
    }
    
    private function get_data() : Dynamic
    {
        return _data;
    }
    
    private function get_bubbles() : Bool
    {
        return _bubbles;
    }
    
    private function get_target() : Dynamic
    {
        return _target;
    }
    
    private function get_currentTarget() : Dynamic
    {
        return _currentTarget;
    }
    
    private function get_previousTarget() : Dynamic
    {
        return _previousTarget;
    }
}
