/**
 * Created by Anton Nefjodov on 26.01.2016.
 */
package com.domwires.core.mvc.message;

import haxe.Constraints.Function;
import com.domwires.core.common.Enum;
import com.domwires.core.factory.AppFactory;
import com.domwires.core.factory.IAppFactory;
import com.domwires.core.mvc.context.AbstractContext;
import com.domwires.core.mvc.context.IContext;
import com.domwires.core.mvc.model.AbstractModel;
import com.domwires.core.mvc.model.ModelContainer;
import com.domwires.core.mvc.view.AbstractView;
import flash.events.Event;
import org.flexunit.asserts.AssertEquals;
import org.flexunit.asserts.AssertTrue;
import testObject.MyCoolEnum;

import com.domwires.core.mvc.message.IMessage;
import flash.display.Sprite;

class BubblingMessageTest
{
    private var m1 : AbstractModel;
    private var c1 : AbstractContext;
    private var c2 : AbstractContext;
    private var c3 : AbstractContext;
    private var c4 : AbstractContext;
    private var mc1 : ModelContainer;
    private var mc2 : ModelContainer;
    private var mc3 : ModelContainer;
    private var mc4 : ModelContainer;
    private var v1 : AbstractView;
    
    private var factory : IAppFactory;
    
    /**
		 * 			c1
		 * 		 /	|  \
		 * 		c2	c3	c4
		 * 		|	|	|
		 * 		mc1	mc3	mc4
		 * 		|
		 * 		mc2
		 * 		|
		 * 		m1
		 */
    
    @Before
    public function setUp() : Void
    {
        factory = new AppFactory();
        factory.mapToValue(IAppFactory, factory);
        
        c1 = factory.getInstance(MyContext, ["c1"]);
        c2 = factory.getInstance(MyContext, ["c2"]);
        c3 = factory.getInstance(MyContext, ["c3"]);
        c4 = factory.getInstance(MyContext, ["c4"]);
        mc1 = new ModelContainer();
        mc2 = new ModelContainer();
        mc3 = new ModelContainer();
        mc4 = new ModelContainer();
        m1 = new AbstractModel();
        v1 = new AbstractView();
        
        mc2.addModel(m1);
        mc1.addModel(mc2);
        c4.addModel(mc4);
        c3.addModel(mc3);
        c2.addModel(mc1);
        c1.add(c2);
        c1.add(c3);
        c1.add(c4);
        c1.addView(v1);
    }
    
    //		[Ignore]
    @Test
    public function testBubblingFromBottomToTop() : Void
    {
        var bubbledEventType : Enum;
        
        var successFunc : Function = function(event : IMessage) : Void
        //message came from bottom to top
        {
            
            bubbledEventType = event.type;
        }
        
        //top element
        c1.addMessageListener(MyCoolEnum.PREVED, successFunc);
        
        //bottom element
        m1.dispatchMessage(MyCoolEnum.PREVED, {
                    name : "Anton"
                }, true);
        
        Assert.areEqual(bubbledEventType, MyCoolEnum.PREVED);
        
        bubbledEventType = null;
        
        v1.dispatchMessage(MyCoolEnum.PREVED, {
                    name : "Anton"
                }, true);
        
        Assert.areEqual(bubbledEventType, MyCoolEnum.PREVED);
    }
    
    @Ignore
    @Test
    public function testBubblingFromBottomToTopPerf() : Void
    {
        var bubbledEventType : Enum;
        var count : Int;
        
        var successFunc : Function = function(event : IMessage) : Void
        {  //message came from bottom to top  
            //count++;
            //bubbledEventType = event.type;
            //trace(event.currentTarget.name);
            
        }
        
        
        var c1 : IContext = factory.getInstance(MyContext, ["c1"]);
        var c2 : IContext = factory.getInstance(MyContext, ["c2"]);
        var c3 : IContext = factory.getInstance(MyContext, ["c3"]);
        var c4 : IContext = factory.getInstance(MyContext, ["c4"]);
        var c5 : IContext = factory.getInstance(MyContext, ["c5"]);
        var c6 : IContext = factory.getInstance(MyContext, ["c6"]);
        var c7 : IContext = factory.getInstance(MyContext, ["c7"]);
        var c8 : IContext = factory.getInstance(MyContext, ["c8"]);
        var c9 : IContext = factory.getInstance(MyContext, ["c9"]);
        var c10 : IContext = factory.getInstance(MyContext, ["c10"]);
        
        c1.addModel(
                c2.addModel(
                        c3.addModel(
                                c4.addModel(
                                        c5.addModel(
                                                c6.addModel(
                                                        c7.addModel(
                                                                c8.addModel(
                                                                        c9.addModel(
                                                                                c10
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        );
        
        
        for (i in 0...100000)
        {
            count = 0;
            bubbledEventType = null;
            
            //top element
            c1.addMessageListener(MyCoolEnum.PREVED, successFunc);
            c2.addMessageListener(MyCoolEnum.PREVED, successFunc);
            c3.addMessageListener(MyCoolEnum.PREVED, successFunc);
            c4.addMessageListener(MyCoolEnum.PREVED, successFunc);
            c5.addMessageListener(MyCoolEnum.PREVED, successFunc);
            c6.addMessageListener(MyCoolEnum.PREVED, successFunc);
            c7.addMessageListener(MyCoolEnum.PREVED, successFunc);
            c8.addMessageListener(MyCoolEnum.PREVED, successFunc);
            c9.addMessageListener(MyCoolEnum.PREVED, successFunc);
            c10.addMessageListener(MyCoolEnum.PREVED, successFunc);
            
            //bottom element
            c10.dispatchMessage(MyCoolEnum.PREVED, {
                        name : "Anton"
                    }, false);
        }
    }
    
    @Ignore
    @Test
    public function testBubblingFromBottomToTopPerfDisplayObject() : Void
    {
        var bubbledEventType : String;
        var count : Int;
        
        var successFunc : Function = function(event : Event) : Void
        {  //message came from bottom to top  
            //				count++;
            //				bubbledEventType = event.type;
            //				trace(event.currentTarget.name);
            
        }
        
        var d1 : MyDisplayObjectContainer = new MyDisplayObjectContainer("d1");
        var d2 : MyDisplayObjectContainer = new MyDisplayObjectContainer("d2");
        var d3 : MyDisplayObjectContainer = new MyDisplayObjectContainer("d3");
        var d4 : MyDisplayObjectContainer = new MyDisplayObjectContainer("d4");
        var d5 : MyDisplayObjectContainer = new MyDisplayObjectContainer("d5");
        var d6 : MyDisplayObjectContainer = new MyDisplayObjectContainer("d6");
        var d7 : MyDisplayObjectContainer = new MyDisplayObjectContainer("d7");
        var d8 : MyDisplayObjectContainer = new MyDisplayObjectContainer("d8");
        var d9 : MyDisplayObjectContainer = new MyDisplayObjectContainer("d9");
        var d10 : MyDisplayObjectContainer = new MyDisplayObjectContainer("d10");
        
        d1.addChild(d2);
        d2.addChild(d3);
        d3.addChild(d4);
        d4.addChild(d5);
        d5.addChild(d6);
        d6.addChild(d7);
        d7.addChild(d8);
        d8.addChild(d9);
        d9.addChild(d10);
        
        for (i in 0...500)
        {
            count = 0;
            bubbledEventType = null;
            
            //top element
            
            d1.addEventListener("preved", successFunc);
            d2.addEventListener("preved", successFunc);
            d3.addEventListener("preved", successFunc);
            d4.addEventListener("preved", successFunc);
            d5.addEventListener("preved", successFunc);
            d6.addEventListener("preved", successFunc);
            d7.addEventListener("preved", successFunc);
            d8.addEventListener("preved", successFunc);
            d9.addEventListener("preved", successFunc);
            d10.addEventListener("preved", successFunc);
            
            //bottom element
            d10.dispatchEvent(new Event("preved", true));
        }
    }
    
    @Ignore
    @Test
    public function testHierarchy() : Void
    {
        Assert.isTrue(c3.parent == c1);
        Assert.isTrue(mc3.parent == c3);
        Assert.isTrue(mc4.parent == c4);
        Assert.isTrue(m1.parent == mc2);
        Assert.isTrue(m1.parent != mc1);
        Assert.isTrue(mc2.parent == mc1);
        Assert.isTrue(mc2.parent != c2);
        Assert.isTrue(m1.parent != c1);
    }
    
    @After
    public function tearDown() : Void
    {
        c1.dispose();
        factory.dispose();
    }

    public function new()
    {
    }
}




class MyContext extends AbstractContext
{
    public var name(get, never) : String;

    private var _name : String;
    
    @:allow(com.domwires.core.mvc.message)
    private function new(name : String)
    {
        _name = name;
        
        super();
    }
    
    override public function onMessageBubbled(message : IMessage) : Bool
    {
        super.onMessageBubbled(message);
        
        //bubble up!
        return true;
    }
    
    private function get_name() : String
    {
        return _name;
    }
}

class MyDisplayObjectContainer extends Sprite
{
    private var _name : String;
    
    @:allow(com.domwires.core.mvc.message)
    private function new(name : String)
    {
        super();
        _name = name;
    }
    
    override private function get_name() : String
    {
        return _name;
    }
}
