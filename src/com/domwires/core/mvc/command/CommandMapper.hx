package com.domwires.core.mvc.command;

import hex.di.IInjectorAcceptor;
import com.domwires.core.factory.AppFactory;
import com.domwires.core.common.AbstractDisposable;
import com.domwires.core.factory.IAppFactory;
import com.domwires.core.mvc.message.IMessage;
import haxe.ds.EnumValueMap;

class CommandMapper extends AbstractDisposable implements ICommandMapper
{
	@Inject
	private var factory:IAppFactory;

	private var commandMap:CommandMap = new CommandMap();

	private var _mergeMessageDataAndMappingData:Bool;

	@PostConstruct
	private function init():Void
	{
		factory.mapToValue(ICommandMapper, this);
	}

	public function map(messageType:EnumValue, commandClass:Class<Dynamic>, data:Dynamic = null, once:Bool = false,
						stopOnExecute:Bool = false):MappingConfig
	{
		var mappingConfig:MappingConfig = new MappingConfig(commandClass, data, once, stopOnExecute);

		var list:Array<MappingConfig> = commandMap.get(messageType);

		if (list == null)
		{
			list = [mappingConfig];
			commandMap.set(messageType, list);
		} else
		if (mappingListContains(list, commandClass) == null)
		{
			list.push(mappingConfig);
		}

		return mappingConfig;
	}

	public function map1(messageType:EnumValue, commandClassList:Array<Class<Dynamic>>, data:Dynamic = null, once:Bool = false,
						 stopOnExecute:Bool = false):MappingConfigList
	{
		var mappingConfigList:MappingConfigList = new MappingConfigList();

		for (commandClass in commandClassList)
		{
			var soe:Bool = stopOnExecute && commandClassList.indexOf(commandClass) == commandClassList.length - 1;
			mappingConfigList.push(map(messageType, commandClass, data, once, soe));
		}

		return mappingConfigList;
	}

	public function map2(messageTypeList:Array<EnumValue>, commandClass:Class<Dynamic>, data:Dynamic = null, once:Bool = false,
						 stopOnExecute:Bool = false):MappingConfigList
	{
		var mappingConfigList:MappingConfigList = new MappingConfigList();

		for (messageType in messageTypeList)
		{
			var soe:Bool = stopOnExecute && messageTypeList.indexOf(messageType) == messageTypeList.length - 1;
			mappingConfigList.push(map(messageType, commandClass, data, once, soe));
		}

		return mappingConfigList;
	}

	public function map3(messageTypeList:Array<EnumValue>, commandClassList:Array<Class<Dynamic>>, data:Dynamic = null, once:Bool = false,
						 stopOnExecute:Bool = false):MappingConfigList
	{
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

	private function mappingListContains(list:Array<MappingConfig>, commandClass:Class<Dynamic>, ignoreGuards:Bool = false):MappingConfig
	{
		for (mappingVo in list)
		{
			if (mappingVo.commandClass == commandClass)
			{
				var hasGuards:Bool = !ignoreGuards && mappingVo.guardList != null && mappingVo.guardList.length > 0;
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
			if (mappingVo != null)
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

	public function executeCommand(commandClass:Class<Dynamic>, data:Dynamic = null, guardList:Array<Class<Dynamic>> = null,
								   guardNotList:Array<Class<Dynamic>> = null):Bool
	{
		if (
			(guardList == null || (guardList != null && guardsAllow(guardList, data))) &&
			(guardNotList == null || (guardNotList != null && guardsAllow(guardNotList, data, true)))
		)
		{
			if (data != null)
			{
				mapValues(data, true);
			}

			if (!factory.hasMapping(commandClass, AppFactory.RESERVED_CMD))
			{
				factory.mapToValue(commandClass, Type.createInstance(commandClass, []), AppFactory.RESERVED_CMD);
			}

			var command:ICommand = factory.getInstance(commandClass, AppFactory.RESERVED_CMD);
			if (Std.is(command, IInjectorAcceptor))
			{
				factory.injectInto(command);
			} else
			{
				command = factory.getInstance(commandClass);
				factory.injectInto(command);
			}

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
		if (messageData != null && mappingData == null) return messageData;
		if (messageData == null && mappingData != null) return mappingData;

		if (messageData != null && mappingData != null)
		{
			for (i in Reflect.fields(mappingData))
			{
				Reflect.setField(messageData, i, Reflect.field(mappingData, i));
			}
		}

		return messageData;
	}

	private function mapValues(data:Dynamic, map:Bool):Void
	{
		for (propertyName in Reflect.fields(data))
		{
			if (!isType(propertyName))
			{
				mapProperty(data, propertyName, map);
			}
		}
	}

	private function isType(propertyName:String):Bool
	{
		return propertyName.substr(0, 2) == "__";
	}

	private function mapProperty(data:Dynamic, propertyName:String, map:Bool):Void
	{
		var propertyValue:Dynamic = Reflect.field(data, propertyName);
		var propertyType:Dynamic = Reflect.field(data, "__" + propertyName);

		if (propertyType != null)
		{
			if (map)
			{
				factory.mapClassNameToValue(propertyType, propertyValue, propertyName);
			} else
			{
				factory.unmapClassName(propertyType, propertyName);
			}
		} else
		{
			propertyType = TypeUtils.getTypeName(propertyValue);

			if (map)
			{
				if (propertyType != null)
				{
					factory.mapClassNameToValue(propertyType, propertyValue, propertyName);
				} else
				{
					factory.mapToValue(Type.getClass(propertyValue), propertyValue, propertyName);
				}
			} else
			{
				if (propertyType != null)
				{
					factory.unmapClassName(propertyType, propertyName);
				} else
				{
					factory.unmap(Type.getClass(propertyValue), propertyName);
				}
			}
		}
	}

	/*private function getTypeName<T>(value:T):String
	{
		if (value == null) return "null";
		return switch Type.typeof(value)
		{
			case Type.ValueType.TInt: "Int";
			case Type.ValueType.TFloat: "Float";
			case Type.ValueType.TBool: "Bool";
			case Type.ValueType.TFunction: "Function";
			case _:
				if ((value is Array))
				{
					var a:Array<Dynamic> = cast value;
					switch a.length
					{
						case 0:
						case 1: return 'Array<${getTypeName(a[0])}>';
						case _:
							var t1 = getTypeName(a[0]);
							for (i in 1...a.length)
							{
								var t2 = getTypeName(a[i]);
								if (t2 != t1) return 'Array<Dynamic>';
							}
							return 'Array<${t1}>';
					}
				}
				Type.getClassName(Type.getClass(value));
		}
	}*/

	private function guardsAllow(guardList:Array<Class<Dynamic>>, data:Dynamic = null, opposite:Bool = false):Bool
	{
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
				factory.mapToValue(guardClass, Type.createInstance(guardClass, []));
			}

			var guards:IGuards = factory.getInstance(guardClass);
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
		commandMap = new CommandMap();

		return this;
	}

	public function setMergeMessageDataAndMappingData(value:Bool):ICommandMapper
	{
		_mergeMessageDataAndMappingData = value;

		return this;
	}
}

private class CommandMap extends EnumValueMap<EnumValue, Array<MappingConfig>>
{
	override function compare(k1:EnumValue, k2:EnumValue):Int
	{
		var t1 = Type.getEnumName(Type.getEnum(k1));
		var t2 = Type.getEnumName(Type.getEnum(k2));
		if (t1 != t2)
		{
			return t1 < t2 ? -1 : 1;
		}
		return super.compare(k1, k2);
	}
}

private class TypeUtils
{
	public static function getTypeName<T>(value:T):String
	{
		if (value == null) return null;
		if (Reflect.isEnumValue(value)) return "EnumValue";
		return switch Type.typeof(value)
		{
			case Type.ValueType.TInt: "Int";
			case Type.ValueType.TFloat: "Float";
			case Type.ValueType.TBool: "Bool";
			case Type.ValueType.TFunction: "Function";
			default: null;
		}
	}
}