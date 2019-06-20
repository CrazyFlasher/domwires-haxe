/**
 * Created by Anton Nefjodov on 20.05.2016.
 */
package com.domwires.core.factory;

import com.domwires.core.common.BaseClass;
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
		factory.mapToValue(BaseClass, new BaseClass());

//		var o:IMyType = factory.getInstance(IMyType, [5, 7]);
//		factory.unmapType(IMyType);

//		Assert.isFalse(factory.hasTypeMappingForType(IMyType));
	}

	/*@Test
	public function testUnmapInstance():Void
	{
		var o:IMyType = factory.getInstance(IMyType);

		var instance:IMyType = new MyType1(5, 7);
		factory.mapToValue(IMyType, o);

		Assert.areEqual(o, instance);

		try
		{
			factory.unmapType(IMyType);
			var o2:IMyType = factory.getInstance(IMyType);
		} catch (error:String)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	public function testGetNewInstance():Void
	{
		factory.mapToType(IMyType, MyType1);
		factory.mapToValue(MyType1, MyType1);

		var o:IMyType = factory.getInstance(IMyType, [5, 7]);
		Assert.areEqual(o.a, 5);
		Assert.areEqual(o.b, 7);
	}

	/*
	@:meta(Test())
	public function testGetFromPool():Void
	{
		factory.mapToType(IMyType, MyType2);
		factory.registerPool(IMyType);
		var o:IMyType = factory.getInstance(IMyType);
		Assert.areEqual(o.a, 500);
		Assert.areEqual(o.b, 700);
	}

	@:meta(Test())

	public function testUnregisterPool():Void
	{
		factory.registerPool(IMyType);
		Assert.isTrue(factory.hasPoolForType(IMyType));
		factory.unregisterPool(IMyType);
		Assert.isFalse(factory.hasPoolForType(IMyType));
	}

	@:meta(Test())

	public function testMapClass():Void
	{
		Assert.isFalse(factory.hasTypeMappingForType(IMyType));
		factory.mapToType(IMyType, MyType2);
		Assert.isTrue(factory.hasTypeMappingForType(IMyType));
	}

	@:meta(Test())

	public function testMapInstance():Void
	{
		var o:IMyType = new MyType2();
		Assert.isFalse(factory.hasValueMappingForType(IMyType));
		factory.mapToValue(IMyType, o);
		Assert.isTrue(factory.hasValueMappingForType(IMyType));
		Assert.areEqual(o, factory.getInstance(IMyType));
	}

	@:meta(Test())

	public function testRegisterPool():Void
	{
		Assert.isFalse(factory.hasPoolForType(IMyType));
		factory.registerPool(IMyType);
		Assert.isTrue(factory.hasPoolForType(IMyType));
	}

	@:meta(Test())

	public function testClear():Void
	{
		factory.mapToType(IMyType, MyType2);
		factory.registerPool(IMyType);
		factory.clear();
		Assert.isFalse(factory.hasTypeMappingForType(IMyType));
		Assert.isFalse(factory.hasPoolForType(IMyType));
	}

	@:meta(Test())

	public function testAutowiredAutoInject():Void
	{
		var factory:AppFactory = new AppFactory();
		factory.mapToValue(Camera, new Camera());
		factory.mapToValue(Array, []);
		factory.mapToValue(Dynamic, { });

		var obj:DIObject = factory.getInstance(DIObject);
		Assert.isNotNull(obj.c);
		Assert.isNotNull(obj.arr);
		Assert.isNotNull(obj.obj);
	}

	@:meta(Test())

	public function testAutowiredManualInject():Void
	{
		var factory:AppFactory = new AppFactory();
		factory.mapToValue(Camera, new Camera());
		factory.mapToValue(Array, []);
		factory.mapToValue(Dynamic, { });

		factory.autoInjectDependencies = false;

		var obj:DIObject = factory.getInstance(DIObject);
		Assert.isNull(obj.c);
		factory.injectDependencies(obj);
		Assert.isNotNull(obj.c);
		Assert.isNotNull(obj.arr);
		Assert.isNotNull(obj.obj);
	}

	@:meta(Test())

	public function testAutowiredAutoInjectPostConstruct():Void
	{
		var factory:AppFactory = new AppFactory();
		factory.mapToValue(Camera, new Camera());
		factory.mapToValue(Array, []);
		factory.mapToValue(Dynamic, { });

		var obj:DIObject = factory.getInstance(DIObject);

		Assert.isNotNull(obj.c);
		Assert.isNotNull(obj.arr);
		Assert.isNotNull(obj.obj);
		Assert.areEqual(obj.message, "OK!");
	}

	@:meta(Test())

	public function testHasMappingForType():Void
	{
		Assert.isFalse(factory.hasTypeMappingForType(IMyType));
		factory.mapToType(IMyType, MyType1);
		Assert.isTrue(factory.hasTypeMappingForType(IMyType));
	}

	@:meta(Test())

	public function testGetInstanceByName():Void
	{
		var i:Int = 1;
		factory.mapToValue(Int, i, "olo");
		var result:Int = factory.getInstance(Int, null, "olo");
		Assert.areEqual(result, 1);
	}

	@:meta(Test())

	public function testHasPoolForType():Void
	{
		Assert.isFalse(factory.hasPoolForType(IMyType));
		factory.registerPool(IMyType);
		Assert.isTrue(factory.hasPoolForType(IMyType));
	}

	@:meta(Test())

	public function testGetSingleton():Void
	{
		var obj:MyType2 = factory.getSingleton(MyType2), MyType2);
		var obj2:MyType2 = factory.getSingleton(MyType2), MyType2);
		var obj3:MyType2 = factory.getSingleton(MyType2), MyType2);

		Assert.areEqual(obj2, obj3); // obj
	}

	@:meta(Test())

	public function testRemoveSingleton():Void
	{
		var obj:MyType2 = factory.getSingleton(MyType2);
		var obj2:MyType2 = factory.getInstance(MyType2);

		Assert.isTrue(obj == obj2);

		factory.removeSingleton(MyType2);

		obj2 = factory.getInstance(MyType2);

		Assert.isFalse(obj == obj2);
	}

	@:meta(Test())

	public function testMapDefaultImplementation_yes():Void
	{
		var factory:IAppFactory = new AppFactory();
		var d:IDefault = factory.getInstance(IDefault);
		Assert.areEqual(d.result, 123);
	}

	@:meta(Test(expects = "Error"))

	public function testMapDefaultImplementation_no():Void
	{
		var factory:IAppFactory = new AppFactory();
		var d:IDefault2 = factory.getInstance(IDefault2);
		Assert.areEqual(d.result, 123);
	}

	@:meta(Test())

	public function testClassToClassValue():Void
	{
		factory.mapToType(IMyType, MyType1);
		factory.mapToValue(Class, MyType1);
		var o:IMyType = factory.getInstance(IMyType, [5, 7]);
		Assert.areEqual(o.a, 5);
		Assert.areEqual(o.b, 7);
		Assert.isFalse(Std.is(o.clazz, MyType1));
	}

	@:meta(Test())

	public function testMappingToName():Void
	{
		var arr1:Array<Dynamic> = [1, 2, 3];
		var arr2:Array<Dynamic> = [4, 5, 6];

		factory.mapToValue(Array, arr1, "shachlo");
		factory.mapToValue(Array, arr2, "olo");

		var myObj:MySuperCoolObj = factory.getInstance(MySuperCoolObj);

		Assert.areEqual(myObj.arr1, arr2);
		Assert.areEqual(myObj.arr2, arr1);
	}

	@:meta(Test(expects = "Error"))

	public function testUnMappingFromName():Void
	{
		var arr1:Array<Dynamic> = [1, 2, 3];
		var arr2:Array<Dynamic> = [4, 5, 6];

		factory.mapToValue(Array, arr1, "shachlo");
		factory.mapToValue(Array, arr2, "olo");

		var myObj:MySuperCoolObj = factory.getInstance(MySuperCoolObj);

		Assert.areEqual(myObj.arr1, arr2);
		Assert.areEqual(myObj.arr2, arr1);

		factory.unmapValue(Array, "shachlo");

		factory.getInstance(MySuperCoolObj);
	}

	@:meta(Test())

	public function testBooleanMapping():Void
	{
		factory.mapToValue(Bool, true);

		var value:Bool = factory.getInstance(Bool);
		Assert.isTrue(value);

		factory.mapToValue(Bool, false);

		value = factory.getInstance(Bool);
		Assert.isFalse(value);
	}

	@:meta(Test())

	public function testBooleanMapping2():Void
	{
		var condition:Bool;

		factory.mapToValue(Bool, condition, "popa");

		var myObj:MySuperCoolObj2 = factory.getInstance(MySuperCoolObj2);
		Assert.areEqual(myObj.b, false);

		condition = true;

		factory.mapToValue(Bool, condition, "popa");

		var myObj2:MySuperCoolObj2 = factory.getInstance(MySuperCoolObj2);
		Assert.areEqual(myObj2.b, true);
	}

	@:meta(Test())

	public function testOptionalInjection():Void
	{
		factory.mapToValue(Float, 1);

		var obj:MyOptional = factory.getInstance(MyOptional);

		Assert.isFalse(obj.b);
		Assert.isNull(obj.siski);
		Assert.areEqual(obj.n, 1);
	}

	@:meta(Test())

	public function testSingleConstructorArg():Void
	{
		var obj:MyType3 = factory.getInstance(MyType3, 7);
		Assert.areEqual(obj.a, 7);
	}

	@:meta(Test())

	public function testPostConstruct():Void
	{
		var o:PCTestObj = factory.getInstance(PCTestObj);
		Assert.areEqual(o.t, 1);

		factory.injectDependencies(o);
		Assert.areEqual(o.t, 1);
	}

	@:meta(Test())

	public function testPostInject():Void
	{
		var o:PITestObj = factory.getInstance(PITestObj);
		Assert.areEqual(o.t, 1);

		factory.injectDependencies(o);
		factory.injectDependencies(o);
		Assert.areEqual(o.t, 3);
	}

	@:meta(Test())

	public function testMappingViaConfig():Void
	{
		SuperCoolModel;
		Default;

		var json:Dynamic =
		{
			com.domwires.core.factory.IDefault$def : {
		implementation : "com.domwires.core.factory.Default",
		newInstance : true
		},
		com.domwires.core.factory.ISuperCoolModel : {
		implementation : "com.domwires.core.factory.SuperCoolModel"
		},
		int$coolValue : {
		value : 7
		},
		Boolean$myBool : {
		value : false
		},
		int : {
		value : 5
		},
		Object$obj : {
		value : {
		firstName : "nikita",
		lastName : "dzigurda"
		}
		},
		Array : {
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

	@:meta(Test())

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

	@:meta(Test())

	public function testMapSingletonToInterface():Void
	{
		factory.mapToType(IPool, Pool1);
		var p1:IPool = factory.getSingleton(IPool);
		Assert.areEqual(p1.value, 1);
	}

	@:meta(Test())

	public function testFromPoolWithConstructorArgs():Void
	{
		factory.mapToType(IPool2, Pool3);
		factory.registerPool(IPool2);
		var p1:IPool2 = factory.getInstance(IPool2, ["olo", 1.5]);
		Assert.areEqual(p1.s, "olo");
		Assert.areEqual(p1.n, 1.5);
	}

	@:meta(Test())

	public function testInjectDependenciesToPoolObject():Void
	{
		factory.mapToType(IPool, Pool4);
		factory.registerPool(IPool);
		factory.mapToValue(Int, 5, "v");
		var p1:IPool = factory.getInstance(IPool);
		Assert.areEqual(p1.value, 6);
	}

	@:meta(Test())

	public function testGetInstanceFromNotFullPool():Void
	{
		factory.mapToType(IPool2, Pool3);
		factory.registerPool(IPool2, 100);

		var instance:IPool2 = factory.getInstance(IPool2, ["olo", 1.5]);
		var instance2:IPool2 = factory.getInstanceFromPool(IPool2);

		Assert.areEqual(instance, instance2);
	}

	@:meta(Test())

	public function testGetPoolCapacity():Void
	{
		factory.registerPool(IPool2, 100);

		var capacity:Int = factory.getPoolCapacity(IPool2);

		Assert.areEqual(capacity, 100);
	}

	@:meta(Test())

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

	@:meta(Test())

	public function testExtendPool():Void
	{
		factory.registerPool(IPool2, 100);
		factory.increasePoolCapacity(IPool2, 5);

		var capacity:Int = factory.getPoolCapacity(IPool2);

		Assert.areEqual(capacity, 105);
	}

	@:meta(Test())

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

	@:meta(Test())

	public function testOfPoolObjectsAreUnique():Void
	{
		factory.registerPool(IMyPool, 2, true);

		var o1:IMyPool = factory.getInstance(IMyPool);
		var o2:IMyPool = factory.getInstance(IMyPool);

		Assert.isFalse(o1 == o2);
	}

	@:meta(Test())

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

	@:meta(Test())

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

	@:meta(Test())

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

	@:meta(Test())

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
	}

	public function new()
	{
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

class Pool1 implements IPool
{
	public var value(get, never):Int;


	private function get_value():Int
	{
		return 1;
	}

	@:allow(com.domwires.core.factory)
	private function new()
	{
	}
}

class Pool2 implements IPool
{
	public var value(get, never):Int;


	private function get_value():Int
	{
		return 2;
	}

	@:allow(com.domwires.core.factory)
	private function new()
	{
	}
}

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

class Pool4 implements IPool
{
	public var value(get, never):Int;


	@:meta(Autowired(name = "v"))

	public var v:Int;

	@:meta(PostConstruct())

	public function pc():Void
	{
		v++;
	}

	private function get_value():Int
	{
		return v;
	}

	@:allow(com.domwires.core.factory)
	private function new()
	{
	}
}


class PITestObj
{
	public var t(get, never):Int;

	private var _t:Int;

	@:meta(PostInject())

	public function pi():Void
	{
		_t += 1;
	}

	private function get_t():Int
	{
		return _t;
	}

	@:allow(com.domwires.core.factory)
	private function new()
	{
	}
}

class PCTestObj
{
	public var t(get, never):Int;

	private var _t:Int;

	@:meta(PostConstruct())

	public function pc():Void
	{
		_t += 1;
	}

	private function get_t():Int
	{
		return _t;
	}

	@:allow(com.domwires.core.factory)
	private function new()
	{
	}
}

class MyOptional
{
	@:meta(Autowired(name = "popa", optional = "true"))

	public var b:Bool;

	@:meta(Autowired())

	public var n:Float;

	@:meta(Autowired(optional = "true"))

	public var siski:String;

	@:allow(com.domwires.core.factory)
	private function new()
	{
	}
}

class MySuperCoolObj2
{
	@:meta(Autowired(name = "popa"))

	public var b:Bool;

	@:allow(com.domwires.core.factory)
	private function new()
	{
	}
}

class MySuperCoolObj
{
	@:meta(Autowired(name = "olo"))

	public var arr1:Array<Dynamic>;

	@:meta(Autowired(name = "shachlo"))

	public var arr2:Array<Dynamic>;

	@:allow(com.domwires.core.factory)
	private function new()
	{
	}
}

class DIObject
{
	public var message(get, never):String;

	@:meta(Autowired())

	public var c:String;

	@:meta(Autowired())

	public var arr:Array<Dynamic>;

	@:meta(Autowired())

	public var obj:Dynamic;

	private var _message:String;

	@:allow(com.domwires.core.factory)
	private function new()
	{
	}

	@:meta(PostConstruct())

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
	public var clazz(get, never):BaseClass;

	private var _a:Int;
	private var _b:Int;

	@Autowired
	public var _clazz:BaseClass;

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

	private function get_clazz():BaseClass
	{
		return _clazz;
	}
}

class MyType2 implements IMyType
{
	public var a(get, never):Int;
	public var b(get, never):Int;
	public var clazz(get, never):BaseClass;

	@:allow(com.domwires.core.factory)
	private function new()
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

	private function get_clazz():BaseClass
	{
		return null;
	}
}

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
	var clazz(get, never):BaseClass;
}
