/**
 * Created by Anton Nefjodov on 26.05.2016.
 */
package com.domwires.core.mvc.command;

import com.domwires.core.common.AbstractDisposable;
import com.domwires.core.common.Enum;
import com.domwires.core.factory.IAppFactory;
import com.domwires.core.mvc.message.IMessage;

/**
	 * @see com.domwires.core.mvc.command.ICommandMapper
	 */
class CommandMapper extends AbstractDisposable implements ICommandMapper
{
    /**
		 * <b>[Autowired]</b>
		 */
    @:meta(Autowired())

    public var factory : IAppFactory;
    
    private var commandMap : haxe.ds.ObjectMap<Dynamic, Dynamic> = new haxe.ds.ObjectMap<Dynamic, Dynamic>();
    
    /**
		 * @inheritDoc
		 */
    override public function dispose() : Void
    {
        clear();
        
        commandMap = null;
        factory = null;
        
        super.dispose();
    }
    
    /**
		 * @private
		 */
    @:meta(PostConstruct())

    public function init() : Void
    {
        factory.mapToValue(ICommandMapper, this);
    }
    
    /**
		 * @inheritDoc
		 */
    public function map(messageType : Enum, commandClass : Class<Dynamic>, data : Dynamic = null, once : Bool = false) : MappingConfig
    {
        var mappingConfig : MappingConfig = new MappingConfig(commandClass, data, once);
        if (commandMap.get(messageType) == null)
        {
            commandMap.set(messageType, [mappingConfig]);
        }
        else if (!mappingListContains(commandMap.get(messageType), commandClass))
        {
            commandMap.get(messageType).push(mappingConfig);
        }
        
        return mappingConfig;
    }
    
    /**
		 * @inheritDoc
		 */
    public function map1(messageType : Enum, commandClassList : Array<Class<Dynamic>>, data : Dynamic = null,
            once : Bool = false) : MappingConfigList
    {
        var commandClass : Class<Dynamic>;
        var mappingConfigList : MappingConfigList = new MappingConfigList();
        
        for (commandClass in commandClassList)
        {
            mappingConfigList.push(map(messageType, commandClass, data, once));
        }
        
        return mappingConfigList;
    }
    
    /**
		 * @inheritDoc
		 */
    public function map2(messageTypeList : Array<Enum>, commandClass : Class<Dynamic>,
            data : Dynamic = null, once : Bool = false) : MappingConfigList
    {
        var messageType : Enum;
        var mappingConfigList : MappingConfigList = new MappingConfigList();
        
        for (messageType in messageTypeList)
        {
            mappingConfigList.push(map(messageType, commandClass, data, once));
        }
        
        return mappingConfigList;
    }
    
    /**
		 * @inheritDoc
		 */
    public function map3(messageTypeList : Array<Enum>, commandClassList : Array<Class<Dynamic>>,
            data : Dynamic = null, once : Bool = false) : MappingConfigList
    {
        var commandClass : Class<Dynamic>;
        var messageType : Enum;
        var mappingConfigList : MappingConfigList = new MappingConfigList();
        
        for (commandClass in commandClassList)
        {
            for (messageType in messageTypeList)
            {
                mappingConfigList.push(map(messageType, commandClass, data, once));
            }
        }
        
        return mappingConfigList;
    }
    
    private static function mappingListContains(list : Array<MappingConfig>, commandClass : Class<Dynamic>) : MappingConfig
    {
        var mappingVo : MappingConfig;
        for (mappingVo in list)
        {
            if (mappingVo.commandClass == commandClass)
            {
                return mappingVo;
            }
        }
        
        return null;
    }
    
    /**
		 * @inheritDoc
		 */
    public function unmap(messageType : Enum, commandClass : Class<Dynamic>) : ICommandMapper
    {
        if (commandMap.get(messageType) != null)
        {
            var mappingVo : MappingConfig = mappingListContains(commandMap.get(messageType), commandClass);
            if (mappingVo != null)
            {
                commandMap.get(messageType).removeAt(Lambda.indexOf(commandMap.get(messageType), mappingVo));
                
                if (commandMap.get(messageType).length == 0)
                {
                    commandMap.set(messageType, null);
                    
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
        commandMap = new haxe.ds.ObjectMap<Dynamic, Dynamic>();
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function tryToExecuteCommand(message : IMessage) : Void
    {
        var messageType : Enum = message.type;
        var mappedToMessageCommands : Array<MappingConfig> = commandMap.get(messageType);
        if (mappedToMessageCommands != null)
        {
            var mappingVo : MappingConfig;
            var commandClass : Class<Dynamic>;
            var injectionData : Dynamic;
            for (mappingVo in mappedToMessageCommands)
            {
                injectionData = (message.data == null) ? mappingVo.data : message.data;
                if (!mappingVo.guardList || (mappingVo.guardList && guardsAllow(mappingVo.guardList, injectionData)))
                {
                    commandClass = mappingVo.commandClass;
                    executeCommand(commandClass, injectionData);
                    
                    if (mappingVo.once)
                    {
                        unmap(messageType, commandClass);
                    }
                }
            }
        }
    }
    
    private function guardsAllow(guardList : Array<Class<Dynamic>>, data : Dynamic = null) : Bool
    {
        var guardClass : Class<Dynamic>;
        var guards : IGuards;
        
        for (guardClass in guardList)
        {
            guards = try cast(factory.getSingleton(guardClass), IGuards) catch(e:Dynamic) null;
            
            if (data != null)
            {
                mapValues(data, true);
            }
            
            factory.injectDependencies(guards);
            
            if (data != null)
            {
                mapValues(data, false);
            }
            
            if (!guards.allows)
            {
                return false;
            }
        }
        
        return true;
    }
    
    /**
		 * @inheritDoc
		 */
    public function executeCommand(commandClass : Class<Dynamic>, data : Dynamic = null) : Void
    {
        var command : ICommand = try cast(factory.getSingleton(commandClass), ICommand) catch(e:Dynamic) null;
        
        if (data != null)
        {
            mapValues(data, true);
        }
        
        factory.injectDependencies(command);
        
        command.execute();
        
        if (data != null)
        {
            mapValues(data, false);
        }
    }
    
    private function mapValues(data : Dynamic, map : Bool) : Void
    {
        var propertyName : Dynamic;
        var propertyValue : Dynamic;
        
        for (propertyName in Reflect.fields(data))
        {
            propertyValue = Reflect.field(data, Std.string(propertyName));
            if (map)
            {
                factory.mapToValue(getPropertyType(propertyValue), propertyValue, propertyName);
            }
            else
            {
                factory.unmapValue(getPropertyType(propertyValue), propertyName);
            }
        }
    }
    
    private static function getPropertyType(propertyValue : Dynamic) : Dynamic
    {
        if (Std.is(propertyValue, Int))
        {
            return Int;
        }
        if (Std.is(propertyValue, Int))
        {
            return Int;
        }
        if (Std.is(propertyValue, Float))
        {
            return Float;
        }
        if (Std.is(propertyValue, String))
        {
            return String;
        }
        if (Std.is(propertyValue, Bool))
        {
            return Bool;
        }
        
        return propertyValue;
    }
    
    /**
		 * @inheritDoc
		 */
    public function unmapAll(messageType : Enum) : ICommandMapper
    {
        if (commandMap.get(messageType) != null)
        {
            commandMap.set(messageType, null);
            
            commandMap.remove(messageType);
        }
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function hasMapping(messageType : Enum) : Bool
    {
        return commandMap.get(messageType) != null;
    }

    public function new()
    {
        super();
    }
}
