/**
 * Created by Anton Nefjodov on 30.05.2016.
 */
package com.domwires.core.mvc.context;

import com.domwires.core.factory.AppFactory;
import com.domwires.core.factory.IAppFactory;
import com.domwires.core.mvc.command.AbstractCommand;
import com.domwires.core.mvc.command.CommandMapper;
import com.domwires.core.mvc.command.ICommandMapper;
import org.flexunit.asserts.AssertEquals;
import org.flexunit.asserts.AssertFalse;
import org.flexunit.asserts.AssertNull;
import org.flexunit.asserts.AssertTrue;
import testObject.MyCoolEnum;
import testObject.TestObj1;
import testObject.TestVo;
import com.domwires.core.common.Enum;

import com.domwires.core.mvc.command.IGuards;
import com.domwires.core.mvc.message.IMessage;



class CommandMapperTest
{
    private var commandMapper : ICommandMapper;
    
    private var factory : IAppFactory;
    
    @Before
    public function setUp() : Void
    {
        factory = new AppFactory();
        factory.mapToValue(IAppFactory, factory);
        
        commandMapper = factory.getInstance(CommandMapper);
    }
    
    @After
    public function tearDown() : Void
    {
        factory.dispose();
        commandMapper.dispose();
    }
    
    @Test
    public function testUnmap() : Void
    {
        commandMapper.map(MyCoolEnum.BOGA, TestCommand);
        commandMapper.unmap(MyCoolEnum.BOGA, TestCommand);
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.BOGA));
    }
    
    @Test
    public function testClear() : Void
    {
        commandMapper.map(MyCoolEnum.BOGA, TestCommand);
        commandMapper.map(MyCoolEnum.PREVED, TestCommand);
        commandMapper.map(MyCoolEnum.SHALOM, TestCommand);
        
        commandMapper.clear();
        
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.BOGA));
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.PREVED));
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.SHALOM));
    }
    
    @Test
    public function testDispose() : Void
    {
        commandMapper.map(MyCoolEnum.BOGA, TestCommand);
        commandMapper.map(MyCoolEnum.PREVED, TestCommand);
        commandMapper.map(MyCoolEnum.SHALOM, TestCommand);
        
        commandMapper.clear();
        
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.BOGA));
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.PREVED));
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.SHALOM));
    }
    
    @Test
    public function testUnmapAll() : Void
    {
        commandMapper.map(MyCoolEnum.BOGA, TestCommand);
        commandMapper.map(MyCoolEnum.PREVED, TestCommand);
        commandMapper.map(MyCoolEnum.SHALOM, TestCommand);
        commandMapper.unmapAll(MyCoolEnum.BOGA);
        commandMapper.unmapAll(MyCoolEnum.PREVED);
        commandMapper.unmapAll(MyCoolEnum.SHALOM);
        
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.BOGA));
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.PREVED));
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.SHALOM));
    }
    
    @Test
    public function testMap() : Void
    {
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.BOGA));
        commandMapper.map(MyCoolEnum.BOGA, TestCommand);
        Assert.isTrue(commandMapper.hasMapping(MyCoolEnum.BOGA));
    }
    
    @Test
    public function testTryToExecuteCommand() : Void
    {
        var m : TestObj1 = factory.getSingleton(TestObj1);
        factory.mapToValue(TestObj1, m);
        
        commandMapper.map(MyCoolEnum.PREVED, TestCommand);
        
        Assert.areEqual(m.d, 0);
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.PREVED));
        Assert.areEqual(m.d, 7);
    }
    
    @Test
    public function testManyEvents1Command() : Void
    {
        var m : TestObj1 = factory.getSingleton(TestObj1);
        factory.mapToValue(TestObj1, m);
        
        commandMapper.map(MyCoolEnum.BOGA, TestCommand);
        commandMapper.map(MyCoolEnum.PREVED, TestCommand);
        commandMapper.map(MyCoolEnum.SHALOM, TestCommand);
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.BOGA));
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.PREVED));
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.SHALOM));
        Assert.areEqual(m.d, 21);
        
        commandMapper.unmap(MyCoolEnum.SHALOM, TestCommand);
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.BOGA));
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.PREVED));
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.SHALOM));
        Assert.areEqual(m.d, 35);
    }
    
    @Test
    public function testRemapModel() : Void
    {
        var m : TestObj1 = factory.getInstance(TestObj1);
        factory.mapToValue(TestObj1, m);
        
        commandMapper.map(MyCoolEnum.BOGA, TestCommand);
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.BOGA));
        
        Assert.areEqual(m.d, 7);
        
        factory.unmapValue(TestObj1);
        
        var m2 : TestObj1 = factory.getInstance(TestObj1);
        factory.mapToValue(TestObj1, m2);
        
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.BOGA));
        
        Assert.areEqual(m2.d, 7);
    }
    
    @Test
    public function testInjectMessageData() : Void
    {
        commandMapper.map(MyCoolEnum.BOGA, TestCommand2);
        
        var vo : TestVo = new TestVo();
        var itemId : String = "puk";
        
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.BOGA, {
                    vo : vo,
                    itemId : itemId
                }));
        
        Assert.areEqual(vo.age, 11);
        Assert.areEqual(vo.name, "Izja");
        Assert.areEqual(vo.str, "puk");
    }
    
    @Test
    public function testMapOnce() : Void
    {
        var m : TestObj1 = factory.getInstance(TestObj1);
        factory.mapToValue(TestObj1, m);
        commandMapper.map(MyCoolEnum.BOGA, TestCommand, null, true);
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.BOGA));
        Assert.isFalse(commandMapper.hasMapping(MyCoolEnum.BOGA));
    }
    
    @Test
    public function testMapWithData() : Void
    {
        var m : TestObj1 = factory.getInstance(TestObj1);
        factory.mapToValue(TestObj1, m);
        commandMapper.map(MyCoolEnum.BOGA, TestCommand3, {
                    olo : 5
                });
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.BOGA));
        Assert.areEqual(m.d, 5);
    }
    
    @Test
    public function testMessageDataOverridesMappedData() : Void
    {
        var m : TestObj1 = factory.getInstance(TestObj1);
        factory.mapToValue(TestObj1, m);
        commandMapper.map(MyCoolEnum.BOGA, TestCommand3, {
                    olo : 5
                });
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.BOGA, {
                    olo : 4
                }));
        Assert.areEqual(m.d, 4);
    }
    
    @Test
    public function testCoolGuards() : Void
    {
        var m : TestObj1 = factory.getInstance(TestObj1);
        factory.mapToValue(TestObj1, m);
        commandMapper.map(MyCoolEnum.BOGA, TestCommand3, {
                            olo : 5
                        }).addGuards(CoolGuards);
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.BOGA, {
                    olo : 4
                }));
        Assert.areEqual(m.d, 4);
    }
    
    @Test
    public function testNotCoolGuards() : Void
    {
        var m : TestObj1 = factory.getInstance(TestObj1);
        factory.mapToValue(TestObj1, m);
        commandMapper.map(MyCoolEnum.BOGA, TestCommand3, {
                            olo : 5
                        }).addGuards(NotCoolGuards);
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.BOGA, {
                    olo : 4
                }));
        Assert.areEqual(m.d, 0);
    }
    
    @Test
    public function testInjectMessageDataToGuards() : Void
    {
        commandMapper.map(MyCoolEnum.BOGA, AbstractCommand).addGuards(NiceGuards);
        commandMapper.tryToExecuteCommand(new MyMessage(MyCoolEnum.BOGA, {
                    olo : 4
                }));
    }
    
    @Test
    public function testMapWithDataUnmaps() : Void
    {
        var m : TestObj1 = factory.getInstance(TestObj1);
        factory.mapToValue(TestObj1, m);
        commandMapper.executeCommand(TestCommand4, {
                    olo : "puk"
                });
        Assert.areEqual(m.s, "puk");
        commandMapper.executeCommand(TestCommand4);
        Assert.isNull(m.s);
    }

    public function new()
    {
    }
}




////////////////////////////////////
class NiceGuards implements IGuards
{
    public var allows(get, never) : Bool;

    @:meta(Autowired(name="olo"))

    public var olo : Int;
    
    private function get_allows() : Bool
    {
        return this;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
    }
}

////////////////////////////////////
class NotCoolGuards implements IGuards
{
    public var allows(get, never) : Bool;

    private function get_allows() : Bool
    {
        return false;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
    }
}
class CoolGuards implements IGuards
{
    public var allows(get, never) : Bool;

    private function get_allows() : Bool
    {
        return true;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
    }
}
/////////////////////////////////////
class TestCommand4 extends AbstractCommand
{
    @:meta(Autowired())

    public var obj : TestObj1;
    
    @:meta(Autowired(name="olo",optional="true"))

    public var olo : String;
    
    override public function execute() : Void
    {
        obj.s = olo;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}

class TestCommand3 extends AbstractCommand
{
    @:meta(Autowired())

    public var obj : TestObj1;
    
    @:meta(Autowired(name="olo"))

    public var olo : Int;
    
    override public function execute() : Void
    {
        obj.d += olo;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}

class TestCommand extends AbstractCommand
{
    @:meta(Autowired())

    public var obj : TestObj1;
    
    override public function execute() : Void
    {
        obj.d += 7;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}

class TestCommand2 extends AbstractCommand
{
    @:meta(Autowired(name="itemId"))

    public var itemId : String;
    
    @:meta(Autowired(name="vo"))

    public var vo : TestVo;
    
    override public function execute() : Void
    {
        vo.age = 11;
        vo.name = "Izja";
        vo.str = itemId;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}

class MyMessage implements IMessage
{
    public var type(get, never) : Enum;
    public var data(get, never) : Dynamic;
    public var bubbles(get, never) : Bool;
    public var target(get, never) : Dynamic;
    public var currentTarget(get, never) : Dynamic;
    public var previousTarget(get, never) : Dynamic;

    @:allow(com.domwires.core.mvc.context)
    private var _type : Enum;
    @:allow(com.domwires.core.mvc.context)
    private var _data : Dynamic;
    @:allow(com.domwires.core.mvc.context)
    private var _bubbles : Bool;
    @:allow(com.domwires.core.mvc.context)
    private var _target : Dynamic;
    @:allow(com.domwires.core.mvc.context)
    private var _previousTarget : Dynamic;
    
    private var _currentTarget : Dynamic;
    
    @:allow(com.domwires.core.mvc.context)
    private function new(type : Enum, data : Dynamic = null, bubbles : Bool = true)
    {
        _type = type;
        _data = data;
        _bubbles = bubbles;
    }
    
    @:allow(com.domwires.core.mvc.context)
    private function setCurrentTarget(value : Dynamic) : Dynamic
    {
        _previousTarget = _currentTarget;
        
        _currentTarget = value;
        
        return _currentTarget;
    }
    
    private function get_type() : Enum
    {
        return _type;
    }
    
    private function get_data() : Dynamic
    {
        return _data;
    }
    
    private function get_bubbles() : Bool
    {
        return _bubbles;
    }
    
    private function get_target() : Dynamic
    {
        return _target;
    }
    
    private function get_currentTarget() : Dynamic
    {
        return _currentTarget;
    }
    
    private function get_previousTarget() : Dynamic
    {
        return _previousTarget;
    }
}