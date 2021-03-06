package com.domwires.core.mvc.command;

import com.domwires.core.common.IDisposableImmutable;

/**
 * @see com.domwires.core.mvc.command.ICommandMapper
 */
interface ICommandMapperImmutable extends IDisposableImmutable
{
	/**
     * @param messageType
     * @return true, if there are mapping of command to current message.
     */
	function hasMapping(messageType:EnumValue):Bool;
}

