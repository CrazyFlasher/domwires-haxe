package com.domwires.core.common;
import mock.common.MockDisposable;
import massive.munit.Assert;

class DisposableTest
{
	private var d:IDisposable;

	public function new()
	{
	}

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
		d = new MockDisposable();
	}

	@After
	public function tearDown():Void
	{
		if (!d.isDisposed)
		{
			d.dispose();
		}
	}


	@Test
	public function testDispose():Void
	{
		Assert.isFalse(d.isDisposed);
		d.dispose();
		Assert.isTrue(d.isDisposed);
	}
}
