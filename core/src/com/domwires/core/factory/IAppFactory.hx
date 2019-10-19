/**
 * Created by Anton Nefjodov on 13.06.2016.
 */
package com.domwires.core.factory;

import hex.di.provider.IDependencyProvider;
import hex.di.IInjectorAcceptor;
import hex.di.ClassName;
import com.domwires.core.common.IDisposable;
import hex.di.ClassRef;
import hex.di.MappingName;

interface IAppFactory extends IAppFactoryImmutable extends IDisposable
{
	function getProvider<T>( className : ClassName, ?name : MappingName ) : IDependencyProvider<T>;

	function injectInto( target : IInjectorAcceptor ) : Void;

	function destroyInstance<T>( instance : T ) : Void;

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
	 * @return
	 */
	function registerPool<T>(type:ClassRef<T>, capacity:Int = 5, instantiateNow:Bool = false, constructorArgs:Dynamic = null,
						  isBusyFlagGetterName:String = null):IAppFactory;

	/**
	 * Unregisters and disposes pool for provided type.
	 * @param type Type of object to register pool for
	 * @return
	 */
	function unregisterPool<T>(type:ClassRef<T>):IAppFactory;

	/**
	 * Clears all pools of current <code>IAppFactory</code>.
	 * @return
	 */
	function clearPools():IAppFactory;

	/**
	 * Clears of mappings of current <code>IAppFactory</code>.
	 * @return
	 */
	function clearMappings():IAppFactory;

	/**
	 * Clears of pools and mappings of current <code>IAppFactory</code>.
	 * @return
	 */
	function clear():IAppFactory;

	/**
	 * Increases pool capacity/
	 * @param type Type of pool
	 * @param additionalCapacity
	 * @return
	 */
	function increasePoolCapacity(type:Class<Dynamic>, additionalCapacity:Int):IAppFactory;

	/**
	 * Avoid stack overflow and increase pool capacity up to 1, if all pool items are busy. Default is true.
	 * @param value
	 * @return
	 */
	function setSafePool(value:Bool):IAppFactory;
}

