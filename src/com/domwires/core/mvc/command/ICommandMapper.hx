/**
 * Created by Anton Nefjodov on 26.05.2016.
 */
package com.domwires.core.mvc.command;

import com.domwires.core.common.Enum;
import com.domwires.core.common.IDisposable;
import com.domwires.core.mvc.message.IMessage;

//TODO: execution guards?
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
		 * @return
		 */
    function map(messageType : Enum, commandClass : Class<Dynamic>, data : Dynamic = null, once : Bool = false) : MappingConfig
    ;
    
    /**
		 * @see #map
		 */
    function map1(messageType : Enum, commandClassList : Array<Class<Dynamic>>, data : Dynamic = null, once : Bool = false) : MappingConfigList
    ;
    
    /**
		 * @see #map
		 */
    function map2(messageTypeList : Array<Enum>, commandClass : Class<Dynamic>, data : Dynamic = null, once : Bool = false) : MappingConfigList
    ;
    
    /**
		 * @see #map
		 */
    function map3(messageTypeList : Array<Enum>, commandClassList : Array<Class<Dynamic>>, data : Dynamic = null, once : Bool = false) : MappingConfigList
    ;
    
    /**
		 * Unmaps message from command.
		 * @param messageType
		 * @param commandClass
		 * @return
		 */
    function unmap(messageType : Enum, commandClass : Class<Dynamic>) : ICommandMapper
    ;
    
    /**
		 * Clears all mappings.
		 * @return
		 */
    function clear() : ICommandMapper
    ;
    
    /**
		 * Unmaps all commands from specified message.
		 * @param messageType
		 * @return
		 */
    function unmapAll(messageType : Enum) : ICommandMapper
    ;
    
    /**
		 * Trying to find and execute commands, mapped to current message type.
		 * @param message
		 */
    function tryToExecuteCommand(message : IMessage) : Void
    ;
    
    /**
		 * Execute command manually.
		 * @param commandClass
		 * @param data Plain data object, which properties will be injected into <code>ICommand</code>
		 */
    function executeCommand(commandClass : Class<Dynamic>, data : Dynamic = null) : Void
    ;
    private static var ICommandMapper_static_initializer = {
        CommandMapper;
        true;
    }

}

