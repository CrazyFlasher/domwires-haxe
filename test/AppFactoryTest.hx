package ;

import mock.mvc.models.ISuperCoolModel;
import com.domwires.core.factory.MappingConfigDictionary;
import hex.di.IInjectorContainer;
import haxe.io.Error;
import mock.obj.IMockLonelyInterface;
import mock.obj.MockObj_2;
import mock.obj.MockObj_2;
import mock.obj.MockBusyPoolObject;
import mock.obj.MockPool_4;
import mock.obj.IMockPool_2;
import mock.obj.MockPool_3;
import mock.obj.MockPool_2;
import mock.obj.MockPool_1;
import mock.obj.IMockPool_1;
import massive.munit.Assert;
import mock.obj.IMockType;
import com.domwires.core.factory.AppFactory;
import com.domwires.core.factory.IAppFactory;

class AppFactoryTest
{
    private var factory:IAppFactory;

    @BeforeClass
    public function beforeClass():Void
    {
    }

    @AfterClass
    public function afterClass():Void
    {
    }

    @Before
    public function setup():Void
    {
        factory = new AppFactory();
    }

    @After
    public function tearDown():Void
    {
        factory.clear();
    }

    @Test
    public function testRegisterPool():Void
    {
        Assert.isFalse(factory.hasPoolForType(IMockType));
        factory.registerPool(IMockType);
        Assert.isTrue(factory.hasPoolForType(IMockType));
    }

    @Test
    public function testUnregisterPool():Void
    {
        factory.registerPool(IMockType);
        Assert.isTrue(factory.hasPoolForType(IMockType));
        Assert.isTrue(factory.hasPoolForTypeByClassName("mock.obj.IMockType"));
        factory.unregisterPool(IMockType);
        Assert.isFalse(factory.hasPoolForType(IMockType));
        Assert.isFalse(factory.hasPoolForTypeByClassName("mock.obj.IMockType"));
    }

    @Test
    public function testGetFromPool():Void
    {
        factory.mapToType(IMockType, MockType_2);
        factory.registerPool(IMockType);
        var o:IMockType = factory.getInstance(IMockType);
        Assert.areEqual(o.a, 500);
        Assert.areEqual(o.b, 700);
    }

    @Test
    public function testClear():Void
    {
        factory.mapToType(IMockType, MockType_2);
        factory.registerPool(IMockType);
        factory.clear();
        Assert.isFalse(factory.hasMapping(IMockType));
        Assert.isFalse(factory.hasPoolForType(IMockType));
    }

    @Test
    public function testHasPoolForType():Void
    {
        Assert.isFalse(factory.hasPoolForType(IMockType));
        factory.registerPool(IMockType);
        Assert.isTrue(factory.hasPoolForType(IMockType));
    }

    @Test
    public function testMapPoolToInterface():Void
    {
        factory.mapToType(IMockPool_1, MockPool_1);
        factory.registerPool(IMockPool_1);

        var p:IMockPool_1 = factory.getInstance(IMockPool_1);
        Assert.areEqual(p.value, 1);

        factory.mapToType(IMockPool_1, MockPool_2);
        factory.registerPool(IMockPool_1);

        var p2:IMockPool_1 = factory.getInstance(IMockPool_1);
        Assert.areEqual(p2.value, 2);
    }

    @Test
    public function testInjectDependenciesToPoolObject():Void
    {
        factory.mapToType(IMockPool_1, MockPool_3);
        factory.registerPool(IMockPool_1);
        factory.mapClassNameToValue("Int", 5, "v");
        var p1:IMockPool_1 = factory.getInstance(IMockPool_1);
        Assert.areEqual(p1.value,  6);
    }

    @Test
    public function testGetPoolCapacity():Void
    {
        factory.registerPool(IMockPool_2, 100);

        var capacity:Int = factory.getPoolCapacity(IMockPool_2);

        Assert.areEqual(capacity, 100);
    }

    @Test
    public function testGetPoolTotalInstancesCount():Void
    {
        factory.mapToType(IMockPool_2, MockPool_4);
        factory.registerPool(IMockPool_2, 100);

        for (i in 0...5)
        {
            factory.getInstance(IMockPool_2);
        }

        var count:Int = factory.getPoolInstanceCount(IMockPool_2);

        Assert.areEqual(count, 5);
    }

    @Test
    public function testExtendPool():Void
    {
        factory.registerPool(IMockPool_2, 100);
        factory.increasePoolCapacity(IMockPool_2, 5);

        var capacity:Int = factory.getPoolCapacity(IMockPool_2);

        Assert.areEqual(capacity, 105);
    }

    @Test
    public function testGetInstanceFromPool():Void
    {
        factory.mapToType(IMockPool_2, MockPool_4);
        factory.registerPool(IMockPool_2, 2);

        var instance_1:IMockPool_2 = factory.getInstance(IMockPool_2);
        var instance_2:IMockPool_2 = factory.getInstance(IMockPool_2);

        var instanceFromPool:IMockPool_2;
        instanceFromPool = factory.getInstance(IMockPool_2);
        Assert.areEqual(instanceFromPool, instance_1);

        instanceFromPool = factory.getInstance(IMockPool_2);
        Assert.areEqual(instanceFromPool, instance_2);

        instanceFromPool = factory.getInstance(IMockPool_2);
        Assert.areEqual(instanceFromPool, instance_1);
    }

    @Test
    public function testOfPoolObjectsAreUnique():Void
    {
        factory.mapToType(IMockPool_1, MockPool_1);
        factory.registerPool(IMockPool_1, 2, true);

        var o1:IMockPool_1 = factory.getInstance(IMockPool_1);
        var o2:IMockPool_1 = factory.getInstance(IMockPool_1);

        Assert.areNotEqual(o1, o2);
    }

    @Test
    public function testReturnOnlyNotBusyObjectsFromPool():Void
    {
        factory.mapToType(MockBusyPoolObject, MockBusyPoolObject);
        factory.registerPool(MockBusyPoolObject, 2, true, "isBusy");

        var o1:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        o1.isBusy = true;

        factory.getInstance(MockBusyPoolObject);

        var o2:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        Assert.isFalse(o2.isBusy);
        Assert.areNotEqual(o1, o2);
    }

    @Test
    public function testAllPoolItemAreBusy():Void
    {
        factory.mapToType(MockBusyPoolObject, MockBusyPoolObject);
        factory.registerPool(MockBusyPoolObject, 2, true, "isBusy");

        Assert.isFalse(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        var o1:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        o1.isBusy = true;

        Assert.isFalse(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        var o2:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        o2.isBusy = true;

        Assert.isTrue(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        factory.increasePoolCapacity(MockBusyPoolObject, 1);

        Assert.isFalse(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        var o3:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        o3.isBusy = true;

        Assert.isTrue(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));
    }

    @Test
    public function testAllPoolItemAreBusyIncrease():Void
    {
        factory.mapToType(MockBusyPoolObject, MockBusyPoolObject);
        factory.registerPool(MockBusyPoolObject, 2, true, "isBusy");

        Assert.isFalse(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        var o1:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        o1.isBusy = true;
        var o2:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        o2.isBusy = true;

        Assert.isTrue(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        factory.getInstance(MockBusyPoolObject);
    }

    @Test
    public function testPoolItemsBusyCount():Void
    {
        factory.mapToType(MockBusyPoolObject, MockBusyPoolObject);
        factory.registerPool(MockBusyPoolObject, 3, true, "isBusy");

        var o1:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        o1.isBusy = true;
        var o2:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        o2.isBusy = true;
        var o3:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        o3.isBusy = true;

        Assert.isTrue(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        o2.isBusy = false;

        Assert.areEqual(factory.getPoolBusyInstanceCount(MockBusyPoolObject), 2);

        var o4:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        o4.isBusy = true;

        Assert.areEqual(o4, o2);

        Assert.areEqual(factory.getPoolBusyInstanceCount(MockBusyPoolObject), 3);
        Assert.isTrue(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));
    }

    @Test
    public function testAutoExtendPool():Void
    {
        factory.mapToType(MockBusyPoolObject, MockBusyPoolObject);
        factory.registerPool(MockBusyPoolObject, 1, true, "isBusy");

        var o:MockBusyPoolObject = factory.getInstance(MockBusyPoolObject);
        o.isBusy = true;

        for (i in 0...2)
        {
            o = factory.getInstance(MockBusyPoolObject);
            o.isBusy = true;
        }

        Assert.areEqual(factory.getPoolCapacity(MockBusyPoolObject), 3);
    }

    @Test
    public function testMapToItselfImplementation():Void
    {
        var obj:MockObj_2 = factory.getInstance(MockObj_2);
        Assert.areEqual(obj.prop, "hello");
    }

    @Test
    public function testMapToDefaultImplementation():Void
    {
        var obj:IMockPool_1 = factory.getInstance(IMockPool_1);
    }

    @Test
    public function testDefaultImplementationMissing():Void
    {
        var passed:Bool = false;

        try
        {
            factory.getInstance(IMockLonelyInterface);
        } catch (a:Dynamic)
        {
            passed = true;
        }

        Assert.isTrue(passed);
    }

    @Test
    public function testMapSamePropertyTwice():Void
    {
        factory.mapToType(I_2, Obj);

        var obj:I_2 = factory.getInstance(I_2);
        factory.mapToValue(I_2, obj, "a");
        factory.mapToValue(I_1, obj, "b");

        var container:ObjContainer =  factory.getInstance(ObjContainer);

        Assert.areEqual(container.a, container.b);
    }

    @TestDebug
    public function testMappingViaConfig():Void
    {
        var json:Dynamic =
        {
            "mock.mvc.models.IDefault$def": {
                implementation: "mock.mvc.models.Default",
                newInstance:true
            },
            "mock.mvc.models.ISuperCoolModel": {
                implementation: "mock.mvc.models.SuperCoolModel"
            },
            "Int$coolValue": {
                value:7
            },
            "Bool$myBool": {
                value: false
            },
            "Int": {
                value:5
            },
            "Dynamic$obj": {
                value:{
                    firstName:"nikita",
                    lastName:"dzigurda"
                }
            },
            "Array<String>": {
                value:["botan","sjava"]
            }
        };

        var config:MappingConfigDictionary = new MappingConfigDictionary(json);

        factory.appendMappingConfig(config.map);
        var m:ISuperCoolModel = factory.getInstance(ISuperCoolModel);
        Assert.areEqual(m.getCoolValue, 7);
        Assert.areEqual(m.getMyBool, false);
        Assert.areEqual(m.value, 5);
        Assert.areEqual(m.def.result, 123);
        Assert.areEqual(m.object.firstName, "nikita");
        Assert.areEqual(m.array[1], "sjava");
    }
}

interface I_1 extends IInjectorContainer
{

}

interface I_2 extends I_1
{

}

class Obj implements I_2
{

}

class ObjContainer
{
    @Inject("a")
    public var a:I_2;

    @Inject("b")
    public var b:I_1;
}