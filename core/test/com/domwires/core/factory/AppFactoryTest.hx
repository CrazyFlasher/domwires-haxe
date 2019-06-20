/**
 * Created by Anton Nefjodov on 20.05.2016.
 */
package com.domwires.core.factory;

import com.domwires.core.testObject.SuperCoolModel;
import com.domwires.core.testObject.ISuperCoolModel;
import Array;
import Class;
import com.domwires.core.testObject.Default;
import com.domwires.core.testObject.IDefault;
import massive.munit.Assert;


class AppFactoryTest
{
	private var factory:IAppFactory;

	@Before
	public function setUp():Void
	{
		factory = new AppFactory();
		factory.verbose = true;
	}

	@After
	public function tearDown():Void
	{
		factory.clear();
	}

	@Test
	public function testUnmapClass():Void
	{
		factory.mapToType(IMyType, MyType1);
		factory.mapToValue("Class<Dynamic>", MyType1);

		var o:IMyType = factory.getInstance(IMyType, [5, 7]);
		factory.unmapType(IMyType);

		Assert.isFalse(factory.hasTypeMappingForType(IMyType));
	}

	@Test
	public function testUnmapInstance():Void
	{
		var instance:IMyType = new MyType1(5, 7);
		factory.mapToValue(IMyType, instance);

		var o:IMyType = factory.getInstance(IMyType);

		Assert.areEqual(o, instance);

		factory.unmapValue(IMyType);

		try
		{
			factory.getInstance(IMyType);
		} catch (error:Dynamic)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	public function testGetNewInstance():Void
	{
		factory.mapToType(IMyType, MyType1);
		factory.mapToValue("Class<Dynamic>", MyType1);

		var o:IMyType = factory.getInstance(IMyType, [5, 7]);
		Assert.areEqual(o.a, 5);
		Assert.areEqual(o.b, 7);
	}


	@Test
	public function testGetFromPool():Void
	{
		factory.mapToType(IMyType, MyType2);
		factory.registerPool(IMyType);
		var o:IMyType = factory.getInstance(IMyType);
		Assert.areEqual(o.a, 500);
		Assert.areEqual(o.b, 700);
	}

	@Test
	public function testUnregisterPool():Void
	{
		factory.registerPool(IMyType);
		Assert.isTrue(factory.hasPoolForType(IMyType));
		factory.unregisterPool(IMyType);
		Assert.isFalse(factory.hasPoolForType(IMyType));
	}

	@Test
	public function testMapClass():Void
	{
		Assert.isFalse(factory.hasTypeMappingForType(IMyType));
		factory.mapToType(IMyType, MyType2);
		Assert.isTrue(factory.hasTypeMappingForType(IMyType));
	}

	@Test
	public function testMapInstance():Void
	{
		var o:IMyType = new MyType2();
		Assert.isFalse(factory.hasValueMappingForType(IMyType));
		factory.mapToValue(IMyType, o);
		Assert.isTrue(factory.hasValueMappingForType(IMyType));
		Assert.areEqual(o, factory.getInstance(IMyType));
	}

	@Test
	public function testRegisterPool():Void
	{
		Assert.isFalse(factory.hasPoolForType(IMyType));
		factory.registerPool(IMyType);
		Assert.isTrue(factory.hasPoolForType(IMyType));
	}

	@Test
	public function testClear():Void
	{
		factory.mapToType(IMyType, MyType2);
		factory.registerPool(IMyType);
		factory.clear();
		Assert.isFalse(factory.hasTypeMappingForType(IMyType));
		Assert.isFalse(factory.hasPoolForType(IMyType));
	}

	@Test
	public function testAutowiredAutoInject():Void
	{
		var factory:AppFactory = new AppFactory();
		factory.mapToValue(String, "asd");
		factory.mapToValue(Int, 5);

		var obj:DIObject = factory.getInstance(DIObject);
		Assert.isNotNull(obj.c);
		Assert.isNotNull(obj.value);
	}

	@Test
	public function testAutowiredManualInject():Void
	{
		var factory:AppFactory = new AppFactory();
		factory.mapToValue(String, "asd");
		factory.mapToValue(Int, 5);

		factory.autoInjectDependencies = false;

		var obj:DIObject = factory.getInstance(DIObject);
		Assert.isNull(obj.c);
		factory.injectDependencies(obj);
		Assert.isNotNull(obj.c);
	}

	@Test
	public function testAutowiredAutoInjectPostConstruct():Void
	{
		var factory:AppFactory = new AppFactory();
		factory.mapToValue(String, "asd");
		factory.mapToValue(Int, 5);

		var obj:DIObject = factory.getInstance(DIObject);

		Assert.isNotNull(obj.c);
		Assert.areEqual(obj.message, "OK!");
	}

	@Test
	public function testHasMappingForType():Void
	{
		Assert.isFalse(factory.hasTypeMappingForType(IMyType));
		factory.mapToType(IMyType, MyType1);
		Assert.isTrue(factory.hasTypeMappingForType(IMyType));
	}

	@Test
	public function testGetInstanceByName():Void
	{
		var i:Int = 1;
		factory.mapToValue(Int, i, "olo");
		var result:Int = factory.getInstance(Int, null, "olo");
		Assert.areEqual(result, 1);
	}

	@Test
	public function testHasPoolForType():Void
	{
		Assert.isFalse(factory.hasPoolForType(IMyType));
		factory.registerPool(IMyType);
		Assert.isTrue(factory.hasPoolForType(IMyType));
	}

	@Test
	public function testGetSingleton():Void
	{
		var obj:MyType2 = factory.getSingleton(MyType2);
		var obj2:MyType2 = factory.getSingleton(MyType2);
		var obj3:MyType2 = factory.getSingleton(MyType2);

		Assert.areEqual(obj2, obj3); // obj
	}

	@Test
	public function testRemoveSingleton():Void
	{
		var obj:MyType2 = factory.getSingleton(MyType2);
		var obj2:MyType2 = factory.getInstance(MyType2);

		Assert.isTrue(obj == obj2);

		factory.removeSingleton(MyType2);

		obj2 = factory.getInstance(MyType2);

		Assert.isFalse(obj == obj2);
	}

	@Test
	public function testMapDefaultImplementation_yes():Void
	{
		Default;
		var d:IDefault = factory.getInstance(IDefault);
		Assert.areEqual(d.result, 123);
	}

	/*@Test
	public function testMapDefaultImplementation_no():Void
	{
		var factory:IAppFactory = new AppFactory();

		try
		{
			var d:IDefault2 = factory.getInstance(IDefault2);
		} catch (error:Dynamic)
		{
			Assert.isTrue(true);
		}
	}*/

	@Test
	public function testClassToClassValue():Void
	{
		factory.mapToType(IMyType, MyType1);
		factory.mapToValue("Class<Dynamic>", MyType1);
		var o:IMyType = factory.getInstance(IMyType, [5, 7]);
		Assert.areEqual(o.a, 5);
		Assert.areEqual(o.b, 7);
		Assert.isFalse(Std.is(o.clazz, MyType1));
	}

	@Test
	public function testMappingToName():Void
	{
		var arr1:Array<Dynamic> = [1, 2, 3];
		var arr2:Array<Dynamic> = [4, 5, 6];

		factory.mapToValue("Array<String>", arr1, "shachlo");
		factory.mapToValue("Array<String>", arr2, "olo");

		var myObj:MySuperCoolObj = factory.getInstance(MySuperCoolObj);

		Assert.areEqual(myObj.arr1, arr2);
		Assert.areEqual(myObj.arr2, arr1);
	}

	@Test
	public function testUnMappingFromName():Void
	{
		var arr1:Array<Dynamic> = [1, 2, 3];
		var arr2:Array<Dynamic> = [4, 5, 6];

		factory.mapToValue("Array<String>", arr1, "shachlo");
		factory.mapToValue("Array<String>", arr2, "olo");

		var myObj:MySuperCoolObj = factory.getInstance(MySuperCoolObj);

		Assert.areEqual(myObj.arr1, arr2);
		Assert.areEqual(myObj.arr2, arr1);

		factory.unmapValue(Array, "shachlo");

		try
		{
			factory.getInstance(MySuperCoolObj);
		} catch (error:Dynamic)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	public function testBooleanMapping():Void
	{
		factory.mapToValue(Bool, true);

		var value:Bool = factory.getInstance(Bool);
		Assert.isTrue(value);

		factory.mapToValue(Bool, false);

		value = factory.getInstance(Bool);
		Assert.isFalse(value);
	}

	@Test
	public function testBooleanMapping2():Void
	{
		var condition:Bool = false;

		factory.mapToValue("Bool", condition, "popa");

		var c:Dynamic = condition;

		var myObj:MySuperCoolObj2 = factory.getInstance(MySuperCoolObj2);
		Assert.areEqual(myObj.b, false);

		condition = true;

		factory.mapToValue("Bool", condition, "popa");

		var myObj2:MySuperCoolObj2 = factory.getInstance(MySuperCoolObj2);
		Assert.areEqual(myObj2.b, true);
	}

	@Test
	public function testOptionalInjection():Void
	{
		factory.mapToValue(Float, 1);

		var obj:MyOptional = factory.getInstance(MyOptional);

		Assert.isFalse(obj.b);
		Assert.isNull(obj.siski);
		Assert.areEqual(obj.n, 1);
	}

	@Test
	public function testSingleConstructorArg():Void
	{
		var obj:MyType3 = factory.getInstance(MyType3, 7);
		Assert.areEqual(obj.a, 7);
	}

	@Test
	public function testPostConstruct():Void
	{
		var o:PCTestObj = factory.getInstance(PCTestObj);
		Assert.areEqual(o.t, 1);

		factory.injectDependencies(o);
		Assert.areEqual(o.t, 1);
	}

	@Test
	public function testPostInject():Void
	{
		var o:PITestObj = factory.getInstance(PITestObj);
		Assert.areEqual(o.t, 1);

		factory.injectDependencies(o);
		factory.injectDependencies(o);
		Assert.areEqual(o.t, 3);
	}

	@TestDebug
	public function testMappingViaConfig():Void
	{
		SuperCoolModel;
		Default;

		var json:Dynamic =
		{
			"com.domwires.core.testObject.IDefault$def" : {
				implementation : "com.domwires.core.testObject.Default",
				newInstance : true
			},
			"com.domwires.core.testObject.ISuperCoolModel" : {
				implementation : "com.domwires.core.testObject.SuperCoolModel"
			},
			"int$coolValue" : {
				value : 7
			},
			"Boolean$myBool" : {
				value : false
			},
			"int" : {
				value : 5
			},
			"Object$obj" : {
				value : {
					firstName : "nikita",
					lastName : "dzigurda"
				}
			},
			"Array" : {
				value : ["botan", "sjava"]
			}
		};

		var config:MappingConfigDictionary = new MappingConfigDictionary(json);

		factory.appendMappingConfig(config);
		var m:ISuperCoolModel = factory.getInstance(ISuperCoolModel);
		Assert.areEqual(m.getCoolValue(), 7);
		Assert.areEqual(m.getMyBool(), false);
		Assert.areEqual(m.value, 5);
		Assert.areEqual(m.def.result, 123);
		Assert.areEqual(m.object.firstName, "nikita");
		Assert.areEqual(m.array[1], "sjava");
	}

	/*@Test
	public function testMapPoolToInterface():Void
	{
		factory.mapToType(IPool, Pool1);
		factory.registerPool(IPool);

		var p:IPool = factory.getInstance(IPool);
		Assert.areEqual(p.value, 1);

		factory.mapToType(IPool, Pool2);
		factory.registerPool(IPool);

		var p2:IPool = factory.getInstance(IPool);
		Assert.areEqual(p2.value, 2);
	}

	@Test
	public function testMapSingletonToInterface():Void
	{
		factory.mapToType(IPool, Pool1);
		var p1:IPool = factory.getSingleton(IPool);
		Assert.areEqual(p1.value, 1);
	}

	@Test
	public function testFromPoolWithConstructorArgs():Void
	{
		factory.mapToType(IPool2, Pool3);
		factory.registerPool(IPool2);
		var p1:IPool2 = factory.getInstance(IPool2, ["olo", 1.5]);
		Assert.areEqual(p1.s, "olo");
		Assert.areEqual(p1.n, 1.5);
	}

	@Test
	public function testInjectDependenciesToPoolObject():Void
	{
		factory.mapToType(IPool, Pool4);
		factory.registerPool(IPool);
		factory.mapToValue(Int, 5, "v");
		var p1:IPool = factory.getInstance(IPool);
		Assert.areEqual(p1.value, 6);
	}

	@Test
	public function testGetInstanceFromNotFullPool():Void
	{
		factory.mapToType(IPool2, Pool3);
		factory.registerPool(IPool2, 100);

		var instance:IPool2 = factory.getInstance(IPool2, ["olo", 1.5]);
		var instance2:IPool2 = factory.getInstanceFromPool(IPool2);

		Assert.areEqual(instance, instance2);
	}

	@Test
	public function testGetPoolCapacity():Void
	{
		factory.registerPool(IPool2, 100);

		var capacity:Int = factory.getPoolCapacity(IPool2);

		Assert.areEqual(capacity, 100);
	}

	@Test
	public function testGetPoolTotalInstancesCount():Void
	{
		factory.mapToType(IPool2, Pool3);
		factory.registerPool(IPool2, 100);

		for (i in 0...5)
		{
			factory.getInstance(IPool2, ["olo", 1.5]);
		}

		var count:Int = factory.getPoolInstanceCount(IPool2);

		Assert.areEqual(count, 5);
	}

	@Test
	public function testExtendPool():Void
	{
		factory.registerPool(IPool2, 100);
		factory.increasePoolCapacity(IPool2, 5);

		var capacity:Int = factory.getPoolCapacity(IPool2);

		Assert.areEqual(capacity, 105);
	}

	@Test
	public function testGetInstanceFromPool():Void
	{
		factory.mapToType(IPool2, Pool3);
		factory.registerPool(IPool2, 10);

		var instance_1:IPool2 = factory.getInstance(IPool2, ["olo", 1.5]);
		var instance_2:IPool2 = factory.getInstance(IPool2, ["olo", 1.5]);

		var instanceFromPool:IPool2;
		instanceFromPool = factory.getInstanceFromPool(IPool2);
		Assert.areEqual(instanceFromPool, instance_1);

		instanceFromPool = factory.getInstanceFromPool(IPool2);
		Assert.areEqual(instanceFromPool, instance_2);

		instanceFromPool = factory.getInstanceFromPool(IPool2);
		Assert.areEqual(instanceFromPool, instance_1);
	}

	@Test
	public function testOfPoolObjectsAreUnique():Void
	{
		factory.registerPool(IMyPool, 2, true);

		var o1:IMyPool = factory.getInstance(IMyPool);
		var o2:IMyPool = factory.getInstance(IMyPool);

		Assert.isFalse(o1 == o2);
	}

	@Test
	public function testReturnOnlyNotBusyObjectsFromPool():Void
	{
		factory.registerPool(BusyPoolObject, 2, true, null, "isBusy");

		var o1:BusyPoolObject = factory.getInstance(BusyPoolObject);
		o1.isBusy = true;

		factory.getInstance(BusyPoolObject);

		var o2:BusyPoolObject = factory.getInstance(BusyPoolObject);
		Assert.isFalse(o2.isBusy);
		Assert.isFalse(o1 == o2);
	}

	@Test
	public function testAllPoolItemAreBusy():Void
	{
		factory.registerPool(BusyPoolObject, 2, true, null, "isBusy");

		Assert.isFalse(factory.getAllPoolItemsAreBusy(BusyPoolObject));

		var o1:BusyPoolObject = factory.getInstance(BusyPoolObject);
		o1.isBusy = true;

		Assert.isFalse(factory.getAllPoolItemsAreBusy(BusyPoolObject));

		var o2:BusyPoolObject = factory.getInstance(BusyPoolObject);
		o2.isBusy = true;

		Assert.isTrue(factory.getAllPoolItemsAreBusy(BusyPoolObject));

		factory.increasePoolCapacity(BusyPoolObject, 1);

		Assert.isFalse(factory.getAllPoolItemsAreBusy(BusyPoolObject));

		var o3:BusyPoolObject = factory.getInstance(BusyPoolObject);
		o3.isBusy = true;

		Assert.isTrue(factory.getAllPoolItemsAreBusy(BusyPoolObject));
	}

	@Test
	public function testAllPoolItemAreBusyIncrease():Void
	{
		factory.registerPool(BusyPoolObject, 2, true, null, "isBusy");

		Assert.isFalse(factory.getAllPoolItemsAreBusy(BusyPoolObject));

		var o1:BusyPoolObject = factory.getInstance(BusyPoolObject);
		o1.isBusy = true;
		var o2:BusyPoolObject = factory.getInstance(BusyPoolObject);
		o2.isBusy = true;

		Assert.isTrue(factory.getAllPoolItemsAreBusy(BusyPoolObject));

		factory.getInstance(BusyPoolObject);
	}

	@Test
	public function testPoolItemsBusyCount():Void
	{
		factory.registerPool(BusyPoolObject, 3, true, null, "isBusy");

		var o1:BusyPoolObject = factory.getInstance(BusyPoolObject);
		o1.isBusy = true;
		var o2:BusyPoolObject = factory.getInstance(BusyPoolObject);
		o2.isBusy = true;
		var o3:BusyPoolObject = factory.getInstance(BusyPoolObject);
		o3.isBusy = true;

		Assert.isTrue(factory.getAllPoolItemsAreBusy(BusyPoolObject));

		o2.isBusy = false;

		Assert.areEqual(factory.getPoolBusyInstanceCount(BusyPoolObject), 2);

		var o4:BusyPoolObject = factory.getInstance(BusyPoolObject);
		o4.isBusy = true;

		Assert.areEqual(o4, o2);

		Assert.areEqual(factory.getPoolBusyInstanceCount(BusyPoolObject), 3);
		Assert.isTrue(factory.getAllPoolItemsAreBusy(BusyPoolObject));
	}*/
}


interface IPool
{
	var value(get, never):Int;
}

interface IPool2 extends IPool
{
	var s(get, never):String;
	var n(get, never):Float;
}

@:rtti
class Pool1 implements IPool
{
	public var value(get, never):Int;

	private function get_value():Int
	{
		return 1;
	}
}

@:rtti
class Pool2 implements IPool
{
	public var value(get, never):Int;

	private function get_value():Int
	{
		return 2;
	}
}

@:rtti
class Pool3 implements IPool2
{
	public var value(get, never):Int;
	public var s(get, never):String;
	public var n(get, never):Float;

	private var _s:String;
	private var _n:Float;

	@:allow(com.domwires.core.factory)
	private function new(s:String, n:Float)
	{
		this._s = s;
		this._n = n;
	}

	private function get_value():Int
	{
		return 2;
	}

	private function get_s():String
	{
		return _s;
	}

	private function get_n():Float
	{
		return _n;
	}
}

@:rtti
class Pool4 implements IPool
{
	public var value(get, never):Int;

	@Autowired("v")
	public var v:Int;

	@PostConstruct
	public function pc():Void
	{
		v++;
	}

	private function get_value():Int
	{
		return v;
	}
}

@:rtti
class PITestObj
{
	public var t(get, never):Int;

	private var _t:Int;

	@PostInject
	public function pi():Void
	{
		_t += 1;
	}

	private function get_t():Int
	{
		return _t;
	}
}

@:rtti
class PCTestObj
{
	public var t(get, never):Int;

	private var _t:Int;

	@PostConstruct
	public function pc():Void
	{
		_t += 1;
	}

	private function get_t():Int
	{
		return _t;
	}
}

@:rtti
class MyOptional
{
	@Autowired("popa", true)
	public var b:Bool;

	@Autowired
	public var n:Float;

	@Autowired(null, true)
	public var siski:String;
}

@:rtti
class MySuperCoolObj2
{
	@Autowired("popa")
	public var b:Bool;

	public function new(){}
}

@:rtti
class MySuperCoolObj
{
	@Autowired("olo")
	public var arr1:Array<String>;

	@Autowired("shachlo")
	public var arr2:Array<String>;
}

@:rtti
class DIObject
{
	public var message(get, never):String;

	@Autowired
	public var c:String;

	@Autowired
	public var value:Int;

	private var _message:String;

	public function new()
	{

	}

	@PostConstruct
	public function init():Void
	{
		_message = "OK!";
	}

	private function get_message():String
	{
		return _message;
	}
}

@:rtti
class MyType1 implements IMyType
{
	public var a(get, never):Int;
	public var b(get, never):Int;
	public var clazz(get, never):Class<Dynamic>;

	private var _a:Int;
	private var _b:Int;

	@Autowired
	public var _clazz:Class<Dynamic>;

	@:allow(com.domwires.core.factory)
	private function new(a:Int, b:Int)
	{
		_a = a;
		_b = b;
	}

	private function get_a():Int
	{
		return _a;
	}

	private function get_b():Int
	{
		return _b;
	}

	private function get_clazz():Class<Dynamic>
	{
		return _clazz;
	}
}

@:rtti
class MyType2 implements IMyType
{
	public var a(get, never):Int;
	public var b(get, never):Int;
	public var clazz(get, never):Class<Dynamic>;

	public function new()
	{

	}

	private function get_a():Int
	{
		return 500;
	}

	private function get_b():Int
	{
		return 700;
	}

	private function get_clazz():Class<Dynamic>
	{
		return null;
	}
}

@:rtti
class MyType3
{
	public var a(get, never):Int;

	private var _a:Int;

	@:allow(com.domwires.core.factory)
	private function new(a:Int)
	{
		_a = a;
	}

	private function get_a():Int
	{
		return _a;
	}
}

interface IMyType
{
	var a(get, never):Int;
	var b(get, never):Int;
	var clazz(get, never):Class<Dynamic>;
}