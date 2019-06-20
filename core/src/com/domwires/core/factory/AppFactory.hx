/**
 * Created by Anton Nefjodov on 20.05.2016.
 */
package com.domwires.core.factory;

import Std;
import com.domwires.core.common.AbstractDisposable;
import haxe.Constraints.Function;
import haxe.io.Error;
import haxe.rtti.CType.Classdef;
import haxe.rtti.CType.CTypeTools;
import openfl.utils.Dictionary;
import Std;
import Type;


class AppFactory extends AbstractDisposable implements IAppFactory
{
	public var autoInjectDependencies(never, set):Bool;
	public var verbose(never, set):Bool;

	private static var injectionMap:Dictionary<Class<Dynamic>, InjectionDataVo> = new Dictionary<Class<Dynamic>, InjectionDataVo>();

	private var typeMapping:Dictionary<Class<Dynamic>, Class<Dynamic>> = new Dictionary<Class<Dynamic>, Class<Dynamic>>();
	private var instanceMapping:Dictionary<Dynamic, Dictionary<String, Dynamic>> = new Dictionary<Dynamic, Dictionary<String, Dynamic>>();
	private var primitiveInstanceMapping:Dictionary<String, Dictionary<String, Dynamic>> = new Dictionary<String, Dictionary<String, Dynamic>>();
	private var pool:Dictionary<Class<Dynamic>, PoolModel> = new Dictionary<Class<Dynamic>, PoolModel>();

	private var _autoInjectDependencies:Bool = true;

	private var _verbose:Bool = false;

	private var _safePool:Bool = true;

	public function mapToType(type:Class<Dynamic>, to:Class<Dynamic>):IAppFactory
	{
		if (to == null)
		{
			throw Error.Custom("Cannot map type to null type!");
		}

		if (_verbose && typeMapping.get(type) != null)
		{
			trace("Warning: type " + type + " is mapped to type " + typeMapping.get(type) + ". Remapping to " + to);
		}

		typeMapping.set(type, to);

		return this;
	}

	public function mapToValue(type:Dynamic, to:Dynamic, name:String = null):IAppFactory
	{
		trace("mapToValue " + type, to, name);

		if (to == null)
		{
			throw Error.Custom("Cannot map type to null value!");
		}

		if (Std.is(type, String))
		{
			if (primitiveInstanceMapping.get(type) == null)
			{
				primitiveInstanceMapping.set(type, new Dictionary<String, Dynamic>());
			}

			if (_verbose && primitiveInstanceMapping.get(type).exists(name))
			{
				trace("Warning: type " + type  + "$" + name + " is mapped to instance " + primitiveInstanceMapping[type][name] + ". Remapping" + " to " + to);
			}

			primitiveInstanceMapping.get(type).set(name, to);
		} else
		{
			if (instanceMapping.get(type) == null)
			{
				instanceMapping.set(type, new Dictionary<String, Dynamic>());
			}

			if (_verbose && instanceMapping.get(type).exists(name))
			{
				trace("Warning: type " + type  + "$" + name + " is mapped to instance " + instanceMapping[type][name] + ". Remapping" + " to " + to);
			}

			instanceMapping.get(type).set(name, to);
		}

		return this;
	}

	public function hasTypeMappingForType(type:Class<Dynamic>, name:String = null):Bool
	{
		return typeMapping.exists(type);
	}

	public function hasValueMappingForType(type:Class<Dynamic>, name:String = null):Bool
	{
		return instanceMapping.exists(type) && instanceMapping.get(type).exists(name);
	}

	public function unmapType(type:Class<Dynamic>):IAppFactory
	{
		if (typeMapping.exists(type))
		{
			typeMapping.remove(type);
		}

		return this;
	}

	public function unmapValue(type:Class<Dynamic>, name:String = null):IAppFactory
	{
		if (instanceMapping.exists(type) && instanceMapping.get(type).exists(name))
		{
			instanceMapping.get(type).remove(name);
		}

		return this;
	}

	public function getInstanceFromPool(type:Class<Dynamic>):Dynamic
	{
		var obj:Dynamic = getFromPool(type, null, false);

		if (obj == null)
		{
			throw Error.Custom("There are no objects in pool for " + type + "!");
		}

		return obj;
	}

	public function setSafePool(value:Bool):IAppFactory
	{
		_safePool = value;

		return this;
	}

	public function getInstance(type:Dynamic, constructorArgs:Dynamic = null, name:String = null, ignorePool:Bool = false):Dynamic
	{
		var obj:Dynamic = getInstanceFromInstanceMap(type, name);

		if (obj != null)
		{
			return obj;
		}

		if (!ignorePool && hasPoolForType(type))
		{
			obj = getFromPool(type, constructorArgs);
		}
		else
		{
			obj = getNewInstance(type, constructorArgs);

			if (obj != null)
			{
				if (_autoInjectDependencies)
				{
					obj = injectDependencies(obj);
				}

				var injectionData:InjectionDataVo = getInjectionData(Type.getClass(obj));
				if (injectionData.postConstructName != null)
				{
					Reflect.field(obj, Std.string(injectionData.postConstructName))();
				}
			} else
			{
				//in case of getNewInstance returned null, try again using default implementation.
				obj = getInstance(type, constructorArgs, name, ignorePool);
			}
		}

		return obj;
	}

	private function getInstanceFromInstanceMap(type:Dynamic, name:String, require:Bool = false):Dynamic
	{
		if (Std.is(type, String))
		{
			if (primitiveInstanceMapping.exists(type) && primitiveInstanceMapping.get(type).exists(name))
			{
				return primitiveInstanceMapping.get(type).get(name);
			}
		} else
		{
			if (instanceMapping.exists(type) && instanceMapping.get(type).exists(name))
			{
				return instanceMapping.get(type).get(name);
			}
		}

		if (require)
		{
			throw Error.Custom("Instance mapping for " + Type.getClassName(type) + "$" + name + " not found!");
		}

		return null;
	}

	@:allow(com.domwires.core.factory)
	private function getNewInstance(type:Dynamic, constructorArgs:Dynamic = null):Dynamic
	{
		trace("getNewInstance " + type);

		var t:Dynamic;

		if (typeMapping.get(type) == null)
		{
			if (_verbose)
			{
				trace("Warning: type " + type + " is not mapped to any other type. Creating new instance of " + type);
			}

			t = type;
		} else
		{
			t = typeMapping.get(type);
		}

		try
		{
			return returnNewInstance(t, constructorArgs);
		} catch (error:Dynamic)
		{
			var defImplClassName:String = Type.getClassName(type).split(".I").join(".");

			if (_verbose)
			{
				trace("Warning: interface " + type + " is not mapped to any class. Trying to find default implementation " +
					defImplClassName);
			}

			mapToType(type, Type.resolveClass(defImplClassName));

			return null;
		}
	}

	private static function returnNewInstance(type:Dynamic, constructorArgs:Dynamic = null):Dynamic
	{
		if (constructorArgs == null || (Std.is(constructorArgs, Array) && constructorArgs.length == 0))
		{
			trace("1 " + constructorArgs + type);
			return Type.createInstance(type, []);
		}

		if (Std.is(constructorArgs, Array))
		{
			trace("2");
			return Type.createInstance(type, constructorArgs);
		}

		return Type.createInstance(type, [constructorArgs]);
	}

	public function registerPool(type:Class<Dynamic>, capacity:Int = 5, instantiateNow:Bool = false, constructorArgs:Dynamic = null,
								 isBusyFlagGetterName:String = null):IAppFactory
	{
		if (capacity == 0)
		{
			throw Error.Custom("Capacity should be > 0!");
		}

		if (_verbose && pool.get(type) != null)
		{
			trace("Pool " + type + " already registered! Call unregisterPool before.");
		} else
		{
			pool.set(type, new PoolModel(this, capacity, isBusyFlagGetterName));

			if (instantiateNow)
			{
				for (i in 0...capacity)
				{
					getFromPool(type, constructorArgs);
				}
			}
		}

		return this;
	}

	private function getFromPool(type:Class<Dynamic>, constructorArgs:Dynamic = null, createNewIfNeeded:Bool = true):Dynamic
	{
		if (pool.get(type) == null)
		{
			throw Error.Custom("Pool " + type + "is not registered! Call registerPool.");
		}

		var poolModel:PoolModel = pool.get(type);

		if (_safePool && getAllPoolItemsAreBusy(type))
		{
			trace("All pool items are busy for class '" + type + "'. Extending pool...");

			increasePoolCapacity(type, 1);

			trace("Pool capacity for '" + type + "' increased!");
		}

		return poolModel.get(type, constructorArgs, createNewIfNeeded);
	}

	public function unregisterPool(type:Class<Dynamic>):IAppFactory
	{
		if (pool.get(type) != null)
		{
			pool.get(type).dispose();

			pool.remove(type);
		}

		return this;
	}

	public function hasPoolForType(type:Class<Dynamic>):Bool
	{
		return pool.get(type) != null;
	}

	public function increasePoolCapacity(type:Class<Dynamic>, additionalCapacity:Int):IAppFactory
	{
		if (!hasPoolForType(type))
		{
			throw Error.Custom("Pool " + type + "is not registered! Call registerPool.");
		}

		pool.get(type).increaseCapacity(additionalCapacity);

		return this;
	}

	public function getPoolCapacity(type:Class<Dynamic>):Int
	{
		if (!hasPoolForType(type))
		{
			throw Error.Custom("Pool " + type + "is not registered! Call registerPool.");
		}

		return pool.get(type).capacity;
	}

	public function getPoolInstanceCount(type:Class<Dynamic>):Int
	{
		if (!hasPoolForType(type))
		{
			throw Error.Custom("Pool " + type + "is not registered! Call registerPool.");
		}

		return pool.get(type).instanceCount;
	}

	public function getAllPoolItemsAreBusy(type:Class<Dynamic>):Bool
	{
		if (!hasPoolForType(type))
		{
			throw Error.Custom("Pool " + type + "is not registered! Call registerPool.");
		}

		return pool.get(type).allItemsAreBusy;
	}

	public function getPoolBusyInstanceCount(type:Class<Dynamic>):Int
	{
		if (!hasPoolForType(type))
		{
			throw Error.Custom("Pool " + type + "is not registered! Call registerPool.");
		}

		return pool.get(type).busyItemsCount;
	}

	public function getSingleton(type:Class<Dynamic>):Dynamic
	{
		if (!hasPoolForType(type))
		{
			registerPool(type, 1);
		}

		return getInstance(type);
	}

	public function removeSingleton(type:Class<Dynamic>):IAppFactory
	{
		if (hasPoolForType(type))
		{
			unregisterPool(type);
		} else
		if (_verbose)
		{
			trace(type + " is not registered as singleton!");
		}

		return this;
	}

	public function clearPools():IAppFactory
	{
		for (poolModel in pool)
		{
			pool.get(poolModel).dispose();
		}

		pool = new Dictionary<Class<Dynamic>, PoolModel>();

		return this;
	}

	public function clearMappings():IAppFactory
	{
		typeMapping = new Dictionary<Class<Dynamic>, Class<Dynamic>>();
		instanceMapping = new Dictionary<Dynamic, Dictionary<String, Dynamic>>();
		primitiveInstanceMapping = new Dictionary<String, Dictionary<String, Dynamic>>();

		return this;
	}

	public function clear():IAppFactory
	{
		clearPools();
		clearMappings();

		return this;
	}

	public function injectDependencies(instance:Dynamic):Dynamic
	{
		var instanceClass:Dynamic = Type.getClass(instance);
		var injectionData:InjectionDataVo = getInjectionData(instanceClass);

		trace("injectDependencies");

		var isOptional:Bool;
		var type:Dynamic;
		var name:String;
		var variable:InjectionVariableVo;

		for (objVar in injectionData.variables.keys())
		{
			variable = injectionData.variables.get(objVar);

			isOptional = variable.optional;
			type = variable.type;
			name = variable.name;
			try
			{
				trace("isOptional " + isOptional);
				trace("type " + type);
				trace("name " + name);
				var fromInstanceMap:Dynamic = getInstanceFromInstanceMap(type, name, !isOptional);

				if (fromInstanceMap != null)
				{
					trace("setField " + instance);
					Reflect.setField(instance, objVar, fromInstanceMap);
				}
			} catch (e:Dynamic)
			{
				var typeToString:String = Std.is(type, String) ? type : Type.getClassName(type);
				throw Error.Custom("Cannot inject all required dependencies to " + Type.getClassName(instanceClass) + ". Instance mapping for " + typeToString + "$" + name + " not found!");
			}
		}

		if (injectionData.postInjectName != null)
		{
			var method:Function = Reflect.field(instance, injectionData.postInjectName);
			Reflect.callMethod(instance, method, []);
		}

		return instance;
	}

	private function getInjectionData(type:Class<Dynamic>):InjectionDataVo
	{
		var mappedType:Class<Dynamic> = typeMapping.get(type) != null ? typeMapping.get(type) : type;

		var injectionData:InjectionDataVo = injectionMap.get(mappedType);
		var isOptional:Bool;

		if (injectionData == null)
		{
			injectionData = new InjectionDataVo();

			var classDef:Classdef = haxe.rtti.Rtti.getRtti(mappedType);
			for (field in classDef.fields)
			{
				for (metadata in field.meta)
				{
					if (metadata.name == "PostConstruct")
					{
						injectionData.postConstructName = field.name;
					} else
					if (metadata.name == "PostInject")
					{
						injectionData.postInjectName = field.name;
					} else
					if (metadata.name == "Autowired")
					{
						isOptional = metadata.params.length > 1 ? (metadata.params[1] == "true") : false;

						trace("field.type " + field.type + " " + CTypeTools.toString(field.type));

						var type:Dynamic = Type.resolveClass(CTypeTools.toString(field.type));
						if (type == null)
						{
							type = CTypeTools.toString(field.type);
						}
						injectionData.variables.set(field.name, new InjectionVariableVo(
							type,
							metadata.params.length > 0 ? metadata.params[0] : null, isOptional
						));
					}
				}
			}

			injectionMap.set(mappedType, injectionData);
		}

		return injectionData;
	}

	override public function dispose():Void
	{
		typeMapping = null;
		instanceMapping = null;

		for (poolModel in pool)
		{
			pool.get(poolModel).dispose();
		}

		pool = null;

		super.dispose();
	}

	private function set_autoInjectDependencies(value:Bool):Bool
	{
		_autoInjectDependencies = value;

		return value;
	}

	private function set_verbose(value:Bool):Bool
	{
		_verbose = value;

		return value;
	}

	public function appendMappingConfig(config:MappingConfigDictionary):IAppFactory
	{
		var i:Dynamic;
//		var i:Class<Dynamic>;
		var c:Class<Dynamic>;
		var name:String = null;
		var interfaceDefinition:String;
		var d:DependencyVo;
		var splitted:Array<Dynamic>;

		var map:Map<String, DependencyVo> = config.map;

		for (interfaceDefinition in map.keys())
		{
			d = map.get(interfaceDefinition);

			splitted = interfaceDefinition.split("$");
			if (splitted.length > 1)
			{
				name = splitted[1];
				interfaceDefinition = splitted[0];
			}

//			i = Type.resolveClass(interfaceDefinition);
			i = interfaceDefinition;

			if (d.value != null)
			{
				mapToValue(i, d.value, name);
			}
			else
			{
				if (d.implementation != null)
				{
					c = Type.resolveClass(d.implementation);

					if (_verbose)
					{
						trace("Mapping '" + interfaceDefinition + "' to '" + c + "'");
					}

					mapToType(i, c);
				}

				if (d.newInstance)
				{
					mapToValue(i, getNewInstance(i), name);
				}
			}

			name = null;
		}

		return this;
	}

	public function new()
	{
		super();
	}
}


class InjectionDataVo
{
	@:allow(com.domwires.core.factory)
	private var variables:Map<String, InjectionVariableVo> = new Map();

	@:allow(com.domwires.core.factory)
	private var postConstructName:String;

	@:allow(com.domwires.core.factory)
	private var postInjectName:String;

	@:allow(com.domwires.core.factory)
	private function new()
	{
	}

	@:allow(com.domwires.core.factory)
	private function dispose():Void
	{
		variables = null;
	}
}

class InjectionVariableVo
{
	public var optional(get, never):Bool;
	public var type(get, never):Dynamic;
	public var name(get, never):String;

	private var _type:Dynamic;
	private var _name:String;
	private var _optional:Bool;

	@:allow(com.domwires.core.factory)
	private function new(type:Dynamic, name:String, optional:Bool)
	{
		_type = type;

		if (name != null)
		{
			_name = StringTools.replace(name, "\"", "");
		}

		_optional = optional;
	}

	private function get_optional():Bool
	{
		return _optional;
	}

	private function get_type():Dynamic
	{
		return _type;
	}

	private function get_name():String
	{
		return _name;
	}
}