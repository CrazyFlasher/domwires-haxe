package com.domwires.core.mvc.hierarchy;

import com.domwires.core.mvc.message.IMessage;
import massive.munit.Assert;
import mock.common.MockMessageType;
import mock.hierarchy.MockHierarchyObject;
class HierarchyObjectContainerTest
{
    private var hoc:IHierarchyObjectContainer;

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
        hoc = new HierarchyObjectContainer();
    }

    @After
    public function tearDown():Void
    {
        if (!hoc.isDisposed)
        {
            hoc.disposeWithAllChildren();
        }
    }

    @Test
    public function testAddMessageListener():Void
    {
        Assert.isFalse(hoc.hasMessageListener(MockMessageType.Hello));

        var eventHandler:IMessage -> Void = m -> {};

        hoc.addMessageListener(MockMessageType.Hello, eventHandler);

        Assert.isTrue(hoc.hasMessageListener(MockMessageType.Hello));
    }

    @Test
    public function testAdd():Void
    {
        Assert.areEqual(hoc.children.length, 0);

        hoc.add(new MockHierarchyObject()).add(new MockHierarchyObject());

        Assert.areEqual(hoc.children.length, 2);
    }

    @Test
    public function testDisposeWithAllChildren():Void
    {
        var ho_1:IHierarchyObject = new MockHierarchyObject();
        var ho_2:IHierarchyObject = new MockHierarchyObject();
        hoc.add(ho_1).add(ho_2);
        hoc.disposeWithAllChildren();

        Assert.isTrue(hoc.isDisposed);
        Assert.isTrue(hoc.isDisposed);
        Assert.isTrue(hoc.isDisposed);

        Assert.isNull(ho_1.parent);
        Assert.isNull(ho_2.parent);
        Assert.isNull(hoc.children);
    }

    @Test
    public function testDispose():Void
    {
        var ho_1:IHierarchyObject = new MockHierarchyObject();
        var ho_2:IHierarchyObject = new MockHierarchyObject();
        hoc.add(ho_1).add(ho_2);
        hoc.dispose();

        Assert.isTrue(hoc.isDisposed);
        Assert.isNull(hoc.children);
        Assert.isFalse(ho_1.isDisposed);
        Assert.isFalse(ho_2.isDisposed);
    }

    /*@Test
		public function testDispatchMessageToChildren():Void
		{
			var ho_1:IHierarchyObject = new MockHierarchyObject();
			var ho_2:IHierarchyObject = new MockHierarchyObject();
			hoc.add(ho_1).add(ho_2);
			var count:int;
			var eventHandler:IMessage -> Void = function(e:IMessageEvent):Void {
				count++;
			};
			ho_1.addMessageListener(MockMessage.Hello, eventHandler);
			ho_2.addMessageListener(MockMessage.Hello, eventHandler);
			hoc.dispatchMessageToChildren(MockMessage.Hello);
			Assert.areEqual(count, 2);
		}*/

    @Test
    public function testRemove():Void
    {
        var ho_1:IHierarchyObject = new MockHierarchyObject();
        var ho_2:IHierarchyObject = new MockHierarchyObject();
        hoc.add(ho_1).add(ho_2);

        Assert.areEqual(ho_1.parent, hoc);
        hoc.remove(ho_1);
        Assert.isNull(ho_1.parent);
        Assert.areEqual(hoc.children.length, 1);
    }

    @Test
    public function testRemoveMessageListener():Void
    {
        var eventHandler:IMessage -> Void = m -> {};

        hoc.addMessageListener(MockMessageType.Hello, eventHandler);
        hoc.removeMessageListener(MockMessageType.Hello, eventHandler);

        Assert.isFalse(hoc.hasMessageListener(MockMessageType.Hello));
    }

    @Test
    public function testRemoveAll():Void
    {
        hoc.add(new MockHierarchyObject()).add(new MockHierarchyObject());
        hoc.removeAll();
        Assert.areEqual(hoc.children.length, 0);
    }

    @Test
    public function testRemoveAllMessageListeners():Void
    {
        var eventHandler:IMessage -> Void = m -> {};

        hoc.addMessageListener(MockMessageType.Hello, eventHandler);
        hoc.addMessageListener(MockMessageType.GoodBye, eventHandler);
        hoc.addMessageListener(MockMessageType.Shalom, eventHandler);

        Assert.isTrue(hoc.hasMessageListener(MockMessageType.Hello));
        Assert.isTrue(hoc.hasMessageListener(MockMessageType.GoodBye));
        Assert.isTrue(hoc.hasMessageListener(MockMessageType.Shalom));

        hoc.removeAllMessageListeners();

        Assert.isFalse(hoc.hasMessageListener(MockMessageType.Hello));
        Assert.isFalse(hoc.hasMessageListener(MockMessageType.GoodBye));
        Assert.isFalse(hoc.hasMessageListener(MockMessageType.Shalom));
    }

    @Test
    public function testChangeParent():Void
    {
        var ho_1:IHierarchyObject = new MockHierarchyObject();
        hoc.add(ho_1);

        Assert.areEqual(ho_1.parent, hoc);
        Assert.areEqual(hoc.children.length, 1);

        var hoc_2:IHierarchyObjectContainer = new HierarchyObjectContainer();
        hoc_2.add(ho_1);

        Assert.areEqual(ho_1.parent, hoc_2);
        Assert.areEqual(hoc.children.length, 0);
    }

    @Test
    public function testAddAt():Void
    {
        var ho_1:IHierarchyObject = new MockHierarchyObject();
        var ho_2:IHierarchyObject = new MockHierarchyObject();
        var ho_3:IHierarchyObject = new MockHierarchyObject();

        hoc.add(ho_1);
        hoc.add(ho_2);
        hoc.add(ho_3);

        Assert.areEqual(hoc.children.indexOf(ho_1), 0);
        Assert.areEqual(hoc.children.indexOf(ho_2), 1);
        Assert.areEqual(hoc.children.indexOf(ho_3), 2);

        Assert.areEqual(ho_1.parent, hoc);
        Assert.areEqual(ho_2.parent, hoc);
        Assert.areEqual(ho_3.parent, hoc);

        hoc.add(ho_3, 0);

        Assert.areEqual(hoc.children.indexOf(ho_3), 0);

        Assert.areEqual(ho_3.parent, hoc);
    }

    @Test
    public function testAddAtParent():Void
    {
        var ho_1:IHierarchyObject = new MockHierarchyObject();
        hoc.add(ho_1, 0);
        Assert.areEqual(ho_1.parent, hoc);
    }

    //Expects error
    /*@Test
    public function testAddAtError():Void
    {
        hoc.add(new MockHierarchyObject(), 5);
    }*/
}
