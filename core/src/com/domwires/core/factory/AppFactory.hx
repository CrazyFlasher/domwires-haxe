package com.domwires.core.factory;

import hex.di.IInjectorListener;
import hex.di.IInjectorAcceptor;
import hex.di.provider.IDependencyProvider;
import haxe.io.Error;
import hex.di.ClassRef;
import hex.di.MappingName;
import hex.di.ClassName;
import com.domwires.core.common.AbstractDisposable;
import hex.di.IDependencyInjector;
import hex.di.Injector;

class AppFactory extends AbstractDisposable implements IAppFactory
{
	private var injector:IDependencyInjector = new Injector();

	public function new()
	{
		super();
	}

	public function getInstanceWithClassName<T>(className:ClassName, ?name:MappingName, targetType:Class<Dynamic> = null,
											 shouldThrowAnError:Bool = true):T
	{
		return injector.getInstanceWithClassName(className, name, targetType, shouldThrowAnError);
	}

	public function getAllPoolItemsAreBusy(type:ClassRef<T>):Bool
	{
		throw Error.Custom("Not implemented!");
	}

	public function clearMappings():IAppFactory
	{
		injector = new Injector();
	}

	public function increasePoolCapacity(type:Class<Dynamic>, additionalCapacity:Int):IAppFactory
	{
		throw Error.Custom("Not implemented!");
	}

	public function instantiateUnmapped<T>(type:Class<T>):T
	{
		injector.instantiateUnmapped(type);
	}

	public function unmap<T>(type:ClassRef<T>, ?name:MappingName):Void
	{
		injector.unmap(type, name);
	}

	public function getOrCreateNewInstance<T>(type:Class<T>):T
	{
		injector.getOrCreateNewInstance(type);
	}

	public function getInstanceFromPool<T>(type:Class<T>):T
	{
		throw Error.Custom("Not implemented!");
	}

	public function mapClassNameToType<T>(className:ClassName, type:Class<T>, ?name:MappingName):Void
	{
		injector.mapClassNameToValue(className, type, name);
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

	public function registerPool<T>(type:ClassRef<T>, capacity:Int, instantiateNow:Bool, constructorArgs:Dynamic,
								 isBusyFlagGetterName:String):IAppFactory
	{
		throw Error.Custom("Not implemented!");
	}

	public function unregisterPool<T>(type:Class<T>):IAppFactory
	{
		throw Error.Custom("Not implemented!");
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
		throw Error.Custom("Not implemented!");
	}

	public function mapToValue<T>(clazz:ClassRef<T>, value:T, ?name:MappingName):Void
	{
		injector.mapToValue(clazz, value, name);
	}

	public function unmapClassName(className:ClassName, ?name:MappingName):Void
	{
		injector.unmapClassName(className, name);
	}

	public function clearPools():IAppFactory
	{
		throw Error.Custom("Not implemented!");
	}

	public function setSafePool(value:Bool):IAppFactory
	{
		throw Error.Custom("Not implemented!");
	}

	public function getPoolCapacity<T>(type:ClassRef<T>):Int
	{
		throw Error.Custom("Not implemented!");
	}

	public function mapClassNameToSingleton<T>(className:ClassName, type:Class<T>, ?name:MappingName):Void
	{
		injector.mapClassNameToSingleton(className, type, name);
	}

	public function getInstance<T>(type:ClassRef<T>, ?name:MappingName, targetType:Class<Dynamic> = null):T
	{
		return injector.getInstance(type, name, targetType);
	}

	public function hasPoolForType<T>(type:ClassRef<T>):Bool
	{
		throw Error.Custom("Not implemented!");
	}

	public function getPoolBusyInstanceCount<T>(type:ClassRef<T>):Int
	{
		throw Error.Custom("Not implemented!");
	}
}
