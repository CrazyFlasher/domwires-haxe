package com.domwires.core.mvc.context;

import haxe.ds.ReadOnlyArray;
import com.domwires.core.factory.IAppFactory;
import com.domwires.core.mvc.command.CommandMapper;
import com.domwires.core.mvc.command.ICommandMapper;
import com.domwires.core.mvc.command.MappingConfig;
import com.domwires.core.mvc.command.MappingConfigList;
import com.domwires.core.mvc.context.config.ContextConfigVo;
import com.domwires.core.mvc.context.config.ContextConfigVoBuilder;
import com.domwires.core.mvc.hierarchy.AbstractHierarchyObject;
import com.domwires.core.mvc.hierarchy.HierarchyObjectContainer;
import com.domwires.core.mvc.message.IMessage;
import com.domwires.core.mvc.model.IModel;
import com.domwires.core.mvc.model.IModelContainer;
import com.domwires.core.mvc.model.IModelImmutable;
import com.domwires.core.mvc.model.ModelContainer;
import com.domwires.core.mvc.mediator.AbstractMediator;
import com.domwires.core.mvc.mediator.IMediator;
import com.domwires.core.mvc.mediator.IMediatorContainer;
import com.domwires.core.mvc.mediator.IMediatorImmutable;
import com.domwires.core.mvc.mediator.MediatorContainer;
import haxe.io.Error;

class AbstractContext extends HierarchyObjectContainer implements IContext
{
    public var numModels(get, never):Int;
    public var modelList(get, never):Array<IModel>;
    public var modelListImmutable(get, never):ReadOnlyArray<IModelImmutable>;

    public var numMediators(get, never):Int;
    public var mediatorList(get, never):Array<IMediator>;
    public var mediatorListImmutable(get, never):ReadOnlyArray<IMediatorImmutable>;

    @Inject
    private var factory:IAppFactory;

    @Inject
    @Optional
    private var config:ContextConfigVo;

    private var modelContainer:IModelContainer;
    private var mediatorContainer:IMediatorContainer;

    private var commandMapper:ICommandMapper;

    private function new()
    {
        super();
    }

    @PostConstruct
    private function init():Void
    {
        if (config == null)
        {
            config = new ContextConfigVoBuilder().build();
        }

        factory.mapToValue(IAppFactory, factory);

        modelContainer = cast factory.instantiateUnmapped(ModelContainer);
        add(modelContainer);

        mediatorContainer = cast factory.instantiateUnmapped(MediatorContainer);
        add(mediatorContainer);

        commandMapper = cast factory.instantiateUnmapped(CommandMapper);
    }

    public function addModel(model:IModel):IModelContainer
    {
        checkIfDisposed();

        modelContainer.addModel(model);
        cast (model, AbstractHierarchyObject).setParent(this);

        return this;
    }

    public function removeModel(model:IModel, dispose:Bool = false):IModelContainer
    {
        checkIfDisposed();

        modelContainer.removeModel(model, dispose);

        return this;
    }

    public function removeAllModels(dispose:Bool = false):IModelContainer
    {
        checkIfDisposed();

        modelContainer.removeAllModels(dispose);

        return this;
    }

    private function get_numModels():Int
    {
        checkIfDisposed();

        return modelContainer.numModels;
    }

    public function containsModel(model:IModelImmutable):Bool
    {
        checkIfDisposed();

        return modelContainer.containsModel(model);
    }

    private function get_modelList():Array<IModel>
    {
        checkIfDisposed();

        return modelContainer.modelList;
    }

    private function get_modelListImmutable():ReadOnlyArray<IModelImmutable>
    {
        checkIfDisposed();

        return modelContainer.modelListImmutable;
    }

    public function addMediator(mediator:IMediator):IMediatorContainer
    {
        checkIfDisposed();

        mediatorContainer.addMediator(mediator);
        cast (mediator, AbstractMediator).setParent(this);

        return this;
    }

    public function removeMediator(mediator:IMediator, dispose:Bool = false):IMediatorContainer
    {
        checkIfDisposed();

        mediatorContainer.removeMediator(mediator, dispose);

        return this;
    }

    public function removeAllMediators(dispose:Bool = false):IMediatorContainer
    {
        checkIfDisposed();

        mediatorContainer.removeAllMediators(dispose);

        return this;
    }

    private function get_numMediators():Int
    {
        checkIfDisposed();

        return mediatorContainer.numMediators;
    }

    public function containsMediator(mediator:IMediatorImmutable):Bool
    {
        checkIfDisposed();

        return mediatorContainer.containsMediator(mediator);
    }

    private function get_mediatorList():Array<IMediator>
    {
        checkIfDisposed();

        return mediatorContainer.mediatorList;
    }

    private function get_mediatorListImmutable():ReadOnlyArray<IMediatorImmutable>
    {
        checkIfDisposed();

        return mediatorContainer.mediatorListImmutable;
    }

    override public function dispose():Void
    {
        modelContainer.dispose();
        mediatorContainer.dispose();
        commandMapper.dispose();

        nullifyDependencies();

        super.dispose();
    }

    private function nullifyDependencies():Void
    {
        modelContainer = null;
        mediatorContainer = null;
        commandMapper = null;
    }

    override public function disposeWithAllChildren():Void
    {
        commandMapper.dispose();

        nullifyDependencies();

        super.disposeWithAllChildren();
    }

    /**
     * By default, messaged won't bubble up to higher hierarchy level.
     * Override and return true, if you want bubbled message move higher.
     * @see com.domwires.core.mvc.message.IBubbleMessageHandler#onMessageBubbled
     */
    override public function onMessageBubbled(message:IMessage):Bool
    {
        super.onMessageBubbled(message);

        return false;
    }

    /**
     * Handle specified message and send it to context children according context config
     * @see #com.domwires.core.mvc.context.config.ContextConfigVo
     * @param message
     */
    override public function handleMessage(message:IMessage):Void
    {
        super.handleMessage(message);

        tryToExecuteCommand(message);

        if (Std.is(message.target, IModel))
        {
            if (config.forwardMessageFromModelsToModels)
            {
                dispatchMessageToModels(message);
            }
            if (config.forwardMessageFromModelsToMediators)
            {
                dispatchMessageToMediators(message);
            }
        } else
        if (Std.is(message.target, IMediator))
        {
            if (config.forwardMessageFromMediatorsToModels)
            {
                dispatchMessageToModels(message);
            }
            if (config.forwardMessageFromMediatorsToMediators)
            {
                dispatchMessageToMediators(message);
            }
        }
    }

    override public function dispatchMessageToChildren(message:IMessage):Void
    {
        super.dispatchMessageToChildren(message);

        tryToExecuteCommand(message);
    }

    public function map(messageType:EnumValue, commandClass:Class<Dynamic>, data:Dynamic = null, once:Bool = false, stopOnExecute:Bool = false):MappingConfig
    {
        checkIfDisposed();

        return commandMapper.map(messageType, commandClass, data, once, stopOnExecute);
    }

    public function map1(messageType:EnumValue, commandClassList:Array<Class<Dynamic>>, data:Dynamic = null,
                         once:Bool = false, stopOnExecute:Bool = false):MappingConfigList
    {
        checkIfDisposed();

        return commandMapper.map1(messageType, commandClassList, data, once, stopOnExecute);
    }

    public function map2(messageTypeList:Array<EnumValue>, commandClass:Class<Dynamic>,
                         data:Dynamic = null, once:Bool = false, stopOnExecute:Bool = false):MappingConfigList
    {
        checkIfDisposed();

        return commandMapper.map2(messageTypeList, commandClass, data, once, stopOnExecute);
    }

    public function map3(messageTypeList:Array<EnumValue>, commandClassList:Array<Class<Dynamic>>,
                         data:Dynamic = null, once:Bool = false, stopOnExecute:Bool = false):MappingConfigList
    {
        checkIfDisposed();

        return commandMapper.map3(messageTypeList, commandClassList, data, once, stopOnExecute);
    }

    public function unmap(messageType:EnumValue, commandClass:Class<Dynamic>):ICommandMapper
    {
        checkIfDisposed();

        return commandMapper.unmap(messageType, commandClass);
    }

    public function clear():ICommandMapper
    {
        checkIfDisposed();

        return commandMapper.clear();
    }

    public function unmapAll(messageType:EnumValue):ICommandMapper
    {
        checkIfDisposed();

        return commandMapper.unmapAll(messageType);
    }

    /**
		 * @inheritDoc
		 */
    public function hasMapping(messageType:EnumValue):Bool
    {
        checkIfDisposed();

        return commandMapper.hasMapping(messageType);
    }

    public function tryToExecuteCommand(message:IMessage):Void
    {
        checkIfDisposed();

        commandMapper.tryToExecuteCommand(message);
    }

    public function dispatchMessageToMediators(message:IMessage):Void
    {
        checkIfDisposed();

        mediatorContainer.dispatchMessageToChildren(message);
    }

    public function dispatchMessageToModels(message:IMessage):Void
    {
        checkIfDisposed();

        modelContainer.dispatchMessageToChildren(message);
    }

    public function executeCommand(commandClass:Class<Dynamic>, data:Dynamic = null, guardList:Array<Class<Dynamic>> = null, guardNotList:Array<Class<Dynamic>> = null):Bool
    {
        checkIfDisposed();

        return commandMapper.executeCommand(commandClass, data, guardList, guardNotList);
    }

    public function setMergeMessageDataAndMappingData(value:Bool):ICommandMapper
    {
        return commandMapper.setMergeMessageDataAndMappingData(value);
    }

    private function checkIfDisposed():Void
    {
        if (isDisposed)
        {
            throw Error.Custom("Context already disposed!");
        }
    }
}

