package com.domwires.core.factory;

import Type;
import com.domwires.core.common.AbstractDisposable;
import haxe.io.Error;
import hex.di.ClassName;
import hex.di.ClassRef;
import hex.di.IDependencyInjector;
import hex.di.IInjectorAcceptor;
import hex.di.IInjectorListener;
import hex.di.Injector;
import hex.di.MappingName;
import hex.di.provider.IDependencyProvider;

class AppFactory extends AbstractDisposable implements IAppFactory
{
	private var injector:Injector = new Injector();

	private var pool:Map<String, PoolModel> = new Map<String, PoolModel>();

	private var _safePool:Bool = true;

	public function new()
	{
		super();
	}

	public function getAllPoolItemsAreBusy<T>(type:ClassRef<T>):Bool
	{
		return getAllPoolItemsAreBusyByClassName(Type.getClassName(type));
	}

	public function getAllPoolItemsAreBusyByClassName(className:String):Bool
	{
		if (!hasPoolForTypeByClassName(className)) throw Error.Custom("Pool " + className + "is not registered! Call registerPool.");

		return pool.get(className).allItemsAreBusy;
	}

	public function clearMappings():IAppFactory
	{
		injector = new Injector();

		return this;
	}

	public function increasePoolCapacity<T>(type:ClassRef<T>, additionalCapacity:Int):IAppFactory
	{
		return increasePoolCapacityByClassName(Type.getClassName(type), additionalCapacity);
	}

	public function increasePoolCapacityByClassName(className:String, additionalCapacity:Int):IAppFactory
	{
		if (!hasPoolForTypeByClassName(className)) throw Error.Custom("Pool '" + className + "' is not registered! Call registerPool.");

		pool.get(className).increaseCapacity(additionalCapacity);

		return this;
	}

	public function instantiateUnmapped<T>(type:Class<T>):T
	{
		return injector.instantiateUnmapped(type);
	}

	public function unmap<T>(type:ClassRef<T>, ?name:MappingName):Void
	{
//		injector.unmap(type, name);
		unmapClassName(Type.getClassName(type), name);
	}

	public function getOrCreateNewInstance<T>(type:Class<T>):T
	{
		return injector.getOrCreateNewInstance(type);
	}

	public function mapClassNameToType<T>(className:ClassName, type:Class<T>, ?name:MappingName):Void
	{
		injector.mapClassNameToType(className, type, name);
	}

	public function hasDirectMapping<T>(type:ClassRef<T>, ?name:MappingName):Bool
	{
		return injector.hasDirectMapping(type, name);
	}

	public function satisfies<T>(type:ClassRef<T>, ?name:MappingName):Bool
	{
		return injector.satisfies(type, name);
	}

	public function mapToSingleton<T>(clazz:ClassRef<T>, type:Class<T>, ?name:MappingName):Void
	{
		injector.mapToSingleton(clazz, type, name);
	}

	public function getProvider<T>(className:ClassName, ?name:MappingName):IDependencyProvider<T>
	{
		return injector.getProvider(className, name);
	}

	public function mapToType<T>(clazz:ClassRef<T>, type:Class<T>, ?name:MappingName):Void
	{
		injector.mapToType(clazz, type, name);
	}

	public function hasMapping<T>(type:ClassRef<T>, ?name:MappingName):Bool
	{
		return injector.hasMapping(type, name);
	}

    public function hasMappingForClassName<T>(className:ClassName, ?name:MappingName):Bool
    {
        return injector.hasMappingForClassName(className, name);
    }

	public function injectInto(target:IInjectorAcceptor):Void
	{
		injector.injectInto(target);
	}

	public function addListener(listener:IInjectorListener):Bool
	{
		return injector.addListener(listener);
	}

	public function destroyInstance<T>(instance:T):Void
	{
		injector.destroyInstance(instance);
	}

	public function mapClassNameToValue<T>(className:ClassName, value:T, ?name:MappingName):Void
	{
		injector.mapClassNameToValue(className, value, name);
	}

	public function registerPoolByClassName<T>(className:String, capacity:Int = 5, instantiateNow:Bool = false,
											   isBusyFlagGetterName:String = null):IAppFactory
	{
		if (capacity == 0)
		{
			throw Error.Custom("Capacity should be > 0!");
		}

		if (pool.exists(className))
		{
			trace("Pool '" + className + "' already registered! Call unregisterPool before.");
		} else
		{
			pool.set(className, new PoolModel(this, capacity, isBusyFlagGetterName));

			if (instantiateNow)
			{
				for (i in 0...capacity)
				{
					getFromPoolByClassName(className);
				}
			}
		}

		return this;
	}

	private function getFromPoolByClassName<T>(className:String, createNewIfNeeded:Bool = true):T
	{
		if (!pool.exists(className))
		{
			throw Error.Custom("Pool '" + className + "' is not registered! Call registerPool.");
		}

		var poolModel:PoolModel = cast pool.get(className);

		if (_safePool && getAllPoolItemsAreBusyByClassName(className))
		{
			trace("All pool items are busy for class '" + className + "'. Extending pool...");

			increasePoolCapacityByClassName(className, 1);

			trace("Pool capacity for '" + className + "' increased!");
		}

		return poolModel.get(className, createNewIfNeeded);
	}

	public function registerPool<T>(type:ClassRef<T>, capacity:Int = 5, instantiateNow:Bool = false,
									isBusyFlagGetterName:String = null):IAppFactory
	{
		return registerPoolByClassName(Type.getClassName(type), capacity, instantiateNow, isBusyFlagGetterName);
	}

	public function unregisterPool<T>(type:Class<T>):IAppFactory
	{
		return unregisterPoolByClassName(Type.getClassName(type));
	}

	public function unregisterPoolByClassName<T>(className:String):IAppFactory
	{
		if (pool.exists(className))
		{
			pool.get(className).dispose();

			pool.remove(className);
		}

		return this;
	}

	public function clear():IAppFactory
	{
		clearPools();
		clearMappings();

		return this;
	}

	public function removeListener(listener:IInjectorListener):Bool
	{
		return injector.removeListener(listener);
	}

	public function getPoolInstanceCount<T>(type:ClassRef<T>):Int
	{
		return getPoolInstanceCountByClassName(Type.getClassName(type));
	}

	public function getPoolInstanceCountByClassName<T>(className:String):Int
	{
		if (!hasPoolForTypeByClassName(className)) throw Error.Custom("Pool '" + className + "' is not registered! Call registerPool.");

		return pool.get(className).instanceCount;
	}

	public function mapToValue<T>(clazz:ClassRef<T>, value:T, ?name:MappingName):Void
	{
//		injector.mapToValue(clazz, value, name);
		mapClassNameToValue(Type.getClassName(clazz), value, name);
	}

	public function unmapClassName(className:ClassName, ?name:MappingName):Void
	{
		injector.unmapClassName(className, name);
	}

	public function clearPools():IAppFactory
	{
		for (poolModel in pool.iterator())
		{
			poolModel.dispose();
		}

		pool = new Map<String, PoolModel>();

		return this;
	}

	public function setSafePool(value:Bool):IAppFactory
	{
		_safePool = value;

		return this;
	}

	public function getPoolCapacity<T>(type:ClassRef<T>):Int
	{
		return getPoolCapacityByClassName(Type.getClassName(type));
	}

	public function getPoolCapacityByClassName<T>(className:String):Int
	{
		if (!hasPoolForTypeByClassName(className)) throw Error.Custom("Pool '" + className + "' is not registered! Call registerPool.");

		return pool.get(className).capacity;
	}

	public function mapClassNameToSingleton<T>(className:ClassName, type:Class<T>, ?name:MappingName):Void
	{
		injector.mapClassNameToSingleton(className, type, name);
	}

	public function getInstance<T>(type:ClassRef<T>, ?name:MappingName, targetType:Class<Dynamic> = null,
								   ignorePool:Bool = false):T
	{
		var obj:T;

		if (!ignorePool)
		{
			if (hasPoolForType(type))
			{
				obj = getFromPoolByClassName(Type.getClassName(type));
				if (Std.isOfType(obj, IInjectorAcceptor))
				{
					injector.injectInto(cast obj);
				}

				return obj;
			}
		}

		if (name == null && !hasMapping(type))
		{
			tryToMapToDefault(type);
		}

		obj = injector.getInstance(type, name, targetType);
		//TODO: it new instance, no need to double inject
//		if (Std.isOfType(obj, IInjectorAcceptor))
//		{
//			injector.injectInto(cast obj);
//		}

		return obj;
	}

	private function tryToMapToDefault<T>(?type:ClassRef<T>, ?className:String):Void
	{
		if (className == null)
		{
			className = Type.getClassName(type);
		}
		if (type == null)
		{
			type = cast Type.resolveClass(className);
		}

		trace("'" + className + "' is not mapped to any type...");

		var isClass:Bool = !isInterface(className);

		if (isClass)
		{
			trace("Mapping '" + className + "' to itself.");
			mapToType(type, type);
		} else
		{
			var index:Int = className.lastIndexOf(".I");
			var firstPart:String = className.substr(0, index);
			var lastPart:String = className.substr(index + 2, className.length);

			var defaultImplClassName:String = firstPart + "." + lastPart;
			var clazz = Type.resolveClass(defaultImplClassName);
			if (clazz == null)
			{
				var err:String = "'" + className + "' is not mapped to any value and default implementation '" +
				defaultImplClassName + "' not found!";
				trace(err);
				throw Error.Custom(err);
			}

			trace("Mapping to default implementation '" + defaultImplClassName + "'.");
			mapToType(type, cast clazz);
		}
	}

	private function isInterface(className:String):Bool
	{
		var index:Int = className.lastIndexOf(".I");
		if (index == -1) return false;

		var nextChar:String = className.charAt(index + 2);
		return nextChar.toUpperCase() == nextChar;
	}

	public function getInstanceWithClassName<T>(className:ClassName, ?name:MappingName, targetType:Class<Dynamic> = null,
												shouldThrowAnError:Bool = true, ignorePool:Bool = false):T
	{
		if (!ignorePool)
		{
			if (hasPoolForTypeByClassName(className))
			{
				return getFromPoolByClassName(className);
			}
		}

		if (name == null && !hasMapping(Type.resolveClass(className)))
		{
			tryToMapToDefault(null, className);
		}

		var obj:T = injector.getInstanceWithClassName(className, name, targetType, shouldThrowAnError);
		//TODO: it new instance, no need to double inject
//		if (Std.isOfType(obj, IInjectorAcceptor))
//		{
//			injector.injectInto(cast obj);
//		}

		return obj;
	}

	public function hasPoolForTypeByClassName(className:String):Bool
	{
		return pool.exists(className);
	}

	public function hasPoolForType<T>(type:ClassRef<T>):Bool
	{
		return hasPoolForTypeByClassName(Type.getClassName(type));
	}

	public function getPoolBusyInstanceCount<T>(type:ClassRef<T>):Int
	{
		return getPoolBusyInstanceCountByClassName(Type.getClassName(type));
	}

	public function getPoolBusyInstanceCountByClassName(className:String):Int
	{
		if (!hasPoolForTypeByClassName(className)) throw Error.Custom("Pool '" + className + "' is not registered! Call registerPool.");

		return pool.get(className).busyItemsCount;
	}

	public function appendMappingConfig(config:Map<String, DependencyVo>):IAppFactory
	{
		var c:Class<Dynamic>;
		var name:String;
		var interfaceDefinition:String;
		var d:DependencyVo;
		var splitted:Array<String>;

		for (interfaceDefinition in config.keys())
		{
			name = null;
			d = config.get(interfaceDefinition);

			splitted = interfaceDefinition.split("$");
			if (splitted.length > 1)
			{
				name = splitted[1];
				interfaceDefinition = splitted[0];
			}

			if (d.value != null)
			{
				mapClassNameToValue(interfaceDefinition, d.value, name);
			} else
			{
				if (d.implementation != null)
				{
					c = Type.resolveClass(d.implementation);

					trace("Mapping '" + interfaceDefinition + "' to '" + c + "'");

					mapClassNameToType(interfaceDefinition, c, name);
				}

				if (d.newInstance)
				{
					mapClassNameToValue(interfaceDefinition, getInstanceWithClassName(interfaceDefinition), name);
				}
			}
		}

		return this;
	}
}
