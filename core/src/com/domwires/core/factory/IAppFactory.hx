/**
 * Created by Anton Nefjodov on 13.06.2016.
 */
package com.domwires.core.factory;

import com.domwires.core.common.IDisposable;

/**
	 * <p>Universal instance factory.</p>
	 * <p>Features:</p>
	 * <ul>
	 * <li>New instances creation</li>
	 * <li>Pools creation</li>
	 * <li>Map interface (or any other class) to class</li>
	 * <li>Map interface (or any other class) to instance</li>
	 * <li>Automatically create default interface implementation (without manual mapping)</li>
	 * <li>Possibility to pass constructor arguments in ordinary way</li>
	 * <li>Inject dependencies to objects</li>
	 * <li>Manage singletons</li>
	 * </ul>
	 * @example
	 * <listing version="3.0">
	 *     var factory:IAppFactory = new AppFactory();
	 *
	 *     //maps IMyObject interface to MyObject class
	 *     factory.mapToType(IMyObject, MyObject);
	 *
	 *     //returns new instance of MyObject
	 *     var obj:IMyObject = factory.getInstance(IMyObject);
	 * </listing>
	 * @example
	 * <listing version="3.0">
	 *     //Factory will search for default implementation of IMyObject (because mapToType is missing)
	 *	   //and if found, will return new instance.
	 *	   //Rules to use default implementation:
	 *	   //1. Interface should start from "I" character;
	 *	   //2. Default implementation should be in the same package as interface;
	 *	   //3. Default implementation class should have the same name as it's interface,
	 *	   //but without the first "I" character (in this case IMyObject and MyObject);
	 *
	 *     var factory:IAppFactory = new AppFactory();
	 *
	 *     var obj:IMyObject = factory.getInstance(IMyObject);
	 *     ...
	 *     MyObject; //we define default implementation here, so compiler will fetch this class in any case.
	 *     public interface IMyObject
	 *     {
	 *     }
	 *     ...
	 *     public class MyObject implements IMyObject
	 *     {
	 *     }
	 * </listing>
	 * @example
	 * <listing version="3.0">
	 *     var factory:IAppFactory = new AppFactory();
	 *
	 *     //maps IMyObject interface to MyObject class
	 *     factory.mapToType(IMyObject, MyObject);
	 *
	 *     //returns new instance of MyObject and passes new Camera() as constructor argument
	 *     var obj:IMyObject = factory.getInstance(IMyObject, new Camera());
	 *     ...
	 *     public class MyObject implements IMyObject
	 *     {
	 *     		public function MyObject(camera:Camera)
	 *     		{
	 *   		}
	 *     }
	 * </listing>
	 * @example
	 * <listing version="3.0">
	 *     var factory:IAppFactory = new AppFactory();
	 *
	 *     //maps IMyObject interface to MyObject class
	 *     factory.mapToType(IMyObject, MyObject);
	 *
	 *     //returns new instance of MyObject and passes arguments to constructor
	 *     var obj:IMyObject = factory.getInstance(IMyObject, [new Camera(), [], true]);
	 *     ...
	 *     public class MyObject implements IMyObject
	 *     {
	 *     		public function MyObject(camera:Camera, array:Array, flag:Boolean)
	 *     		{
	 *   		}
	 *     }
	 * </listing>
	 * @example
	 * <listing version="3.0">
	 *     var factory:IAppFactory = new AppFactory();
	 *
	 * 	   //registers pool with maximum 2 elements
	 *     factory.registerPool(IMyObject, 2);
	 *
	 *     //maps IMyObject interface to MyObject class
	 *     factory.mapToType(IMyObject, MyObject);
	 *
	 *     //Creates (if still not created) and returns instance of MyObject from pool.
	 *     //If any constructor arguments will be passed, they will be ignored.
	 *     var obj:IMyObject = factory.getInstance(IMyObject);
	 * </listing>
	 * @example
	 * <listing version="3.0">
	 *     var factory:IAppFactory = new AppFactory();
	 *
	 *     //maps IMyObject interface to MyObject class
	 *     factory.mapToType(IMyObject, MyObject);
	 *
	 *     //maps ICamera interface to Camera instance
	 *     factory.mapToValue(ICamera, new Camera());
	 *
	 *     //returns new instance of MyObject
	 *     var obj:IMyObject = factory.getInstance(IMyObject);
	 *     ...
	 *     public class MyObject implements IMyObject
	 *     {
	 *     		[Autowired]
	 *     		public var camera:ICamera; //object will be automatically injected
	 *
	 *     		public function MyObject()
	 *     		{
	 *   		}
	 *
	 *			[PostConstruct]
	 *			public function init():void
	 *			{
	 *				//will be called automatically after instance is created and dependencies are injected
	 *			}
	 *
	 *			[PostInject]
	 *			public function init():void
	 *			{
	 *				//will be called automatically each time after dependencies are injected (e.q. camera in this case)
	 *				//For ex. you can manually inject dependencies by calling <code>factory.injectDependencies</code>
	 *			}
	 *     }
	 * </listing>
	 * @example
	 * <listing version="3.0">
	 *     var factory:IAppFactory = new AppFactory();
	 *
	 * 	   //registers pool with maximum 2 elements
	 *     factory.registerPool(IMyObject, 2);
	 *
	 *     //maps IMyObject interface to MyObject class
	 *     factory.mapToType(IMyObject, MyObject);
	 *
	 *     //Creates (if still not created) and returns instance of MyObject from pool
	 *     var obj:IMyObject = factory.getInstance(IMyObject);
	 *     //Injects dependencies to object and calls method (if any), that is marked with [PostInject] metatag
	 *     factory.injectDependencies(obj);
	 * </listing>
	 * @example
	 * <listing version="3.0">
	 *      public class Default implements IDefault
	 *		{
	 *			 public function get result():int
	 *			 {
	 *				 return 123;
	 *			 }
	 *		}
	 *     ...
	 *      public interface IDefault
	 *		{
	 *			function get result():int;
	 *		}
	 *		...
	 *    	public interface ISuperCoolModel extends IModel
	 *		{
	 *			function getCoolValue():int;
	 *			function get value():int;
	 *			function get def():IDefault;
	 *			function get object():Object;
	 *			function get array():Array;
	 *		}
	 *     ...
	 *     	public class SuperCoolModel extends AbstractModel implements ISuperCoolModel
	 *		{
	 *		 [Autowired(name="coolValue")]
	 *		 public var _coolValue:int;
	 *
	 *		 [Autowired]
	 *		 public var _value:int;
	 *
	 *		 [Autowired(name="def")]
	 *		 public var _def:IDefault;
	 *
	 *		 [Autowired(name="obj")]
	 *		 public var _object:Object;
	 *
	 *		 [Autowired]
	 *		 public var _array:Array;
	 *
	 *		 public function getCoolValue():int
	 *		 {
	 *			 return _coolValue;
	 *		 }
	 *
	 *		 public function get value():int
	 *		 {
	 *			 return _value;
	 *		 }
	 *
	 *		 public function get def():IDefault
	 *		 {
	 *			 return _def;
	 *		 }
	 *
	 *		 public function get object():Object
	 *		 {
	 *			 return _object;
	 *		 }
	 *
	 *		 public function get array():Array
	 *		 {
	 *			 return _array;
	 *		 }
	 *		}
	 *     ...
	 *     var configJson:Object =
	 * 		{
	 *     	    //The first part is a qualified name, "def" is the name, that is used in [Autowired(name="def")] meta-tag
 	 *	 		"com.domwires.core.factory.IDefault$def": {
 	 *	 			 //qualified name of implementation
	 *				 implementation: "com.domwires.core.factory.Default",
	 *				 //if true, factory will create and may new instance
	 *				 newInstance:true
	 *	 		},
	 *	 		"com.domwires.core.factory.ISuperCoolModel": {
	 *		 		implementation: "com.domwires.core.factory.SuperCoolModel"
	 *			 },
	 *	 		"int$coolValue": {
	 *	 			//factory will create and map instance to current value
	 *				 value:7
	 *			 },
	 *			 "int": {
	 *				 value:5
	 *	 		},
	 *	 		"Object$obj": {
	 *				 value:{
	 *					 firstName:"nikita",
	 *					 lastName:"dzigurda"
	 *		 		}
	 *			 },
	 *	 		"Array": {
	 *				 value:["botan","sjava"]
	 *	 		}
	 *		};
	 *
	 *     var factory:IAppFactory = new AppFactory();
	 *
	 *     //Create mapping config, using json data
	 *	   var config:MappingConfigDictionary = new MappingConfigDictionary(json);
	 *
	 *     //Set config to factory
	 * 	   factory.appendMappingConfig(config);
	 *
	 *	   var m:ISuperCoolModel = factory.getInstance(ISuperCoolModel);
	 *
	 *     trace(m.getCoolValue(); //returns 7;
	 *	   trace(m.value); //returns 5;
	 *     trace(m.def.result); //returns 123;
	 *     trace(m.object.firstName); //returns "nikita";
	 *     trace(m.array[1]);  //returns "sjava";
	 * </listing>
	 */
interface IAppFactory extends IAppFactoryImmutable extends IDisposable
{


	/**
	 * Automatically injects dependencies to newly created objects, using <code>getInstance</code> method.
	 */
	var autoInjectDependencies(never, set):Bool;

	/**
	 * Prints out extra information to logs.
	 * Useful for debugging, but leaks performance.
	 */
	var verbose(never, set):Bool;

	/**
	 * Will create type mapping, value mappings and inject dependencies, using config data.
	 * @param config Dictionary of <code>DependencyVo</code>
	 * @return
	 */
	function appendMappingConfig(config:MappingConfigDictionary):IAppFactory;

	/**
	 * Maps one class (or interface) type to another.
	 * @param type Type, that has to be mapped to another type
	 * @param to Type or instance, that type type should be mapped to
	 * @see #mapToValue()
	 * @return
	 */
	function mapToType(type:Class<Dynamic>, to:Class<Dynamic>):IAppFactory;

	/**
	 * Maps one class (or interface) type to instance.
	 * @param type Type, that has to be mapped to another type
	 * @param to Instance, that type type should be mapped to
	 * @param name Optional parameter, to map dependency to value with current name parameter in metatag
	 * @see #mapToType()
	 * @return
	 */
	function mapToValue(type:Class<Dynamic>, to:Dynamic, name:String = null):IAppFactory;

	/**
	 * Unmaps current type.
	 * @param type Class, that is mapped to some value
	 * @param name Name of value mapping in metatag
	 * @see #mapToValue()
	 * @return
	 */
	function unmapValue(type:Class<Dynamic>, name:String = null):IAppFactory;

	/**
	 * Unmaps current type.
	 * @param type Class, that is mapped to another class.
	 * @see #mapToType()
	 * @return
	 */
	function unmapType(type:Class<Dynamic>):IAppFactory;

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
	function registerPool(type:Class<Dynamic>, capacity:Int = 5, instantiateNow:Bool = false, constructorArgs:Dynamic = null,
						  isBusyFlagGetterName:String = null):IAppFactory;

	/**
	 * Unregisters and disposes pool for provided type.
	 * @param type Type of object to register pool for
	 * @return
	 */
	function unregisterPool(type:Class<Dynamic>):IAppFactory;

	/**
	 * Removes singleton of provided type.
	 * @param type
	 * @return
	 */
	function removeSingleton(type:Class<Dynamic>):IAppFactory;

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
	 * Inject dependencies to properties marked with [Autowired] to provided object and calls [PostConstruct] method if has any.
	 * @param object Object to inject dependencies to
	 * @return
	 */
	function injectDependencies(object:Dynamic):Dynamic;

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

