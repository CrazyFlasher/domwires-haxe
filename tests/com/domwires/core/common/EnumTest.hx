/**
 * Created by Anton Nefjodov on 2.04.2016.
 */
package com.domwires.core.common;

import massive.munit.Assert;
import testObject.MyCoolEnum;

class EnumTest
{
    @Before
    public function setUp() : Void
    {
    }
    
    @After
    public function tearDown() : Void
    {
    }
    
    @Test
    public function testName() : Void
    {
        Assert.areEqual(MyCoolEnum.PREVED.name, "preved");
    }

    public function new()
    {
    }
}
