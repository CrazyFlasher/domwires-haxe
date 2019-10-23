package com.domwires.core.utils;

import massive.munit.Assert;
class ArrayUtilsTest
{
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
    }

    @After
    public function tearDown():Void
    {
    }

    @Test
    public function testIsLast():Void
    {
        var arr:Array<Int> = [1, 2, 3, 4, 4];

        Assert.isTrue(ArrayUtils.isLast(arr, 4));
        Assert.isFalse(ArrayUtils.isLast(arr, 1));
        Assert.isFalse(ArrayUtils.isLast(arr, 0));
    }

    @Test
    public function testClear():Void
    {
        var arr:Array<Int> = [1, 2, 3, 4, 4];
        ArrayUtils.clear(arr);

        Assert.areEqual(arr.length, 0);
    }
}
