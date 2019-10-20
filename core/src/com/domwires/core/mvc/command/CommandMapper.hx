package com.domwires.core.mvc.command;

import com.domwires.core.common.AbstractDisposable;
import com.domwires.core.factory.IAppFactory;
import com.domwires.core.mvc.message.IMessage;
import haxe.ds.EnumValueMap;

class CommandMapper extends AbstractDisposable implements ICommandMapper
{
	@Inject
	private var factory:IAppFactory;

	private var commandMap:EnumValueMap<EnumValue, Array<MappingConfig>> = new EnumValueMap<EnumValue, Array<MappingConfig>>();

	private var _mergeMessageDataAndMappingData:Bool;

	@PostConstruct
	private function init():Void
	{
		factory.mapToValue(ICommandMapper, this);
	}

	public function map(messageType:EnumValue, commandClass:Class<Dynamic>, data:Dynamic, once:Bool, stopOnExecute:Bool):MappingConfig
	{
		var mappingConfig:MappingConfig = new MappingConfig(commandClass, data, once, stopOnExecute);

		var list:Array<MappingConfig> = commandMap.get(messageType);
		if (list == null)
		{
			list = [];
			commandMap.set(messageType, list);
		} else
		if (!mappingListContains(list, commandClass))
		{
			list.push(mappingConfig);
		}

		return mappingConfig;
	}

	public function map1(messageType:EnumValue, commandClassList:Array<Class<Dynamic>>, data:Dynamic, once:Bool,
						 stopOnExecute:Bool):MappingConfigList
	{
		var commandClass:Class;
		var mappingConfigList:MappingConfigList = new MappingConfigList();

		for (commandClass in commandClassList)
		{
			var soe:Bool = stopOnExecute && commandClassList.indexOf(commandClass) == commandClassList.length - 1;
			mappingConfigList.push(map(messageType, commandClass, data, once, soe));
		}

		return mappingConfigList;
	}

	public function map2(messageTypeList:Array<EnumValue>, commandClass:Class<Dynamic>, data:Dynamic, once:Bool,
						 stopOnExecute:Bool):MappingConfigList
	{
		var messageType:Enum;
		var mappingConfigList:MappingConfigList = new MappingConfigList();

		for (messageType in messageTypeList)
		{
			var soe:Bool = stopOnExecute && messageTypeList.indexOf(messageType) == messageTypeList.length - 1;
			mappingConfigList.push(map(messageType, commandClass, data, once, soe));
		}

		return mappingConfigList;
	}

	public function map3(messageTypeList:Array<EnumValue>, commandClassList:Array<Class<Dynamic>>, data:Dynamic, once:Bool,
						 stopOnExecute:Bool):MappingConfigList
	{
		var commandClass:Class;
		var messageType:Enum;
		var mappingConfigList:MappingConfigList = new MappingConfigList();

		for (commandClass in commandClassList)
		{
			for (messageType in messageTypeList)
			{
				var soe:Bool = stopOnExecute
				&& messageTypeList.indexOf(messageType) == messageTypeList.length - 1
				&& commandClassList.indexOf(commandClass) == commandClassList.length - 1;

				mappingConfigList.push(map(messageType, commandClass, data, once, soe));
			}
		}

		return mappingConfigList;
	}

	private function mappingListContains(list:Array<MappingConfig>, commandClass:Class, ignoreGuards:Bool = false):MappingConfig
	{
		var mappingVo:MappingConfig;
		for (mappingVo in list)
		{
			if (mappingVo.commandClass == commandClass)
			{
				var hasGuards:Bool = !ignoreGuards && mappingVo.guardList && mappingVo.guardList.length > 0;
				return hasGuards ? null : mappingVo;
			}
		}

		return null;
	}

	public function unmap(messageType:EnumValue, commandClass:Class<Dynamic>):ICommandMapper
	{
		var list:Array<MappingConfig> = commandMap.get(messageType);
		if (list != null)
		{
			var mappingVo:MappingConfig = mappingListContains(list, commandClass, true);
			if (mappingVo)
			{
				list.remove(mappingVo);

				if (list.length == 0)
				{
					list = null;

					commandMap.remove(messageType);
				}
			}
		}

		return this;
	}

	public function hasMapping(messageType:EnumValue):Bool
	{
		return commandMap.get(messageType) != null;
	}

	public function unmapAll(messageType:EnumValue):ICommandMapper
	{
		var list:Array<MappingConfig> = commandMap.get(messageType);
		if (list != null)
		{
			commandMap.remove(messageType);
		}

		return this;
	}

	public function executeCommand(commandClass:Class<Dynamic>, data:Dynamic, guardList:Array<Class<Dynamic>>,
								   guardNotList:Array<Class<Dynamic>>):Bool
	{
		if (
			(!guardList || (guardList && guardsAllow(guardList, data))) &&
			(!guardNotList || (guardNotList && guardsAllow(guardNotList, data, true)))
		)
		{
			if (data != null)
			{
				mapValues(data, true);
			}

			if (!factory.hasMapping(commandClass))
			{
				factory.mapToSingleton(commandClass);
			}

			var command:ICommand = cast factory.getInstance(commandClass);
			factory.injectInto(command);

			command.execute();

			if (data != null)
			{
				mapValues(data, false);
			}

			return true;
		}

		return false;
	}

	public function tryToExecuteCommand(message:IMessage):Void
	{
		var messageType:EnumValue = message.type;
		var mappedToMessageCommands:Array<MappingConfig> = commandMap.get(messageType);
		if (mappedToMessageCommands != null)
		{
			var mappingVo:MappingConfig;
			var commandClass:Class<Dynamic>;
			var injectionData:Dynamic;
			for (mappingVo in mappedToMessageCommands)
			{
				if (!_mergeMessageDataAndMappingData)
				{
					injectionData = message.data == null ? mappingVo.data : message.data;
				} else
				{
					injectionData = mergeData(message.data, mappingVo.data);
				}

				commandClass = mappingVo.commandClass;

				var success:Bool = executeCommand(commandClass, injectionData, mappingVo.guardList, mappingVo.oppositeGuardList);

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

	private function mergeData(messageData:Dynamic, mappingData:Dynamic):Dynamic
	{
		if (messageData && !mappingData) return messageData;
		if (!messageData && mappingData) return mappingData;

		if (messageData && mappingData)
		{
			for (i in Reflect.fields(mappingData))
			{
				Reflect.field(messageData, i) = Reflect.field(mappingData, i);
			}
		}

		return messageData;
	}

	private function mapValues(data:Dynamic, map:Bool):Void
	{
		for (propertyName in Reflect.fields(data))
		{
			mapProperty(data, propertyName, map);
		}
	}

	private function mapProperty(data:Dynamic, propertyName:String, map:Bool):Void
	{
		var propertyValue:Dynamic = Reflect.field(data, propertyName);
		var typeName:String = Type.getClassName(propertyValue);
		if (map)
		{
			factory.mapClassNameToValue(typeName, propertyValue, propertyName);
		} else
		{
			factory.unmapClassName(typeName, propertyName);
		}
	}

	private function guardsAllow(guardList:Array<Class>, data:Dynamic = null, opposite:Bool = false):Bool
	{
		var guardClass:Class;
		var guards:IGuards;

		var guardsAllow:Bool = true;

		for (guardClass in guardList)
		{
			if (data != null)
			{
				mapValues(data, true);
			}

			if (!factory.hasMapping(guardClass))
			{
				factory.mapToSingleton(guardClass);
			}

			var guards:IGuards = cast factory.getInstance(guardClass);
			factory.injectInto(guards);

			if (data != null)
			{
				mapValues(data, false);
			}

			var allows:Bool = !opposite ? guards.allows : !guards.allows;

			if (!allows)
			{
				return false;
			}
		}

		return guardsAllow;
	}

	public function clear():ICommandMapper
	{
		commandMap = new EnumValueMap<EnumValue, Array<MappingConfig>>();

		return this;
	}

}
