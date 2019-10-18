/**
 * Created by Anton Nefjodov on 26.05.2016.
 */
package com.domwires.core.mvc.command;

import com.domwires.core.common.AbstractDisposable;
import com.domwires.core.common.Enum;
import com.domwires.core.mvc.context.IContext;
import com.domwires.core.mvc.message.IMessage;
import openfl.utils.Dictionary;

/**
	 * @see com.domwires.core.mvc.command.ICommandMapper
	 */
class CommandMapper extends AbstractDisposable implements ICommandMapper
{
    public var verbose(never, set) : Bool;

    private var instanceMap : Dictionary<Class<Dynamic>, Dynamic> = new Dictionary();
    
    private var commandMap : Dictionary<Enum, Array<MappingConfig>> = new Dictionary();
    
    private var _verbose : Bool;

    private var lastCommandData:Dynamic;

    /**
		 * @inheritDoc
		 */
    override public function dispose() : Void
    {
        clear();

        instanceMap = null;
        commandMap = null;

        super.dispose();
    }
    
    private function init() : Void
    {

    }
    
    private function set_verbose(value : Bool) : Bool
    {
        _verbose = value;
        return value;
    }
    
    /**
		 * @inheritDoc
		 */
    public function map(messageType : Enum, commandClass : Class<Dynamic>, data : Dynamic = null, once : Bool = false, stopOnExecute : Bool = false) : MappingConfig
    {
        var mappingConfig:MappingConfig = new MappingConfig(commandClass, data, once, stopOnExecute);
        if (commandMap[messageType] == null)
        {
            commandMap[messageType] = new Array<MappingConfig>();
            commandMap[messageType].push(mappingConfig);
        } else
        if (mappingListContains(commandMap[messageType], commandClass) == null)
        {
            commandMap[messageType].push(mappingConfig);
        }
        
        return mappingConfig;
    }
    
    /**
		 * @inheritDoc
		 */
    public function map1(messageType : Enum, commandClassList : Array<Class<Dynamic>>, data : Dynamic = null,
            once : Bool = false, stopOnExecute : Bool = false) : MappingConfigList
    {
        var commandClass : Class<Dynamic>;
        var mappingConfigList : MappingConfigList = new MappingConfigList();
        
        for (commandClass in commandClassList)
        {
            var soe : Bool = stopOnExecute && commandClassList.indexOf(commandClass) == commandClassList.length - 1;
            mappingConfigList.push(map(messageType, commandClass, data, once, soe));
        }
        
        return mappingConfigList;
    }
    
    /**
		 * @inheritDoc
		 */
    public function map2(messageTypeList : Array<Enum>, commandClass : Class<Dynamic>,
            data : Dynamic = null, once : Bool = false, stopOnExecute : Bool = false) : MappingConfigList
    {
        var messageType : Enum;
        var mappingConfigList : MappingConfigList = new MappingConfigList();
        
        for (messageType in messageTypeList)
        {
            var soe : Bool = stopOnExecute && messageTypeList.indexOf(messageType) == messageTypeList.length - 1;
            mappingConfigList.push(map(messageType, commandClass, data, once, soe));
        }
        
        return mappingConfigList;
    }
    
    /**
		 * @inheritDoc
		 */
    public function map3(messageTypeList : Array<Enum>, commandClassList : Array<Class<Dynamic>>,
            data : Dynamic = null, once : Bool = false, stopOnExecute : Bool = false) : MappingConfigList
    {
        var commandClass : Class<Dynamic>;
        var messageType : Enum;
        var mappingConfigList : MappingConfigList = new MappingConfigList();
        
        for (commandClass in commandClassList)
        {
            for (messageType in messageTypeList)
            {
                var soe : Bool = stopOnExecute
                    && messageTypeList.indexOf(messageType) == messageTypeList.length - 1
                    && commandClassList.indexOf(commandClass) == commandClassList.length - 1;
                
                mappingConfigList.push(map(messageType, commandClass, data, once, soe));
            }
        }
        
        return mappingConfigList;
    }
    
    private static function mappingListContains(list : Array<MappingConfig>, commandClass : Class<Dynamic>, ignoreGuards : Bool = false) : MappingConfig
    {
        var mappingVo : MappingConfig;
        for (mappingVo in list)
        {
            if (mappingVo.commandClass == commandClass)
            {
                var hasGuards : Bool = !ignoreGuards && mappingVo.guardList != null && mappingVo.guardList.length > 0;
                return (hasGuards) ? null : mappingVo;
            }
        }
        
        return null;
    }
    
    /**
		 * @inheritDoc
		 */
    public function unmap(messageType : Enum, commandClass : Class<Dynamic>) : ICommandMapper
    {
        if (commandMap[messageType] != null)
        {
            var mappingVo : MappingConfig = mappingListContains(commandMap[messageType], commandClass, true);
            if (mappingVo != null)
            {
                commandMap[messageType].remove(mappingVo);
                
                if (commandMap[messageType].length == 0)
                {
                    commandMap.remove(messageType);
                }
            }
        }
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function clear() : ICommandMapper
    {
        lastCommandData = null;
        commandMap = new Dictionary();

        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function tryToExecuteCommand(message : IMessage) : Void
    {
        var messageType : Enum = message.type;
        var mappedToMessageCommands : Array<MappingConfig> = commandMap[messageType];
        if (mappedToMessageCommands != null)
        {
            var mappingVo : MappingConfig;
            var commandClass : Class<Dynamic>;
            var injectionData : Dynamic;
            for (mappingVo in mappedToMessageCommands)
            {
                injectionData = message.data == null ? mappingVo.data : message.data;

                commandClass = mappingVo.commandClass;
                
                var success : Bool = executeCommand(commandClass, injectionData, mappingVo.guardList, mappingVo.oppositeGuardList);
                
                if (success)
                {
                    if (mappingVo.once)
                    {
                        unmap(messageType, commandClass);
                    }
                    
                    if (mappingVo.stopOnExecute)
                    {
                        break;
                    }
                }
            }
        }
    }
    
    private function guardsAllow(guardList : Array<Class<Dynamic>>, data : Dynamic = null, logExecution : Bool = false, opposite : Bool = false) : Bool
    {
        var guardClass : Class<Dynamic>;
        var guards : IGuards;
        
        var guardsAllow : Bool = true;
        
        for (guardClass in guardList)
        {
            guards = getGuardSingleton(guardClass, data);

            var allows : Bool = !(opposite) ? guards.allows : !guards.allows;
            
            if (_verbose)
            {
                trace("Guards '" + Type.getClassName(guardClass) + "' allow: " + allows);
            }
            
            if (!allows)
            {
                if (_verbose)
                {
                    guardsAllow = false;
                }
                else
                {
                    guards.clear();
                    return false;
                }
            }

            guards.clear();
        }
        return guardsAllow;
    }

    private function getGuardSingleton(clazz:Class<Dynamic>, data:Dynamic):IGuards
    {
        var guards:IGuards;

//        if (instanceMap[clazz] == null)
//        {
            guards = Type.createInstance(clazz, [context]);

//            instanceMap[clazz] = guards;
//        } else
//        {
//            guards = instanceMap[clazz];
//        }

        guards.setData(data);

        return guards;
    }

    private function getCommandSingleton(clazz:Class<Dynamic>, data:Dynamic):ICommand
    {
        var command:ICommand;

//        if (instanceMap[clazz] == null)
//        {
            command = Type.createInstance(clazz, [context]);

//            instanceMap[clazz] = command;
//        } else
//        {
//            command = instanceMap[clazz];
//        }

        command.setData(data);

        return command;
    }

    /**
		 * @inheritDoc
		 */
    public function executeCommand(commandClass : Class<Dynamic>, data : Dynamic = null, guardList : Array<Class<Dynamic>> = null, guardNotList : Array<Class<Dynamic>> = null) : Bool
    {
        if (data != null)
        {
            lastCommandData = data;
        }

        var logFailExecution : Bool = false;
        var logSuccessExecution : Bool = false;
        
        if (_verbose)
        {
            logFailExecution = true;
            logSuccessExecution = true;
            
            if ((guardList != null || guardNotList != null) && logFailExecution)
            {
                trace("----------------------------------------------");
                trace("Checking guards for '" + Type.getClassName(commandClass) + "'");
            }
        }
        
        if (
            (guardList == null || (guardList != null && guardsAllow(guardList, lastCommandData, logFailExecution))) &&
            (guardNotList == null || (guardNotList != null && guardsAllow(guardNotList, lastCommandData, logFailExecution, true))))
        {
            if (_verbose && logSuccessExecution)
            {
                trace("Executing: '" + Type.getClassName(commandClass) + "'");
            }
            
            var command : ICommand = getCommandSingleton(commandClass, lastCommandData);
            command.execute();
            command.clear();

            lastCommandData = null;
            
            return true;
        }
        
        return false;
    }
    /**
		 * @inheritDoc
		 */
    public function unmapAll(messageType : Enum) : ICommandMapper
    {
        if (commandMap[messageType] != null)
        {
            commandMap.remove(messageType);
        }
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function hasMapping(messageType : Enum) : Bool
    {
        return commandMap[messageType] != null;
    }

    private var context:IContext;

    public function new(context:IContext)
    {
        super();

        this.context = context;

        init();
    }
}