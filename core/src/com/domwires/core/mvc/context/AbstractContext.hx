package com.domwires.core.mvc.context;

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
import com.domwires.core.mvc.view.AbstractView;
import com.domwires.core.mvc.view.IView;
import com.domwires.core.mvc.view.IViewContainer;
import com.domwires.core.mvc.view.IViewImmutable;
import com.domwires.core.mvc.view.ViewContainer;
import haxe.io.Error;

class AbstractContext extends HierarchyObjectContainer implements IContext
{
    public var numModels(get, never):Int;
    public var modelList(get, never):Array<IModel>;
    public var modelListImmutable(get, never):Array<IModelImmutable>;

    public var numViews(get, never):Int;
    public var viewList(get, never):Array<IView>;
    public var viewListImmutable(get, never):Array<IViewImmutable>;

    @Inject
    private var factory:IAppFactory;

    @Inject
    @Optional
    private var config:ContextConfigVo;

    private var modelContainer:IModelContainer;
    private var viewContainer:IViewContainer;

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

        viewContainer = cast factory.instantiateUnmapped(ViewContainer);
        add(viewContainer);

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

    private function get_modelListImmutable():Array<IModelImmutable>
    {
        checkIfDisposed();

        return modelContainer.modelListImmutable;
    }

    public function addView(view:IView):IViewContainer
    {
        checkIfDisposed();

        viewContainer.addView(view);
        cast (view, AbstractView).setParent(this);

        return this;
    }

    public function removeView(view:IView, dispose:Bool = false):IViewContainer
    {
        checkIfDisposed();

        viewContainer.removeView(view, dispose);

        return this;
    }

    public function removeAllViews(dispose:Bool = false):IViewContainer
    {
        checkIfDisposed();

        viewContainer.removeAllViews(dispose);

        return this;
    }

    private function get_numViews():Int
    {
        checkIfDisposed();

        return viewContainer.numViews;
    }

    public function containsView(view:IViewImmutable):Bool
    {
        checkIfDisposed();

        return viewContainer.containsView(view);
    }

    private function get_viewList():Array<IView>
    {
        checkIfDisposed();

        return viewContainer.viewList;
    }

    private function get_viewListImmutable():Array<IViewImmutable>
    {
        checkIfDisposed();

        return viewContainer.viewListImmutable;
    }

    override public function dispose():Void
    {
        modelContainer.dispose();
        viewContainer.dispose();
        commandMapper.dispose();

        nullifyDependencies();

        super.dispose();
    }

    private function nullifyDependencies():Void
    {
        modelContainer = null;
        viewContainer = null;
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
            if (config.forwardMessageFromModelsToViews)
            {
                dispatchMessageToViews(message);
            }
        } else
        if (Std.is(message.target, IView))
        {
            if (config.forwardMessageFromViewsToModels)
            {
                dispatchMessageToModels(message);
            }
            if (config.forwardMessageFromViewsToViews)
            {
                dispatchMessageToViews(message);
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

    public function dispatchMessageToViews(message:IMessage):Void
    {
        checkIfDisposed();

        viewContainer.dispatchMessageToChildren(message);
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

