package com.domwires.core.factory;

import hex.di.provider.IDependencyProvider;
import hex.di.IInjectorAcceptor;
import hex.di.ClassName;
import com.domwires.core.common.IDisposable;
import hex.di.ClassRef;
import hex.di.MappingName;

interface IAppFactory extends IAppFactoryImmutable extends IDisposable
{
    function getProvider<T>(className:ClassName, ?name:MappingName):IDependencyProvider<T>;

    function injectInto(target:IInjectorAcceptor):Void;

    function destroyInstance<T>(instance:T):Void;

    function mapToValue<T>(clazz:ClassRef<T>, value:T, ?name:MappingName):Void;

    function mapToType<T>(clazz:ClassRef<T>, type:Class<T>, ?name:MappingName):Void;

    function mapToSingleton<T>(clazz:ClassRef<T>, type:Class<T>, ?name:MappingName):Void;

    function unmap<T>(type:ClassRef<T>, ?name:MappingName):Void;

    function unmapClassName(className:ClassName, ?name:MappingName):Void;

    function mapClassNameToValue<T>(className:ClassName, value:T, ?name:MappingName):Void;

    function mapClassNameToType<T>(className:ClassName, type:Class<T>, ?name:MappingName):Void;

    function mapClassNameToSingleton<T>(className:ClassName, type:Class<T>, ?name:MappingName):Void;

    /**
	 * Registers pool for instances of provided type.
	 * @param type Type of object to register pool for
	 * @param capacity Maximum objects of current type in pool
	 * @param instantiateNow Create instances immediately
	 * @param constructorArgs Constructor arguments, in case <code>instantiateNow</code> is true.
	 * @param isBusyFlagGetterName The name of public getter. If specified, then this method will be called, to check if current
	 * object can be re-used right now. If specified and returns true, then next item of pool will be checked.
	 * Can be any type. Use Array, if need to pass several args.
	 */
    function registerPool<T>(type:ClassRef<T>, capacity:Int = 5, instantiateNow:Bool = false,
                             isBusyFlagGetterName:String = null):IAppFactory;

    function registerPoolByClassName<T>(className:String, capacity:Int = 5, instantiateNow:Bool = false,
                                        isBusyFlagGetterName:String = null):IAppFactory;

    /**
	 * Unregisters and disposes pool for provided type.
	 * @param type Type of object to register pool for
	 */
    function unregisterPool<T>(type:ClassRef<T>):IAppFactory;

    function unregisterPoolByClassName<T>(className:String):IAppFactory;

    /**
	 * Clears all pools of current <code>IAppFactory</code>.
	 */
    function clearPools():IAppFactory;

    /**
	 * Clears of mappings of current <code>IAppFactory</code>.
	 */
    function clearMappings():IAppFactory;

    /**
	 * Clears of pools and mappings of current <code>IAppFactory</code>.
	 */
    function clear():IAppFactory;

    /**
	 * Increases pool capacity/
	 * @param type Type of pool
	 * @param additionalCapacity
	 */
    function increasePoolCapacity<T>(type:ClassRef<T>, additionalCapacity:Int):IAppFactory;

    function increasePoolCapacityByClassName(className:String, additionalCapacity:Int):IAppFactory;

    /**
	 * Avoid stack overflow and increase pool capacity up to 1, if all pool items are busy. Default is true.
	 * @param value
	 */
    function setSafePool(value:Bool):IAppFactory;

    /**
     * Will create type mapping, value mappings and inject dependencies, using config data.
     * @param config map of <code>DependencyVo</code>
     * @return
     */
    function appendMappingConfig(config:Map<String, DependencyVo>):IAppFactory;
}

