## DomWires [![Build Status](https://travis-ci.org/CrazyFlasher/domwires-haxe.svg?branch=master)](https://travis-ci.org/CrazyFlasher/domwires-haxe)
Flexible and extensible MVC framework for projects written in [Haxe](https://haxe.org/).

`haxelib install DomWires 1.0.0-alpha.13`

### Features
* Splitting logic from visual part
* Immutable interfaces are separated from mutable, for safe usage of read-only models (for example in mediators)
* Possibility to use many implementations for interface easily
* Fast communication among components using [IMessageDispatcher](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/message/IMessageDispatcher.html)
* Object instantiation with dependencies injections using cool [IAppFactory](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/factory/IAppFactory.html)
* Possibility to specify dependencies in config and pass it to [IAppFactory](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/factory/IAppFactory.html)
* Easy object pooling management
* Custom message bus (event bus) for easy and strict communication among objects

***

#### 1. Hierarchy and components communication
![Diagramm](http://188.166.108.195/projects/domwires-haxe/dw.png)

On diagram we have main [IContext](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/context/IContext.html) in the center with 2 child contexts. 

Lets take a look at right [IContext](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/context/IContext.html).

Right [IContext](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/context/IContext.html) is mapped to AppContext implementation. You can see its hierarchy on the screen:
[IModelContainer](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/model/IModelContainer.html) with 2 child models, [IUIMediator](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/mediator/IMediator.html) with IButtonView and [IScreenMediator](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/mediator/IMediator.html) with 3 views.

[IContext](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/context/IContext.html) and its children all extend [IMessageDispatcher](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/message/IMessageDispatcher.html) and can listen or dispatch [IMessage](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/message/IMessage.html).

All messages in model hierarchy and from mediators bubble up to [IContext](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/context/IContext.html). Also bubbled-up messages can be forwarded to parent contexts (by default forwarding message from child context to parent is disabled).

Also in default [IContext](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/context/IContext.html) configuration messages from models will be forwarded to mediators, messages from mediators will be forwarded to models and mediators.

[IContext](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/context/IContext.html) extends [ICommandMapper](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/command/ICommandMapper.html) and can map received messages (from model and mediators) to commands.

##### Creating context with default configuration
```haxe
var factory:IAppFactory = new AppFactory();
factory.mapToValue(IAppFactory, factory);

var contextConfigBuilder:ContextConfigVoBuilder = new ContextConfigVoBuilder();
contextConfigBuilder.forwardMessageFromModelsToModels = false;
contextConfigBuilder.forwardMessageFromMediatorsToMediators = true;
contextConfigBuilder.forwardMessageFromMediatorsToModels = false;
contextConfigBuilder.forwardMessageFromModelsToMediators = true;

factory.mapToValue(ContextConfigVo, contextConfigBuilder.build());
factory.getInstance(AppContext);
```
##### Dispatching message from model
```haxe
class AppModel extends AbstractModel implements IAppModel
{
    @PostConstruct
    private function init():Void
    {
        dispatchMessage(AppModelMessage.Notify);
    }
}

enum AppModelMessage
{
    Notify;
}
```
##### Listening message of model in mediator without having reference to model
```haxe
class UIMediator extends AbstractMediator implements IUIMediator
{
    @PostConstruct
    private function init():Void
    {
        addMessageListener(AppModelMessage.Notify, handleAppModelNotify);
    }
    
    private function handleAppModelNotify(message:IMessage):Void
    {
        trace("Message received: ", message.type);
    }
}
```
##### Listening model message in mediator with hard reference to model
```haxe
class UIMediator extends AbstractMediator implements IUIMediator
{
    @Inject
    private var appModel:IAppModelImmutable;
    
    @PostConstruct
    private function init():Void
    {
        appModel.addMessageListener(AppModelMessage.Notify, handleAppModelNotify);
    }

    override public function dispose():Void
    {
        appModel.removeMessageListener(AppModelMessage.Notify, handleAppModelNotify);
        
        super.dispose();
    }

    private function handleAppModelNotify(message:IMessage):Void
    {
        trace("Message received: ", message.type);
    }
}
```
##### Listening model message in mediator with hard reference to model
```haxe
class UIMediator extends AbstractMediator implements IUIMediator
{
    @Inject
    private var appModel:IAppModelImmutable;
    
    @PostConstruct
    private function init():Void
    {
        appModel.addMessageListener(AppModelMessage.Notify, handleAppModelNotify);
    }

    override public function dispose():Void
    {
        appModel.removeMessageListener(AppModelMessage.Notify, handleAppModelNotify);
        
        super.dispose();
    }

    private function handleAppModelNotify(message:IMessage):Void
    {
        trace("Message received: ", message.type);
    }
}
```

#### 2. Types mapping

##### Map 1 type to another
```haxe
var factory:IAppFactory = new AppFactory();
factory.mapToType(IMyObj, MyObj);

//Will return new instance of MyObj
var obj:IMyObj = factory.getInstance(IMyObj);
```

##### Map type to value
```haxe
var factory:IAppFactory = new AppFactory();
factory.mapToType(IMyObj, MyObj);

//Will return new instance of MyObj
var obj:IMyObj = factory.getInstance(IMyObj);
factory.mapToValue(IMyObj, obj);

//obj2 will equal obj1
var obj2:IMyObj = factory.getInstance(IMyObj);
```

##### Apply mapping at runtime via configuration
You can easily specify mappings via JSON config.
[See "testMappingViaConfig" test as an example](https://github.com/CrazyFlasher/domwires-haxe/blob/7660a5335e94c37d56bd97fe7ea8acb2b707d1de/test/AppFactoryTest.hx#L342).

##### Default value of interface
If no mapping is specified, [IAppFactory](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/factory/IAppFactory.html) will try to find default implementation on the interface.

Default implementation should be in the same package with interface and without this first "I" char.
```haxe
var factory:IAppFactory = new AppFactory();

//Will try to return instance of MyObj class 
var obj:IMyObj = factory.getInstance(IMyObj);
```

#### 3. Message bubbling
By default, when message is dispatched it will be bubbled-up to top of the hierarchy.
But you can dispatch message without bubbling.

##### Dispatch message without bubbling it up
```haxe
//set the 3-rd parameter "bubbles" to false
dispatchMessage(UIMediatorMessage.UpdateAppState, {state: AppState.Enabled}, false);
```
It is also possible to stop bubbling up received message from bottom of hierarchy

##### Stop message propagation
```haxe
override public function onMessageBubbled(message:IMessage):Bool
{
    super.onMessageBubbled(message);

    //message won't propagate to higher level of hierarchy
    return false;
}
```
To stop forwarding redirected message from context (for ex. mediator dispatcher bubbling message, context receives it and forwards to
 models), you can do that way:

##### 
```haxe
override public function dispatchMessageToChildren(message:IMessage):Void
{
    /*
    * Do not forward received messages to children.
    * Just don't call super.dispatchMessageToChildren(message);
    */
}
```

#### 4. Mapping messages to commands in IContext
[IContext](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/context/IContext.html) extends [ICommandMapper](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/command/ICommandMapper.html) and can map any received message to command.

##### Mapping message to command
```haxe
class AppContext extends AbstractContext implements IContext
{
    override private function init():Void
    {
        super.init();
        
        map(UIMediatorMessage.UpdateAppState, UpdateAppStateCommand);
    }
}
```
In code screen above, when context receive message with `UIMediatorMessage.UpdateAppState` type, it will execute `UpdateAppStateCommand`.
Everything that is mapped to [IContext](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/context/IContext.html) factory will be injected to command.

##### Inject model to command
```haxe
class AppContext extends AbstractContext implements IContext
{
    private var appModel:IAppModel;
    
    override private function init():Void
    {
        super.init();

        appModel = factory.getInstance(IAppModel);
        addModel(appModel);
        
        factory.mapToValue(IAppModel, appModel)
        
        map(UIMediatorMessage.UpdateAppState, UpdateAppStateCommand);
    }
}

class UpdateAppStateCommand extends AbstractCommand
{
    @Inject
    private var appModel:IAppModel;

    override public function execute():Void
    {
        super.execute();

        //TODO: do something
    }
}
```
Also [IMessage](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/message/IMessage.html) can deliver data, that will be also injected to command.

##### Injecting IMessage data to command
```haxe
class UIMediator extends AbstractMediator implements IUIMediator
{
    @PostConstruct
    private function init():Void
    {
        dispatchMessage(UIMediatorMessage.UpdateAppState, {state: AppState.Enabled});
    }
}


class UpdateAppStateCommand extends AbstractCommand
{
    @Inject
    private var appModel:IAppModel;

    @Inject("state")
    private var state:AppState;

    override public function execute():Void
    {
        super.execute();

        appModel.setCurrentState(state);
    }
}
```

#### 5. Command guards
It is possible to add “guards“, when mapping commands.
Guards allow doesn’t allow to execute command at current application state.

##### Adding guards to command mapping
```haxe
class AppContext extends AbstractContext implements IContext
{
    private var appModel:IAppModel;

    override private function init():Void
    {
        super.init();

        appModel = factory.getInstance(IAppModel);
        addModel(appModel);
        
        factory.mapToValue(IAppModel, appModel)

        map(UIMediatorMessage.UpdateAppState, UpdateAppStateCommand)
            .addGuards(CurrentStateIsDisabledGuards);
    }
}

class CurrentStateIsDisabledGuards extends AbstractGuards
{
    @Inject
    private var appModel:IAppModel;

    override private function get_allows():Bool
    {
        super.get_allows();
        
        return appModel.currentState == AppState.Disabled; 
    }
}
```
In above example command won’t be executed, if `appModel.currentState != AppState.Disabled`.

#### 6. Object pooling
[IAppFactory](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/factory/IAppFactory.html) has API to work with object pools.

##### Register pool 
```haxe
class AppContext extends AbstractContext implements IContext
{
    override private function init():Void
    {
        super.init();

        //Registering pool of MyObj with capacity 5 and instantiate them immediately
        factory.registerPool(MyObj, 5, true);

        for (i in 0...100)
        {
            //Will return one of objects in pool
            factory.getInstance(MyObj);
        }
    }
}
```
There are other helpful methods to work with pool in IAppFactory

#### 7. Handling multiple implementations of one interface
It is possible to dynamically map different implementations to one interface.

##### Mapping specific implementation according platform
```haxe
class AppContext extends AbstractContext implements IContext
{
    override private function init():Void
    {
        super.init();

        #if js
        factory.mapToType(INetworkConnector, JSNetworkConnector);
        #elseif native
        factory.mapToType(INetworkConnector, NativeNetworkConnector);
        #else
        throw Error.Custom("There is no default implementation of INetworkConnector");
        #end
    }
}
```
There are even possibilities to remap commands.

##### Remapping command
```haxe
factory.mapToType(
    com.crazyflasher.app.commands.UpdateModelsCommand,
    com.mycompany.coolgame.commands.UpdateModelsCommand
);
        
/*
* Will execute com.mycompany.coolgame.commands.UpdateModelsCommand instead of
* com.crazyflasher.app.commands.UpdateModelsCommand
*/
commandMapper.executeCommand(com.crazyflasher.app.commands.UpdateModelsCommand);
```
Also you can map extended class to base

##### Map extended class to base
```haxe
//GameSingleWinVo extends SingleWinVo
factory.mapToType(SingleWinVo, GameSingleWinVo);
        
//Will return new instance of GameSingleWinVo
factory.getInstance(SingleWinVo);
```

#### 8. Immutability
DomWires recommends to follow immutability paradigm. So mediators have access only to immutable interfaces of hierarchy components. But
 feel free to mutate them via commands. To handle this way, it’s better to have separate factories for different types of components. At
  least to have separate factory for context components (do not use internal context factory, that is used for injecting stuff to commands and guards).

##### Mapping mutable and immutable interfaces of model
```haxe
class AppContext extends AbstractContext implements IContext
{
    override private function init():Void
    {
        super.init();

        var appModel:IAppModel = factory.getInstance(IAppModel);
        addModel(appModel);
        
        map(UIMediatorMessage.UpdateAppState, UpdateAppStateCommand)
            .addGuards(CurrentStateIsDisabledGuards);

        var mediatorFactory:IAppFactory = new AppFactory();

        //mutable interface will be available in commands
        factory.mapToValue(IAppModel, appModel);

        //immutable interface will be available in mediators
        mediatorFactory.mapToValue(IAppModelImmutable, appModel);
        
        var uiMediator:IUIMediator = mediatorFactory.getInstance(IUIMediator);
        addMediator(uiMediator);
    }
}

class AppModel extends AbstractModel implements IAppModel
{
    public var currentState(get, never):EnumValue;
    
    private var _currentState:EnumValue;

    public function setCurrentState(value:EnumValue):IAppModel
    {
        _currentState = value;
        
        dispatchMessage(AppModelMessage.StateUpdated);
    }

    private function get_currentState():EnumValue
    {
        return _currentState;
    }
}

interface IAppModel extends IAppModelImmutable extends IModel
{
    function setCurrentState(value:EnumValue):IAppModel;
}

interface IAppModelImmutable extends IModelImmutable
{
    var currentState(get, never):EnumValue;
}

enum AppModelMessage
{
    StateUpdated;
}

class UIMediator extends AbstractMediator implements IUIMediator
{
    @Inject
    private var appModel:IAppModelImmutable;

    @PostConstruct
    private function init():Void
    {
        addMessageListener(AppModelMessage.StateUpdated, appModelStateUpdated);

        dispatchMessage(UIMediatorMessage.UpdateAppState, {state: AppState.Enabled});
    }

    private function appModelStateUpdated(message:IMessage):Void
    {
        //possibility to access read-only field
        trace(appModel.currentState);
    }
}

enum UIMediatorMessage
{
    UpdateAppState;
}

class UpdateAppStateCommand extends AbstractCommand
{
    @Inject
    private var appModel:IAppModel;

    @Inject("state")
    private var state:AppState;

    override public function execute():Void
    {
        super.execute();

        appModel.setCurrentState(state);
    }
}

class CurrentStateIsDisabledGuards extends AbstractGuards
{
    @Inject
    private var appModel:IAppModel;

    override private function get_allows():Bool
    {
        super.get_allows();

        return appModel.currentState == AppState.Disabled;
    }
}
```

***

### Minimum requirements
* Haxe 4.0.1 or higher

***

- [HaxeDoc](http://188.166.108.195/projects/domwires-haxe/docs)
