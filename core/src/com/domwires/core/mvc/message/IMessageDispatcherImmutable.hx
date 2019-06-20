/**
 * Created by CrazyFlasher on 6.11.2016.
 */
package com.domwires.core.mvc.message;

import com.domwires.core.common.IDisposableImmutable;
import haxe.Constraints.Function;
import com.domwires.core.common.Enum;
/**
	 * @see com.domwires.core.mvc.message.IMessageDispatcher
	 */
interface IMessageDispatcherImmutable extends IDisposableImmutable
{

    /**
		 * Returns true if object listens for specific message. Otherwise returns false.
		 * @param type  Message type
		 * @return
		 */
    function hasMessageListener(type : Enum) : Bool
    ;
    
    /**
		 * Add message listener to specified object. Listens bubbled messages also.
		 * @param type Message type
		 * @param listener Function that will be called when message received
		 */
    function addMessageListener(type : Enum, listener : Function) : Void
    ;
    
    /**
		 * Removes message listener from object. Bubbled messages will be also ignored.
		 * @param type Message type
		 * @param listener Function that will be called when message received
		 */
    function removeMessageListener(type : Enum, listener : Function) : Void
    ;
    
    /**
		 * Removes all message listeners from object. Bubbled messages will be also ignored.
		 */
    function removeAllMessageListeners() : Void
    ;
    
    /**
		 * Dispatches message from bottom to top of the hierarchy.
		 * @param type Message type
		 * @param data Optional data that will sent with message
		 * @param bubbles If true, then message will bubble up to hierarchy
		 */
    function dispatchMessage(type : Enum, data : Dynamic = null, bubbles : Bool = false) : Void
    ;
    
    /**
		 * Makes provided object to handle messages of this instance.
		 * @param object Object, that will handle messages
		 */
    function registerExtraMessageHandler(object : IMessageDispatcher) : Void
    ;
    /**
		 * Makes provided object to stop handle bubbled messages of this instance.
		 * @param object Object, that will not handle messages anymore
		 */
    function unRegisterExtraMessageHandler(object : IMessageDispatcher) : Void
    ;
}

