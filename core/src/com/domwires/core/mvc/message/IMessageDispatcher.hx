package com.domwires.core.mvc.message;

import com.domwires.core.common.IDisposable;
import com.domwires.core.mvc.message.IMessageDispatcherImmutable;

/**
 * Common message dispatcher. Can be used for listening and dispatching messages for views and models.
 * Bubbling feature in any objects (Not only DisplayObjects, like in EventDispatcher).
 */
interface IMessageDispatcher extends IMessageDispatcherImmutable extends IDisposable
{

    /**
     * Handle specified message without dispatching it.
     * @param message
     */
    function handleMessage(message:IMessage):Void;

    /**
     * Removes all message listeners from object. Bubbled messages will be also ignored.
     */
    function removeAllMessageListeners():Void;

    /**
     * Dispatches message from bottom to top of the hierarchy.
     * @param type Message type
     * @param data Optional data that will sent with message
     * @param bubbles If true, then message will bubble up to hierarchy
     */
    function dispatchMessage(type:EnumValue, data:Dynamic = null, bubbles:Bool = false):Void;
}

