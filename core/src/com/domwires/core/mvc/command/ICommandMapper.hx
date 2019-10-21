/**
 * Created by Anton Nefjodov on 26.05.2016.
 */
package com.domwires.core.mvc.command;

import com.domwires.core.common.IDisposable;
import com.domwires.core.mvc.message.IMessage;

/**
 * Maps specific messages to <code>ICommand</code>.
 */
interface ICommandMapper extends ICommandMapperImmutable extends IDisposable
{
	/**
     * Maps message to command. When message occurred, specified command will be implemented.
     * @param messageType
     * @param commandClass
     * @param data Plain data object, which properties will be injected into <code>ICommand</code>.
     * 			   If command executed via message, and message contains data object, data specified in map method will be
     *			   overridden by <code>IMessage</code> data
     * @param once Messaged will be automatically unmapped, after command execution
     * @param stopOnExecute If true, <code>ICommandMapper</code> will stop executing other commands mapped to current message
     * @return
     */
	function map(messageType:EnumValue, commandClass:Class<Dynamic>, data:Dynamic = null, once:Bool = false,
				 stopOnExecute:Bool = false):MappingConfig;

	/**
     * @see #map
     */
	function map1(messageType:EnumValue, commandClassList:Array<Class<Dynamic>>, data:Dynamic = null, once:Bool = false,
				  stopOnExecute:Bool = false):MappingConfigList;

	/**
     * @see #map
     */
	function map2(messageTypeList:Array<EnumValue>, commandClass:Class<Dynamic>, data:Dynamic = null, once:Bool = false,
				  stopOnExecute:Bool = false):MappingConfigList;

	/**
     * @see #map
     */
	function map3(messageTypeList:Array<EnumValue>, commandClassList:Array<Class<Dynamic>>, data:Dynamic = null, once:Bool = false,
				  stopOnExecute:Bool = false):MappingConfigList;

	/**
     * Unmaps message from command.
     * @param messageType
     * @param commandClass
     * @return
     */
	function unmap(messageType:EnumValue, commandClass:Class<Dynamic>):ICommandMapper;

	/**
     * Clears all mappings.
     * @return
     */
	function clear():ICommandMapper;

	/**
     * Unmaps all commands from specified message.
     * @param messageType
     * @return
     */
	function unmapAll(messageType:EnumValue):ICommandMapper;

	/**
     * Trying to find and execute commands, mapped to current message type.
     * @param message
     */
	function tryToExecuteCommand(message:IMessage):Void;

	/**
     * Execute command manually.
     * @param commandClass
     * @param data Plain data object, which properties will be injected into <code>ICommand</code>
     * @param guardList List of guards, that will allow or not command execution
     * @param guardNotList List of opposite guards
     */
	function executeCommand(commandClass:Class<Dynamic>, data:Dynamic = null, guardList:Array<Class<Dynamic>> = null,
							guardNotList:Array<Class<Dynamic>> = null):Bool;

	/**
	 * If true, then message data object will be merged with mapping data object. Mapping data will
	 * be in priority. Otherwise mapping data will be replaced by message data (if has one).
	 * By default is false, and mapping data will be replaced with message data (if has one).
	 * @param value
	 * @return
	 */
	function setMergeMessageDataAndMappingData(value:Bool):ICommandMapper;
}

