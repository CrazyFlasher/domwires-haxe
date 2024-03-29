package com.domwires.core.factory;

import com.domwires.core.common.IDisposableImmutable;
import hex.di.ClassName;
import hex.di.ClassRef;
import hex.di.IInjectorListener;
import hex.di.MappingName;
import hex.di.provider.IDependencyProvider;

/**
 * Immutable interface.
 * @see com.domwires.core.factory.IAppFactory
 */
interface IAppFactoryImmutable extends IDisposableImmutable
{
    function hasDirectMapping<T>(type:ClassRef<T>, ?name:MappingName):Bool;

    function satisfies<T>(type:ClassRef<T>, ?name:MappingName):Bool;

    function addListener(listener:IInjectorListener):Bool;

    function removeListener(listener:IInjectorListener):Bool;

    function getInstance<T>(type:ClassRef<T>, ?name:MappingName, targetType:Class<Dynamic> = null,
                            ignorePool:Bool = false):T;

    function getInstanceWithClassName<T>(className:ClassName, ?name:MappingName, targetType:Class<Dynamic> = null,
                                         shouldThrowAnError:Bool = true, ignorePool:Bool = false):T;

    function instantiateUnmapped<T>(type:Class<T>):T;

    function getOrCreateNewInstance<T>(type:Class<T>):T;

    function hasMapping<T>(type:ClassRef<T>, ?name:MappingName):Bool;

    function hasMappingForClassName<T>(className:ClassName, ?name:MappingName):Bool;

    /**
	 * @param type
	 * @return true, if <code>IAppFactory</code> has registered pool for provided type.
	 */
    function hasPoolForType<T>(type:ClassRef<T>):Bool;

    function hasPoolForTypeByClassName(className:String):Bool;

    /**
	 * @param type
	 * @return pool capacity.
	 */
    function getPoolCapacity<T>(type:ClassRef<T>):Int;

    function getPoolCapacityByClassName<T>(className:String):Int;

    /**
	 * Returns total count of instances in pool.
	 * @param type
	 * @return
	 */
    function getPoolInstanceCount<T>(type:ClassRef<T>):Int;

    function getPoolInstanceCountByClassName<T>(className:String):Int;

    /**
	 * @param type
	 * @return true, if all pool items are busy.
	 */
    function getAllPoolItemsAreBusy<T>(type:ClassRef<T>):Bool;

    function getAllPoolItemsAreBusyByClassName(className:String):Bool;

    /**
	 * @param type
	 * @return count of busy object in pool
	 */
    function getPoolBusyInstanceCount<T>(type:ClassRef<T>):Int;

    function getPoolBusyInstanceCountByClassName(className:String):Int;
}

