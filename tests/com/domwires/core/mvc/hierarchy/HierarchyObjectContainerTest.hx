/**
 * Created by Anton Nefjodov on 7.04.2016.
 */
package com.domwires.core.mvc.hierarchy;

import haxe.Constraints.Function;
import com.domwires.core.mvc.message.IMessage;
import org.flexunit.asserts.AssertEquals;
import org.flexunit.asserts.AssertFalse;
import org.flexunit.asserts.AssertNull;
import org.flexunit.asserts.AssertTrue;
import testObject.MyCoolEnum;

class HierarchyObjectContainerTest
{
    
    private var hoc : IHierarchyObjectContainer;
    
    @Before
    public function setUp() : Void
    {
        hoc = new HierarchyObjectContainer();
    }
    
    @After
    public function tearDown() : Void
    {
        if (!hoc.isDisposed)
        {
            hoc.disposeWithAllChildren();
        }
    }
    
    @Test
    public function testAddMessageListener() : Void
    {
        Assert.isFalse(hoc.hasMessageListener(MyCoolEnum.PREVED));
        
        var eventHandler : Function = function(e : IMessage) : Void
        {
        }
        
        hoc.addMessageListener(MyCoolEnum.PREVED, eventHandler);
        
        Assert.isTrue(hoc.hasMessageListener(MyCoolEnum.PREVED));
    }
    
    @Test
    public function testAdd() : Void
    {
        Assert.areEqual(hoc.children.length, 0);
        
        hoc.add(new AbstractHierarchyObject()).add(new AbstractHierarchyObject());
        
        Assert.areEqual(hoc.children.length, 2);
    }
    
    @Test
    public function testDisposeWithAllChildren() : Void
    {
        var ho_1 : IHierarchyObject = new AbstractHierarchyObject();
        var ho_2 : IHierarchyObject = new AbstractHierarchyObject();
        hoc.add(ho_1).add(ho_2);
        hoc.disposeWithAllChildren();
        
        Assert.isTrue(hoc.isDisposed, ho_1.isDisposed, ho_2.isDisposed);
        Assert.isNull(ho_1.parent, ho_2.parent, hoc.children);
    }
    
    @Test
    public function testDispose() : Void
    {
        var ho_1 : IHierarchyObject = new AbstractHierarchyObject();
        var ho_2 : IHierarchyObject = new AbstractHierarchyObject();
        hoc.add(ho_1).add(ho_2);
        hoc.dispose();
        
        Assert.isTrue(hoc.isDisposed);
        Assert.isNull(hoc.children);
        Assert.isFalse(ho_2.isDisposed);  // null
    }
    
    /*[Test]
		public function testDispatchMessageToChildren():void
		{
			var ho_1:IHierarchyObject = new AbstractHierarchyObject();
			var ho_2:IHierarchyObject = new AbstractHierarchyObject();
			hoc.add(ho_1).add(ho_2);

			var count:int;
			var eventHandler:Function = function(e:IMessageEvent):void {
				count++;
			};

			ho_1.addMessageListener(MyCoolEnum.PREVED, eventHandler);
			ho_2.addMessageListener(MyCoolEnum.PREVED, eventHandler);

			hoc.dispatchMessageToChildren(MyCoolEnum.PREVED);

			assertEquals(count, 2);
		}*/
    
    @Test
    public function testRemove() : Void
    {
        var ho_1 : IHierarchyObject = new AbstractHierarchyObject();
        var ho_2 : IHierarchyObject = new AbstractHierarchyObject();
        hoc.add(ho_1).add(ho_2);
        
        Assert.areEqual(ho_1.parent, hoc);
        hoc.remove(ho_1);
        Assert.isNull(ho_1.parent);
        Assert.areEqual(hoc.children.length, 1);
    }
    
    @Test
    public function testRemoveMessageListener() : Void
    {
        var eventHandler : Function = function(e : IMessage) : Void
        {
        }
        
        hoc.addMessageListener(MyCoolEnum.PREVED, eventHandler);
        hoc.removeMessageListener(MyCoolEnum.PREVED, eventHandler);
        
        Assert.isFalse(hoc.hasMessageListener(MyCoolEnum.PREVED));
    }
    
    @Test
    public function testRemoveAll() : Void
    {
        hoc.add(new AbstractHierarchyObject()).add(new AbstractHierarchyObject());
        hoc.removeAll();
        Assert.areEqual(hoc.children.length, 0);
    }
    
    @Test
    public function testRemoveAllMessageListeners() : Void
    {
        var eventHandler : Function = function(e : IMessage) : Void
        {
        }
        
        hoc.addMessageListener(MyCoolEnum.PREVED, eventHandler);
        hoc.addMessageListener(MyCoolEnum.BOGA, eventHandler);
        hoc.addMessageListener(MyCoolEnum.SHALOM, eventHandler);
        
        Assert.isTrue(
                hoc.hasMessageListener(MyCoolEnum.PREVED), 
                hoc.hasMessageListener(MyCoolEnum.BOGA), 
                hoc.hasMessageListener(MyCoolEnum.SHALOM)
        );
        
        hoc.removeAllMessageListeners();
        
        Assert.isFalse(
                hoc.hasMessageListener(MyCoolEnum.PREVED), 
                hoc.hasMessageListener(MyCoolEnum.BOGA), 
                hoc.hasMessageListener(MyCoolEnum.SHALOM)
        );
    }
    
    @Test
    public function testChangeParent() : Void
    {
        var ho_1 : IHierarchyObject = new AbstractHierarchyObject();
        hoc.add(ho_1);
        
        Assert.areEqual(ho_1.parent, hoc);
        Assert.areEqual(hoc.children.length, 1);
        
        var hoc_2 : IHierarchyObjectContainer = new HierarchyObjectContainer();
        hoc_2.add(ho_1);
        
        Assert.areEqual(ho_1.parent, hoc_2);
        Assert.areEqual(hoc.children.length, 0);
    }
    
    @Test
    public function testAddAt() : Void
    {
        var ho_1 : IHierarchyObject = new AbstractHierarchyObject();
        var ho_2 : IHierarchyObject = new AbstractHierarchyObject();
        var ho_3 : IHierarchyObject = new AbstractHierarchyObject();
        
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
    public function testAddAtParent() : Void
    {
        var ho_1 : IHierarchyObject = new AbstractHierarchyObject();
        hoc.add(ho_1, 0);
        Assert.isTrue(hoc);  // null
    }
    
    @Test
    //expects="Error"
    public function testAddAtError() : Void
    {
        hoc.add(new AbstractHierarchyObject(), 5);
    }

    public function new()
    {
    }
}

