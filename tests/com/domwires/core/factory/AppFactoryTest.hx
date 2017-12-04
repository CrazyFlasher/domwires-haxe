/**
 * Created by Anton Nefjodov on 20.05.2016.
 */
package com.domwires.core.factory;

import flash.media.Camera;
import org.flexunit.asserts.AssertEquals;
import org.flexunit.asserts.AssertFalse;
import org.flexunit.asserts.AssertNotNull;
import org.flexunit.asserts.AssertNull;
import org.flexunit.asserts.AssertTrue;


class AppFactoryTest
{
    private var factory : IAppFactory;
    
    @Before
    public function setUp() : Void
    {
        factory = new AppFactory();
    }
    
    @After
    public function tearDown() : Void
    {
        factory.clear();
    }
    
    @Test
    //expects="Error"
    public function testUnmapClass() : Void
    {
        factory.mapToType(IMyType, MyType1);
        var o : IMyType = try cast(factory.getInstance(IMyType, [5, 7]), IMyType) catch(e:Dynamic) null;
        factory.unmapType(IMyType);
        var o2 : IMyType = try cast(factory.getInstance(IMyType, [5, 7]), IMyType) catch(e:Dynamic) null;
    }
    
    @Test
    //expects="Error"
    public function testUnmapInstance() : Void
    {
        var instance : IMyType = new MyType1(5, 7);
        factory.mapToValue(IMyType, o);
        
        var o : IMyType = try cast(factory.getInstance(IMyType), IMyType) catch(e:Dynamic) null;
        Assert.areEqual(o, instance);
        
        factory.unmapType(IMyType);
        var o2 : IMyType = try cast(factory.getInstance(IMyType), IMyType) catch(e:Dynamic) null;
    }
    
    @Test
    public function testGetNewInstance() : Void
    {
        factory.mapToType(IMyType, MyType1);
        factory.mapToValue(Class, MyType1);
        var o : IMyType = try cast(factory.getInstance(IMyType, [5, 7]), IMyType) catch(e:Dynamic) null;
        Assert.areEqual(o.a, 5);
        Assert.areEqual(o.b, 7);
    }
    
    @Test
    public function testGetFromPool() : Void
    {
        factory.mapToType(IMyType, MyType2);
        factory.registerPool(IMyType);
        var o : IMyType = factory.getInstance(IMyType);
        Assert.areEqual(o.a, 500);
        Assert.areEqual(o.b, 700);
    }
    
    @Test
    public function testUnregisterPool() : Void
    {
        factory.registerPool(IMyType);
        Assert.isTrue(factory.hasPoolForType(IMyType));
        factory.unregisterPool(IMyType);
        Assert.isFalse(factory.hasPoolForType(IMyType));
    }
    
    @Test
    public function testMapClass() : Void
    {
        Assert.isFalse(factory.hasTypeMappingForType(IMyType));
        factory.mapToType(IMyType, MyType2);
        Assert.isTrue(factory.hasTypeMappingForType(IMyType));
    }
    
    @Test
    public function testMapInstance() : Void
    {
        var o : IMyType = new MyType2();
        Assert.isFalse(factory.hasValueMappingForType(IMyType));
        factory.mapToValue(IMyType, o);
        Assert.isTrue(factory.hasValueMappingForType(IMyType));
        Assert.areEqual(o, factory.getInstance(IMyType));
    }
    
    @Test
    public function testRegisterPool() : Void
    {
        Assert.isFalse(factory.hasPoolForType(IMyType));
        factory.registerPool(IMyType);
        Assert.isTrue(factory.hasPoolForType(IMyType));
    }
    
    @Test
    public function clear() : Void
    {
        factory.mapToType(IMyType, MyType2);
        factory.registerPool(IMyType);
        factory.clear();
        Assert.isFalse(factory.hasTypeMappingForType(IMyType));
        Assert.isFalse(factory.hasPoolForType(IMyType));
    }
    
    @Test
    public function testAutowiredAutoInject() : Void
    {
        var factory : AppFactory = new AppFactory();
        factory.mapToValue(Camera, new Camera());
        factory.mapToValue(Array, []);
        factory.mapToValue(Dynamic, { });
        
        var obj : DIObject = factory.getInstance(DIObject);
        Assert.isNotNull(obj.c);
        Assert.isNotNull(obj.arr);
        Assert.isNotNull(obj.obj);
    }
    
    @Test
    public function testAutowiredManualInject() : Void
    {
        var factory : AppFactory = new AppFactory();
        factory.mapToValue(Camera, new Camera());
        factory.mapToValue(Array, []);
        factory.mapToValue(Dynamic, { });
        
        factory.autoInjectDependencies = false;
        
        var obj : DIObject = factory.getInstance(DIObject);
        Assert.isNull(obj.c);
        factory.injectDependencies(obj);
        Assert.isNotNull(obj.c);
        Assert.isNotNull(obj.arr);
        Assert.isNotNull(obj.obj);
    }
    
    @Test
    public function testAutowiredAutoInjectPostConstruct() : Void
    {
        var factory : AppFactory = new AppFactory();
        factory.mapToValue(Camera, new Camera());
        factory.mapToValue(Array, []);
        factory.mapToValue(Dynamic, { });
        
        var obj : DIObject = factory.getInstance(DIObject);
        
        Assert.isNotNull(obj.c);
        Assert.isNotNull(obj.arr);
        Assert.isNotNull(obj.obj);
        Assert.areEqual(obj.message, "OK!");
    }
    
    @Test
    public function testHasMappingForType() : Void
    {
        Assert.isFalse(factory.hasTypeMappingForType(IMyType));
        factory.mapToType(IMyType, MyType1);
        Assert.isTrue(factory.hasTypeMappingForType(IMyType));
    }
    
    @Test
    public function testGetInstanceByName() : Void
    {
        var i : Int = 1;
        factory.mapToValue(Int, i, "olo");
        var result : Int = factory.getInstance(Int, null, "olo");
        Assert.areEqual(result, 1);
    }
    
    @Test
    public function testHasPoolForType() : Void
    {
        Assert.isFalse(factory.hasPoolForType(IMyType));
        factory.registerPool(IMyType);
        Assert.isTrue(factory.hasPoolForType(IMyType));
    }
    
    @Test
    public function testGetSingleton() : Void
    {
        var obj : MyType2 = try cast(factory.getSingleton(MyType2), MyType2) catch(e:Dynamic) null;
        var obj2 : MyType2 = try cast(factory.getSingleton(MyType2), MyType2) catch(e:Dynamic) null;
        var obj3 : MyType2 = try cast(factory.getSingleton(MyType2), MyType2) catch(e:Dynamic) null;
        
        Assert.areEqual(obj2, obj3);  // obj
    }
    
    @Test
    public function testRemoveSingleton() : Void
    {
        var obj : MyType2 = try cast(factory.getSingleton(MyType2), MyType2) catch(e:Dynamic) null;
        var obj2 : MyType2 = try cast(factory.getInstance(MyType2), MyType2) catch(e:Dynamic) null;
        
        Assert.isTrue(obj == obj2);
        
        factory.removeSingleton(MyType2);
        
        obj2 = try cast(factory.getInstance(MyType2), MyType2) catch(e:Dynamic) null;
        
        Assert.isFalse(obj == obj2);
    }
    
    @Test
    public function testMapDefaultImplementation_yes() : Void
    {
        var factory : IAppFactory = new AppFactory();
        var d : IDefault = factory.getInstance(IDefault);
        Assert.areEqual(d.result, 123);
    }
    
    @Test
    //expects="Error"
    public function testMapDefaultImplementation_no() : Void
    {
        var factory : IAppFactory = new AppFactory();
        var d : IDefault2 = factory.getInstance(IDefault2);
        Assert.areEqual(d.result, 123);
    }
    
    @Test
    public function testClassToClassValue() : Void
    {
        factory.mapToType(IMyType, MyType1);
        factory.mapToValue(Class, MyType1);
        var o : IMyType = try cast(factory.getInstance(IMyType, [5, 7]), IMyType) catch(e:Dynamic) null;
        Assert.areEqual(o.a, 5);
        Assert.areEqual(o.b, 7);
        Assert.isFalse(Std.is(o.clazz, MyType1));
    }
    
    @Test
    public function testMappingToName() : Void
    {
        var arr1 : Array<Dynamic> = [1, 2, 3];
        var arr2 : Array<Dynamic> = [4, 5, 6];
        
        factory.mapToValue(Array, arr1, "shachlo");
        factory.mapToValue(Array, arr2, "olo");
        
        var myObj : MySuperCoolObj = try cast(factory.getInstance(MySuperCoolObj), MySuperCoolObj) catch(e:Dynamic) null;
        
        Assert.areEqual(myObj.arr1, arr2);
        Assert.areEqual(myObj.arr2, arr1);
    }
    
    @Test
    //expects="Error"
    public function testUnMappingFromName() : Void
    {
        var arr1 : Array<Dynamic> = [1, 2, 3];
        var arr2 : Array<Dynamic> = [4, 5, 6];
        
        factory.mapToValue(Array, arr1, "shachlo");
        factory.mapToValue(Array, arr2, "olo");
        
        var myObj : MySuperCoolObj = try cast(factory.getInstance(MySuperCoolObj), MySuperCoolObj) catch(e:Dynamic) null;
        
        Assert.areEqual(myObj.arr1, arr2);
        Assert.areEqual(myObj.arr2, arr1);
        
        factory.unmapValue(Array, "shachlo");
        
        factory.getInstance(MySuperCoolObj);
    }
    
    @Test
    public function testBooleanMapping() : Void
    {
        factory.mapToValue(Bool, true);
        
        var value : Bool = factory.getInstance(Bool);
        Assert.isTrue(value);
        
        factory.mapToValue(Bool, false);
        
        value = factory.getInstance(Bool);
        Assert.isFalse(value);
    }
    
    @Test
    public function testBooleanMapping2() : Void
    {
        var condition : Bool;
        
        factory.mapToValue(Bool, condition, "popa");
        
        var myObj : MySuperCoolObj2 = try cast(factory.getInstance(MySuperCoolObj2), MySuperCoolObj2) catch(e:Dynamic) null;
        Assert.areEqual(myObj.b, false);
        
        condition = true;
        
        factory.mapToValue(Bool, condition, "popa");
        
        var myObj2 : MySuperCoolObj2 = try cast(factory.getInstance(MySuperCoolObj2), MySuperCoolObj2) catch(e:Dynamic) null;
        Assert.areEqual(myObj2.b, true);
    }
    
    @Test
    public function testOptionalInjection() : Void
    {
        factory.mapToValue(Float, 1);
        
        var obj : MyOptional = factory.getInstance(MyOptional);
        
        Assert.isFalse(obj.b);
        Assert.isNull(obj.siski);
        Assert.areEqual(obj.n, 1);
    }
    
    @Test
    public function testSingleConstructorArg() : Void
    {
        var obj : MyType3 = factory.getInstance(MyType3, 7);
        Assert.areEqual(obj.a, 7);
    }
    
    @Test
    public function testPostConstruct() : Void
    {
        var o : PCTestObj = factory.getInstance(PCTestObj);
        Assert.areEqual(o.t, 1);
        
        factory.injectDependencies(o);
        Assert.areEqual(o.t, 1);
    }
    
    @Test
    public function testPostInject() : Void
    {
        var o : PITestObj = factory.getInstance(PITestObj);
        Assert.areEqual(o.t, 1);
        
        factory.injectDependencies(o);
        factory.injectDependencies(o);
        Assert.areEqual(o.t, 3);
    }
    
    @Test
    public function testMappingViaConfig() : Void
    {
        SuperCoolModel;
        Default;
        
        var json : Dynamic = 
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
        
        var config : MappingConfigDictionary = new MappingConfigDictionary(json);
        
        factory.appendMappingConfig(config);
        var m : ISuperCoolModel = factory.getInstance(ISuperCoolModel);
        Assert.areEqual(m.getCoolValue(), 7);
        Assert.areEqual(m.getMyBool(), false);
        Assert.areEqual(m.value, 5);
        Assert.areEqual(m.def.result, 123);
        Assert.areEqual(m.object.firstName, "nikita");
        Assert.areEqual(m.array[1], "sjava");
    }

    public function new()
    {
    }
}



class PITestObj
{
    public var t(get, never) : Int;

    private var _t : Int;
    
    @:meta(PostInject())

    public function pi() : Void
    {
        _t += 1;
    }
    
    private function get_t() : Int
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
    public var t(get, never) : Int;

    private var _t : Int;
    
    @:meta(PostConstruct())

    public function pc() : Void
    {
        _t += 1;
    }
    
    private function get_t() : Int
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
    @:meta(Autowired(name="popa",optional="true"))

    public var b : Bool;
    
    @:meta(Autowired())

    public var n : Float;
    
    @:meta(Autowired(optional="true"))

    public var siski : Camera;
    
    @:allow(com.domwires.core.factory)
    private function new()
    {
    }
}

class MySuperCoolObj2
{
    @:meta(Autowired(name="popa"))

    public var b : Bool;
    
    @:allow(com.domwires.core.factory)
    private function new()
    {
    }
}

class MySuperCoolObj
{
    @:meta(Autowired(name="olo"))

    public var arr1 : Array<Dynamic>;
    
    @:meta(Autowired(name="shachlo"))

    public var arr2 : Array<Dynamic>;
    
    @:allow(com.domwires.core.factory)
    private function new()
    {
    }
}

class DIObject
{
    public var message(get, never) : String;

    @:meta(Autowired())

    public var c : Camera;
    
    @:meta(Autowired())

    public var arr : Array<Dynamic>;
    
    @:meta(Autowired())

    public var obj : Dynamic;
    
    private var _message : String;
    
    @:allow(com.domwires.core.factory)
    private function new()
    {
    }
    
    @:meta(PostConstruct())

    public function init() : Void
    {
        _message = "OK!";
    }
    
    private function get_message() : String
    {
        return _message;
    }
}

class MyType1 implements IMyType
{
    public var a(get, never) : Int;
    public var b(get, never) : Int;
    public var clazz(get, never) : Class<Dynamic>;

    private var _a : Int;
    private var _b : Int;
    
    @:meta(Autowired())

    public var _clazz : Class<Dynamic>;
    
    @:allow(com.domwires.core.factory)
    private function new(a : Int, b : Int)
    {
        _a = a;
        _b = b;
    }
    
    private function get_a() : Int
    {
        return _a;
    }
    
    private function get_b() : Int
    {
        return _b;
    }
    
    private function get_clazz() : Class<Dynamic>
    {
        return _clazz;
    }
}

class MyType2 implements IMyType
{
    public var a(get, never) : Int;
    public var b(get, never) : Int;
    public var clazz(get, never) : Class<Dynamic>;

    @:allow(com.domwires.core.factory)
    private function new()
    {
    }
    
    private function get_a() : Int
    {
        return 500;
    }
    
    private function get_b() : Int
    {
        return 700;
    }
    
    private function get_clazz() : Class<Dynamic>
    {
        return null;
    }
}

class MyType3
{
    public var a(get, never) : Int;

    private var _a : Int;
    
    @:allow(com.domwires.core.factory)
    private function new(a : Int)
    {
        _a = a;
    }
    
    private function get_a() : Int
    {
        return _a;
    }
}

interface IMyType
{
    
    var a(get, never) : Int;    
    var b(get, never) : Int;    
    var clazz(get, never) : Class<Dynamic>;

}
