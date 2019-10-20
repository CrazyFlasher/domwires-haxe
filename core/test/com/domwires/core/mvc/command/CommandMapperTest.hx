package com.domwires.core.mvc.command;

import com.domwires.core.factory.AppFactory;
import com.domwires.core.factory.IAppFactory;

class CommandMapperTest
{
    private var commandMapper:ICommandMapper;

    private var factory:IAppFactory;

    @BeforeClass
    public function beforeClass():Void
    {
        factory = new AppFactory();
        factory.mapToValue(IAppFactory, factory);

        commandMapper = cast factory.getInstance(ICommandMapper);
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
    public function testDispose():Void
    {
    }
}
