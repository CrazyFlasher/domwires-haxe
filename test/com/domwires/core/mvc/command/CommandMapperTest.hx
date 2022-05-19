package com.domwires.core.mvc.command;

import mock.mvc.commands.MockCommand_19;
import mock.mvc.models.MockModel_2;
import mock.mvc.commands.MockCommand_18;
import com.domwires.core.factory.AppFactory;
import com.domwires.core.factory.IAppFactory;
import massive.munit.Assert;
import mock.common.MockMessageType;
import mock.mvc.commands.guards.MockAllowGuards;
import mock.mvc.commands.guards.MockAllowGuards_2;
import mock.mvc.commands.guards.MockNotAllowGuards;
import mock.mvc.commands.MockCommand_17;
import mock.mvc.commands.MockCommand_1;
import mock.mvc.commands.MockCommand_2;
import mock.mvc.commands.MockCommand_3;
import mock.mvc.commands.MockCommand_4;
import mock.mvc.commands.MockCommand_5;
import mock.mvc.commands.MockCommand_7;
import mock.mvc.commands.MockCommand_8;
import mock.mvc.message.MockMessage;
import mock.obj.MockObj_1;
import mock.obj.MockVo;
import mock.obj.MockVo_2;

class CommandMapperTest
{
    private var commandMapper:ICommandMapper;

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
        factory.mapToValue(IAppFactory, factory);

        commandMapper = factory.instantiateUnmapped(CommandMapper);
    }

    @After
    public function tearDown():Void
    {
        factory.dispose();
        commandMapper.dispose();
    }

    @Test
    public function testUnmap():Void
    {
        commandMapper.map(MockMessageType.GoodBye, MockCommand_1).addGuards(MockAllowGuards);
        commandMapper.unmap(MockMessageType.GoodBye, MockCommand_1);
        Assert.isFalse(commandMapper.hasMapping(MockMessageType.GoodBye));

        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);

        commandMapper.tryToExecuteCommand(new MockMessage(MockMessageType.GoodBye));
        Assert.areEqual(m.d, 0);
    }

    @Test
    public function testClear():Void
    {
        commandMapper.map(MockMessageType.GoodBye, MockCommand_1);
        commandMapper.map(MockMessageType.Hello, MockCommand_1);
        commandMapper.map(Shalom, MockCommand_1);

        commandMapper.clear();

        Assert.isFalse(commandMapper.hasMapping(MockMessageType.GoodBye));
        Assert.isFalse(commandMapper.hasMapping(MockMessageType.Hello));
        Assert.isFalse(commandMapper.hasMapping(Shalom));
    }

    @Test
    public function testDispose():Void
    {
        commandMapper.map(MockMessageType.GoodBye, MockCommand_1);
        commandMapper.map(MockMessageType.Hello, MockCommand_1);
        commandMapper.map(Shalom, MockCommand_1);

        commandMapper.clear();

        Assert.isFalse(commandMapper.hasMapping(MockMessageType.GoodBye));
        Assert.isFalse(commandMapper.hasMapping(MockMessageType.Hello));
        Assert.isFalse(commandMapper.hasMapping(Shalom));
    }

    @Test
    public function testUnmapAll():Void
    {
        commandMapper.map(MockMessageType.GoodBye, MockCommand_1);
        commandMapper.map(MockMessageType.Hello, MockCommand_1);
        commandMapper.map(Shalom, MockCommand_1);
        commandMapper.unmapAll(MockMessageType.GoodBye);
        commandMapper.unmapAll(MockMessageType.Hello);
        commandMapper.unmapAll(Shalom);

        Assert.isFalse(commandMapper.hasMapping(MockMessageType.GoodBye));
        Assert.isFalse(commandMapper.hasMapping(MockMessageType.Hello));
        Assert.isFalse(commandMapper.hasMapping(Shalom));
    }

    @Test
    public function testMap():Void
    {
        Assert.isFalse(commandMapper.hasMapping(MockMessageType.GoodBye));
        commandMapper.map(MockMessageType.GoodBye, MockCommand_1);
        Assert.isTrue(commandMapper.hasMapping(MockMessageType.GoodBye));
    }

    @Test
    public function testTryToExecuteCommand():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);

        commandMapper.map(MockMessageType.Hello, MockCommand_1);

        Assert.areEqual(m.d, 0);
        commandMapper.tryToExecuteCommand(new MockMessage(MockMessageType.Hello));
        Assert.areEqual(m.d, 7);
    }

    @Test
    public function testManyEvents1Command():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);

        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_1);
        commandMapper.map(cast MockMessageType.Hello, MockCommand_1);
        commandMapper.map(cast MockMessageType.Shalom, MockCommand_1);
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye));
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.Hello));
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.Shalom));
        Assert.areEqual(m.d, 21);

        commandMapper.unmap(cast MockMessageType.Shalom, MockCommand_1);
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye));
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.Hello));
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.Shalom));
        Assert.areEqual(m.d, 35);
    }

    @Test
    public function testRemapModel():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);

        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_1);
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye));

        Assert.areEqual(m.d, 7);

        factory.unmap(MockObj_1);

        var m2:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m2);

        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye));

        Assert.areEqual(m2.d, 7);
    }

    @Test
    public function testInjectMessageData():Void
    {
        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_2);

        var vo:MockVo = new MockVo();
        var itemId:String = "lol";

        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye, {vo:vo, itemId:itemId, e:MockMessageType.Hello,
            __e: "EnumValue"}));

        Assert.areEqual(vo.age, 11);
        Assert.areEqual(vo.name, "hi");
        Assert.areEqual(vo.str, "lol");
    }

    @Test
    public function testMapOnce():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_1, null, true);
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye));
        Assert.isFalse(commandMapper.hasMapping(cast MockMessageType.GoodBye));
    }

    @Test
    public function testMapWithData():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_3, {olo: 5, __olo: "Int"});
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye));
        Assert.areEqual(m.d, 5);
    }

    @Test
    public function testMapWithData2():Void
    {
        commandMapper.setMergeMessageDataAndMappingData(true);

        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_3, {olo: 5, __olo: "Int"});
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye, {a: 1}));
        Assert.areEqual(m.d, 5);
    }

    @Test
    public function testMessageDataOverridesMappedData():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_3, {olo: 5, __olo: "Int"});
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye, {olo: 4, __olo: "Int"}));
        Assert.areEqual(m.d, 4);
    }

    @Test
    public function testCoolGuards():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_3, {olo: 5, __olo: "Int"}).addGuards(MockAllowGuards);
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye, {olo: 4, __olo: "Int"}));
        Assert.areEqual(m.d, 4);
    }

    @Test
    public function testCoolOppositeGuards():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_3, {olo: 5, __olo: "Int"}).addGuardsNot(MockNotAllowGuards);
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye, {olo: 4, __olo: "Int"}));
        Assert.areEqual(m.d, 4);
    }

    @Test
    public function testNotCoolGuards():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_3, {olo: 5, __olo: "Int"}).addGuards(MockNotAllowGuards);
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye, {olo: 4, __olo: "Int"}));
        Assert.areEqual(m.d, 0);
    }

    @Test
    public function testNormalAndOppositeGuards():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);

        commandMapper.map1(cast MockMessageType.GoodBye, [MockCommand_3], {olo: 5, __olo: "Int"})
            .addGuards(MockAllowGuards)
            .addGuards(MockAllowGuards)
            .addGuardsNot(MockNotAllowGuards)
            .addGuardsNot(MockAllowGuards_2);

        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye));
        Assert.areEqual(m.d, 0);
    }

    @Test
    public function testNotCoolOppositeGuards():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_3, {olo: 5, __olo: "Int"}).addGuardsNot(MockAllowGuards);
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye, {olo: 4, __olo: "Int"}));
        Assert.areEqual(m.d, 0);
    }

    @Test
    public function testInjectMessageDataToGuards():Void
    {
        commandMapper.map(cast MockMessageType.GoodBye, AbstractCommand).addGuards(MockAllowGuards);
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye, {olo: 4, __olo: "Int"}));
    }

    @Test
    public function testMapWithDataUnmaps():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        commandMapper.executeCommand(MockCommand_4, {olo: "lol"});
        Assert.areEqual(m.s, "lol");
        commandMapper.executeCommand(MockCommand_4);
        Assert.isNull(m.s);
    }

    /*@Test
    public function testExecuteWithVoAsData():Void
    {
        //Expecting no errors
        var vo:MyVo = new MyVo();
        vo.olo = "test";
        commandMapper.executeCommand(VoMockCommand_1, vo);
    }*/

    @Test
    public function testExecuteWithVoGettersAsData():Void
    {
        //Expecting no errors
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        var vo:MockVo_2 = new MockVo_2();
        vo.olo = "test";
        commandMapper.executeCommand(MockCommand_5, vo);
        Assert.areEqual(m.s, "test");
    }

    @Test
    public function testStopOnExecute():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        factory.mapToValue(String, "test", "olo");
        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_4, null, false, true);
        commandMapper.map(cast MockMessageType.GoodBye, MockCommand_1);
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye));
        Assert.areEqual(m.d, 0);
    }

    @Test
    public function testStopOnExecuteWithBatchMapping():Void
    {
        var m:MockObj_1 = factory.instantiateUnmapped(MockObj_1);
        factory.mapToValue(MockObj_1, m);
        factory.mapToValue(String, "test", "olo");
        commandMapper.map1(cast MockMessageType.GoodBye, [MockCommand_4, MockCommand_1], null, false, true);
        commandMapper.tryToExecuteCommand(new MockMessage(cast MockMessageType.GoodBye));
        Assert.areEqual(m.d, 7);
    }

    //Expecting no errors
    /*@Test
    public function testKeepMappingValue():Void
    {
        var a:Int = 1;
        factory.mapToValue(Int, a, "a");

        commandMapper.keepDataMappingAfterExecution(int, "a");

        var mappingData:Dynamic = {a: 1};
        commandMapper.executeCommand(MockCommand_9, mappingData);
        commandMapper.executeCommand(MockCommand_9);
    }*/

    //Expecting no errors
    @Test
    public function testMapVector():Void
    {
        var v:Array<String> = [];
    
        var mappingData:Dynamic = {v: v, __v: "Array<String>"};
        commandMapper.executeCommand(MockCommand_8, mappingData);
    }

    //Expecting no errors
    @Test
    public function testExecuteDefaultValuesCommand():Void
    {
//        commandMapper.executeCommand(MockCommand_6); //TODO: need to be fixed
        commandMapper.executeCommand(MockCommand_7, {bool: false, __bool:"Bool", iint: 2, __iint: "Int"});
    }

    @Test
    public function testMapEnumValue():Void
    {
        var e:EnumValue = MockMessageType.Hello;

        factory.mapClassNameToValue("EnumValue", e, "e");
        Assert.areEqual(e, factory.getInstanceWithClassName("EnumValue", "e"));

        commandMapper.executeCommand(MockCommand_17, {e: MockMessageType.Hello, __e:"EnumValue"});
    }

    @Test
    public function testMapEnumValueWithoutTypeSpecified():Void
    {
        var e:EnumValue = MockMessageType.Hello;

        commandMapper.executeCommand(MockCommand_18, {
            i: 7,
            f: 5.5,
            s: "Anton",
            b: true,
            e: MockMessageType.Hello
        });
    }

    @Test
    public function testCommandIsSingleton1():Void
    {
        var model:MockModel_2 = factory.getInstance(MockModel_2);
        factory.mapToValue(MockModel_2, model);

        commandMapper.executeCommand(MockCommand_19);
        commandMapper.executeCommand(MockCommand_19);
        commandMapper.executeCommand(MockCommand_19);

        Assert.areEqual(model.testVar, 3);
    }

    @Test
    public function testCommandIsSingleton2():Void
    {
        factory.mapToType(MockCommand_19, mock.mvc.commands.ex.MockCommand_19);

        var model:MockModel_2 = factory.getInstance(MockModel_2);
        factory.mapToValue(MockModel_2, model);

        commandMapper.executeCommand(MockCommand_19);
        commandMapper.executeCommand(MockCommand_19);
        commandMapper.executeCommand(MockCommand_19);

        Assert.areEqual(model.testVar, 3);
    }

    @Test
    public function testCommandIsSingleton3():Void
    {
        factory.mapToType(MockCommand_19, mock.mvc.commands.ex.MockCommand_19);

        var model:MockModel_2 = factory.getInstance(MockModel_2);
        factory.mapToValue(MockModel_2, model);

        commandMapper.executeCommand(MockCommand_19);

        Assert.areEqual(model.testVar, 1);
    }
}