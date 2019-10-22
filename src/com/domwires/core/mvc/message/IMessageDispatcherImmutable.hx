package com.domwires.core.mvc.message;

import com.domwires.core.common.IDisposableImmutable;

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
    function hasMessageListener(type:EnumValue):Bool;

    /**
     * Add message listener to specified object. Listens bubbled messages also.
     * @param type Message type
     * @param listener Function that will be called when message received
     */
    function addMessageListener(type:EnumValue, listener:IMessage -> Void):Void;

    /**
     * Removes message listener from object. Bubbled messages will be also ignored.
     * @param type Message type
     * @param listener Function that will be called when message received
     */
    function removeMessageListener(type:EnumValue, listener:IMessage -> Void):Void;
}

