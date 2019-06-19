/**
 * Created by CrazyFlasher on 3.10.2016.
 */
package com.domwires.core.mvc.context;

import com.domwires.core.factory.AppFactory;
import com.domwires.core.factory.IAppFactory;
import com.domwires.core.mvc.context.config.ContextConfigVoBuilder;
import com.domwires.core.mvc.model.AbstractModel;
import com.domwires.core.mvc.view.AbstractView;
import org.flexunit.asserts.AssertEquals;
import org.flexunit.asserts.AssertTrue;
import com.domwires.core.mvc.command.AbstractCommand;
import com.domwires.core.mvc.context.AbstractContext;

import com.domwires.core.mvc.message.IMessage;


import testObject.MyCoolEnum;

class AbstractContextTest
{
    private var f : IAppFactory;
    
    private var c : IContext;
    
    @Before
    public function setUp() : Void
    {
        f = new AppFactory();
        f.mapToType(IContext, AbstractContext);
        f.mapToValue(IAppFactory, f);
        
        var cb : ContextConfigVoBuilder = new ContextConfigVoBuilder();
        cb.forwardMessageFromViewsToModels = true;
        
        c = f.getInstance(IContext, cb.build());
        c.addModel(new AbstractModel());
        c.addView(new AbstractView());
    }
    
    @After
    public function tearDown() : Void
    {
        if (!c.isDisposed)
        {
            c.disposeWithAllChildren();
        }
    }
    
    @Test
    public function testDisposeWithAllChildren() : Void
    {
        c.disposeWithAllChildren();
        
        Assert.isTrue(c.isDisposed);
    }
    
    @Test
    public function testExecuteCommandFromBubbledMessage() : Void
    {
        var c1 : TestContext1 = f.getInstance(TestContext1);
        var c2 : TestContext2 = f.getInstance(TestContext2);
        c.addModel(c1);
        c.addModel(c2);
        
        c2.ready();
        
        Assert.areEqual(c1.getTestModel().testVar, 1);
    }
    
    @Test
    public function testBubbledMessageNotRedirectedToContextItCameFrom() : Void
    {
        var c1 : TestContext1 = f.getInstance(TestContext1);
        var c2 : TestContext2 = f.getInstance(TestContext2);
        c.addModel(c1);
        c.addModel(c2);
        
        c2.ready();
        
        Assert.areEqual(c2.getTestModel().testVar, 1);
    }
    
    @Test
    public function testReceivingExternalEvents() : Void
    {
        var c : ParentContext = f.getInstance(ParentContext);
        Assert.areEqual(c.getTestModel().testVar, 1);
    }
    
    @Test
    public function testViewMessageBubbledOnceForChildContext() : Void
    {
        TestView2.VAL = 0;
        var c : ParentContext2 = f.getInstance(ParentContext2);
        Assert.areEqual(c.getModel().testVar, 1);
        Assert.areEqual(TestView2.VAL, 1);
    }

    public function new()
    {
    }
}




/////////////////////////
class ParentContext2 extends AbstractContext
{
    private var v : TestView0;
    private var m : TestModel4;
    
    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        var cb : ContextConfigVoBuilder = new ContextConfigVoBuilder();
        cb.forwardMessageFromViewsToModels = true;
        
        super(cb.build());
    }
    
    public function getModel() : TestModel4
    {
        return m;
    }
    
    @:meta(PostConstruct())

    override public function init() : Void
    {
        super.init();
        
        v = factory.getInstance(TestView0);
        addView(v);
        
        m = factory.getInstance(TestModel4);
        factory.mapToValue(TestModel4, m);
        addModel(m);
        
        addModel(factory.getInstance(ChildContext2));
        
        map(MyCoolEnum.PREVED, TestCommand4);
        
        v.dispatch();
    }
}
class ChildContext2 extends AbstractContext
{
    @:meta(PostConstruct())

    override public function init() : Void
    {
        super.init();
        
        addView(factory.getInstance(TestView2));
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}
class TestView0 extends AbstractView
{
    @:meta(PostConstruct())

    public function init() : Void
    {
        addMessageListener(MyCoolEnum.BOGA, onBoga);
    }
    
    private function onBoga(m : IMessage) : Void
    {
        dispatchMessage(MyCoolEnum.SHALOM, null, true);
    }
    
    public function dispatch() : Void
    {
        dispatchMessage(MyCoolEnum.PREVED, null, true);
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}
class TestView2 extends AbstractView
{
    public static var VAL : Int;
    
    @:meta(PostConstruct())

    public function init() : Void
    {
        addMessageListener(MyCoolEnum.SHALOM, onShalom);
    }
    
    private function onShalom(m : IMessage) : Void
    {
        trace("SOSISKI");
        TestView2.VAL++;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}
class TestCommand4 extends AbstractCommand
{
    @:meta(Autowired())

    public var testModel : TestModel4;
    
    override public function execute() : Void
    {
        testModel.testVar++;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}
class TestModel4 extends AbstractModel
{
    public var testVar(get, set) : Int;

    private var _testVar : Int;
    
    private function set_testVar(value : Int) : Int
    {
        _testVar = value;
        dispatchMessage(MyCoolEnum.BOGA, null, true);
        return value;
    }
    
    private function get_testVar() : Int
    {
        return _testVar;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}
/////////////////////////
/////////////////////////
class ParentContext extends AbstractContext
{
    private var m : TestModel7;
    
    @:meta(PostConstruct())

    override public function init() : Void
    {
        super.init();
        
        m = factory.getInstance(TestModel7);
        addModel(m);
        
        factory.mapToValue(TestModel7, m);
        
        addModel(factory.getInstance(ChildContext));
        
        m.dispatch();
    }
    
    public function getTestModel() : TestModel7
    {
        return m;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}

class ChildContext extends AbstractContext
{
    @:meta(Autowired())

    public var m : TestModel7;
    
    @:meta(PostConstruct())

    override public function init() : Void
    {
        super.init();
        
        factory.mapToValue(TestModel7, m);
        map(MyCoolEnum.PREVED, TestCommand7);
        
        m.registerExtraMessageHandler(this);
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}

class TestModel7 extends AbstractModel
{
    public var testVar : Int;
    
    public function dispatch() : Void
    {
        dispatchMessage(MyCoolEnum.PREVED, null, true);
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}

class TestCommand7 extends AbstractCommand
{
    @:meta(Autowired())

    public var testModel : TestModel7;
    
    override public function execute() : Void
    {
        testModel.testVar++;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}
//////////////////////////////////////
class TestCommand extends AbstractCommand
{
    @:meta(Autowired())

    public var testModel : TestModel;
    
    override public function execute() : Void
    {
        testModel.testVar++;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}

class TestCommand2 extends AbstractCommand
{
    @:meta(Autowired())

    public var testModel : TestModel2;
    
    override public function execute() : Void
    {
        testModel.testVar++;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}

class TestModel extends AbstractModel
{
    public var testVar : Int;

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}

class TestModel2 extends AbstractModel
{
    public var testVar : Int;

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}

class TestView extends AbstractView
{
    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
    
    public function dispatch() : Void
    {
        dispatchMessage(MyCoolEnum.PREVED, null, true);
    }
}

class TestContext2 extends AbstractContext
{
    private var testView : TestView;
    private var testModel2 : TestModel2;
    
    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
    
    @:meta(PostConstruct())

    override public function init() : Void
    {
        super.init();
        
        testView = factory.getInstance(TestView);
        addView(testView);
        
        testModel2 = factory.getInstance(TestModel2);
        addModel(testModel2);
        
        factory.mapToValue(TestModel2, testModel2);
        
        map(MyCoolEnum.PREVED, TestCommand2);
    }
    
    public function getTestModel() : TestModel2
    {
        return testModel2;
    }
    
    public function ready() : Void
    {
        testView.dispatch();
    }
    
    override public function onMessageBubbled(message : IMessage) : Bool
    {
        super.onMessageBubbled(message);
        
        //to pass message to parent context
        return true;
    }
}

class TestContext1 extends AbstractContext
{
    private var testModel : TestModel;
    
    @:meta(PostConstruct())

    override public function init() : Void
    {
        super.init();
        
        testModel = factory.getInstance(TestModel);
        addModel(testModel);
        
        factory.mapToValue(TestModel, testModel);
        
        map(MyCoolEnum.PREVED, TestCommand);
    }
    
    public function getTestModel() : TestModel
    {
        return testModel;
    }

    @:allow(com.domwires.core.mvc.context)
    private function new()
    {
        super();
    }
}
