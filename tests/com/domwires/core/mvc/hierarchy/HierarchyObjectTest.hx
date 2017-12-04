/**
 * Created by Anton Nefjodov on 7.04.2016.
 */
package com.domwires.core.mvc.hierarchy;

import org.flexunit.asserts.AssertEquals;
import org.flexunit.asserts.AssertNull;
import org.flexunit.asserts.AssertTrue;

class HierarchyObjectTest
{
    private var ho : IHierarchyObject;
    
    @Before
    public function setUp() : Void
    {
        ho = new AbstractHierarchyObject();
    }
    
    @After
    public function tearDown() : Void
    {
        if (!ho.isDisposed)
        {
            ho.dispose();
        }
    }
    
    @Test
    public function testDispose() : Void
    {
        addToContainer();
        
        ho.dispose();
        
        Assert.isTrue(ho.isDisposed);
        Assert.isNull(ho.parent);
    }
    
    @Test
    public function testParent() : Void
    {
        Assert.isNull(ho.parent);
        
        var hoc : IHierarchyObjectContainer = addToContainer();
        
        Assert.areEqual(ho.parent, hoc);
    }
    
    private function addToContainer() : IHierarchyObjectContainer
    {
        var hoc : IHierarchyObjectContainer = new HierarchyObjectContainer();
        hoc.add(ho);
        
        return hoc;
    }

    public function new()
    {
    }
}

