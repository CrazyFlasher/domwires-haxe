/**
 * Created by Anton Nefjodov on 30.01.2016.
 */
package com.domwires.core.common;

import massive.munit.Assert;
class DisposableTest
{
    
    private var d : IDisposable;
    
    @Before
    public function setUp() : Void
    {
        d = new AbstractDisposable();
    }
    
    @After
    public function tearDown() : Void
    {
        if (!d.isDisposed)
        {
            d.dispose();
        }
    }
    
    @Test
    public function testDispose() : Void
    {
        Assert.isFalse(d.isDisposed);
        d.dispose();
        Assert.isTrue(d.isDisposed);
    }

    public function new()
    {
    }
}

