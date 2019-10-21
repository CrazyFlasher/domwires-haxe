package com.domwires.core.mvc.hierarchy;

import massive.munit.Assert;
import mock.hierarchy.MockHierarchyObject;

class HierarchyObjectTest
{
    private var ho:IHierarchyObject;

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
        ho = new MockHierarchyObject();
    }

    @After
    public function tearDown():Void
    {
        if (!ho.isDisposed)
        {
            ho.dispose();
        }
    }
    
    @Test
    public function testDispose():Void
    {
        addToContainer();

        ho.dispose();

        Assert.isTrue(ho.isDisposed);
        Assert.isNull(ho.parent);
    }

    @Test
    public function testParent():Void
    {
        Assert.isNull(ho.parent);

        var hoc:IHierarchyObjectContainer = addToContainer();

        Assert.areEqual(ho.parent, hoc);
    }

    private function addToContainer():IHierarchyObjectContainer
    {
        var hoc:IHierarchyObjectContainer = new HierarchyObjectContainer();
        hoc.add(ho);

        return hoc;
    }
}
