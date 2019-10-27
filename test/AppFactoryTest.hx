package ;

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
        var o:IMockType = cast factory.getInstance(IMockType);
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

        var p:IMockPool_1 = cast factory.getInstance(IMockPool_1);
        Assert.areEqual(p.value, 1);

        factory.mapToType(IMockPool_1, MockPool_2);
        factory.registerPool(IMockPool_1);

        var p2:IMockPool_1 = cast factory.getInstance(IMockPool_1);
        Assert.areEqual(p2.value, 2);
    }

    @Test
    public function testInjectDependenciesToPoolObject():Void
    {
        factory.mapToType(IMockPool_1, MockPool_3);
        factory.registerPool(IMockPool_1);
        factory.mapClassNameToValue("Int", 5, "v");
        var p1:IMockPool_1 = cast factory.getInstance(IMockPool_1);
        Assert.areEqual(p1.value,  6);
    }

    @Test
    public function testGetPoolCapacity():Void
    {
        factory.registerPool(IMockPool_2, 100);

        var capacity:Int = cast factory.getPoolCapacity(IMockPool_2);

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

        var instance_1:IMockPool_2 = cast factory.getInstance(IMockPool_2);
        var instance_2:IMockPool_2 = cast factory.getInstance(IMockPool_2);

        var instanceFromPool:IMockPool_2;
        instanceFromPool = cast factory.getInstance(IMockPool_2);
        Assert.areEqual(instanceFromPool, instance_1);

        instanceFromPool = cast factory.getInstance(IMockPool_2);
        Assert.areEqual(instanceFromPool, instance_2);

        instanceFromPool = cast factory.getInstance(IMockPool_2);
        Assert.areEqual(instanceFromPool, instance_1);
    }

    @Test
    public function testOfPoolObjectsAreUnique():Void
    {
        factory.mapToType(IMockPool_1, MockPool_1);
        factory.registerPool(IMockPool_1, 2, true);

        var o1:IMockPool_1 = cast factory.getInstance(IMockPool_1);
        var o2:IMockPool_1 = cast factory.getInstance(IMockPool_1);

        Assert.areNotEqual(o1, o2);
    }

    @Test
    public function testReturnOnlyNotBusyObjectsFromPool():Void
    {
        factory.mapToType(MockBusyPoolObject, MockBusyPoolObject);
        factory.registerPool(MockBusyPoolObject, 2, true, "isBusy");

        var o1:MockBusyPoolObject = cast factory.getInstance(MockBusyPoolObject);
        o1.isBusy = true;

        factory.getInstance(MockBusyPoolObject);

        var o2:MockBusyPoolObject = cast factory.getInstance(MockBusyPoolObject);
        Assert.isFalse(o2.isBusy);
        Assert.areNotEqual(o1, o2);
    }

    @Test
    public function testAllPoolItemAreBusy():Void
    {
        factory.mapToType(MockBusyPoolObject, MockBusyPoolObject);
        factory.registerPool(MockBusyPoolObject, 2, true, "isBusy");

        Assert.isFalse(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        var o1:MockBusyPoolObject = cast factory.getInstance(MockBusyPoolObject);
        o1.isBusy = true;

        Assert.isFalse(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        var o2:MockBusyPoolObject = cast factory.getInstance(MockBusyPoolObject);
        o2.isBusy = true;

        Assert.isTrue(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        factory.increasePoolCapacity(MockBusyPoolObject, 1);

        Assert.isFalse(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        var o3:MockBusyPoolObject = cast factory.getInstance(MockBusyPoolObject);
        o3.isBusy = true;

        Assert.isTrue(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));
    }

    @Test
    public function testAllPoolItemAreBusyIncrease():Void
    {
        factory.mapToType(MockBusyPoolObject, MockBusyPoolObject);
        factory.registerPool(MockBusyPoolObject, 2, true, "isBusy");

        Assert.isFalse(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        var o1:MockBusyPoolObject = cast factory.getInstance(MockBusyPoolObject);
        o1.isBusy = true;
        var o2:MockBusyPoolObject = cast factory.getInstance(MockBusyPoolObject);
        o2.isBusy = true;

        Assert.isTrue(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        factory.getInstance(MockBusyPoolObject);
    }

    @Test
    public function testPoolItemsBusyCount():Void
    {
        factory.mapToType(MockBusyPoolObject, MockBusyPoolObject);
        factory.registerPool(MockBusyPoolObject, 3, true, "isBusy");

        var o1:MockBusyPoolObject = cast factory.getInstance(MockBusyPoolObject);
        o1.isBusy = true;
        var o2:MockBusyPoolObject = cast factory.getInstance(MockBusyPoolObject);
        o2.isBusy = true;
        var o3:MockBusyPoolObject = cast factory.getInstance(MockBusyPoolObject);
        o3.isBusy = true;

        Assert.isTrue(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));

        o2.isBusy = false;

        Assert.areEqual(factory.getPoolBusyInstanceCount(MockBusyPoolObject), 2);

        var o4:MockBusyPoolObject = cast factory.getInstance(MockBusyPoolObject);
        o4.isBusy = true;

        Assert.areEqual(o4, o2);

        Assert.areEqual(factory.getPoolBusyInstanceCount(MockBusyPoolObject), 3);
        Assert.isTrue(factory.getAllPoolItemsAreBusy(MockBusyPoolObject));
    }

    @Test
    public function testMapToItselfImplementation():Void
    {
        var obj:MockObj_2 = cast factory.getInstance(MockObj_2);
        Assert.areEqual(obj.prop, "hello");
    }

    @Test
    public function testMapToDefaultImplementation():Void
    {
        var obj:IMockPool_1 = cast factory.getInstance(IMockPool_1);
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
}