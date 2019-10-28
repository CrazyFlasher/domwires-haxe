package com.domwires.core.mvc.message;

import com.domwires.core.common.IDisposableImmutable;

/**
 * @see com.domwires.core.mvc.message.IMessageDispatcher
 */
interface IMessageDispatcherImmutable extends IDisposableImmutable
{
    /**
     * @param type  Message type
     * @return true if object listens for specific message. Otherwise returns false.
     */
    function hasMessageListener(type:EnumValue):Bool;

    /**
     * Add message listener to specified object. Listens bubbled messages also.
     * @param type EnumValue type
     * @param listener Function that will be called when message received
     * @param priority Int With higher priority will be called earlier
     */
    function addMessageListener(type:EnumValue, listener:IMessage -> Void, priority:Int = 0):Void;

    /**
     * Removes message listener from object. Bubbled messages will be also ignored.
     * @param type EnumValue type
     * @param listener Function that will be called when message received
     */
    function removeMessageListener(type:EnumValue, listener:IMessage -> Void):Void;
}

