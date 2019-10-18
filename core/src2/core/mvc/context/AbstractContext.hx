/**
 * Created by Anton Nefjodov on 26.01.2016.
 */
package com.domwires.core.mvc.context;

import com.domwires.core.common.Enum;
import com.domwires.core.mvc.command.CommandMapper;
import com.domwires.core.mvc.command.ICommandMapper;
import com.domwires.core.mvc.command.MappingConfig;
import com.domwires.core.mvc.command.MappingConfigList;
import com.domwires.core.mvc.context.config.ContextConfigVo;
import com.domwires.core.mvc.context.config.ContextConfigVoBuilder;
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
import openfl.errors.Error;

/**
	 * Context contains models, views and services. Also implements <code>ICommandMapper</code>. You can map specific messages, that came out
	 * from hierarchy, to <code>ICommand</code>s.
	 */
class AbstractContext extends HierarchyObjectContainer implements IContextImmutable implements IContext
{
    public var verbose(never, set) : Bool;
    public var numModels(get, never) : Int;
    public var modelList(get, never) : Array<Dynamic>;
    public var numViews(get, never) : Int;
    public var viewList(get, never) : Array<Dynamic>;

    public var config : ContextConfigVo;
    
    private var constructorConfig : ContextConfigVo;
    
    private var modelContainer : IModelContainer;
    private var viewContainer : IViewContainer;
    
    private var commandMapper : ICommandMapper;
    
    public function new(config : ContextConfigVo = null)
    {
        super();
        
        constructorConfig = config;

        init();
    }
    
    private function init() : Void
    {
        if (config == null)
        {
            if (constructorConfig == null)
            {
                config = new ContextConfigVoBuilder().build();
            }
            else
            {
                config = constructorConfig;
            }
        }
        
        modelContainer = new ModelContainer();
        add(modelContainer);
        
        viewContainer = new ViewContainer();
        add(viewContainer);
        
        commandMapper = new CommandMapper(this);
    }
    
    private function set_verbose(value : Bool) : Bool
    {
        commandMapper.verbose = value;
        return value;
    }
    
    /**
		 * @inheritDoc
		 */
    public function addModel(model : IModel) : IModelContainer
    {
        checkIfDisposed();
        
        modelContainer.addModel(model);
        cast (modelContainer, ModelContainer).setParent(this);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeModel(model : IModel, dispose : Bool = false) : IModelContainer
    {
        checkIfDisposed();
        
        modelContainer.removeModel(model, dispose);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeAllModels(dispose : Bool = false) : IModelContainer
    {
        checkIfDisposed();
        
        modelContainer.removeAllModels(dispose);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    private function get_numModels() : Int
    {
        checkIfDisposed();
        
        return modelContainer.numModels;
    }
    
    /**
		 * @inheritDoc
		 */
    public function containsModel(model : IModelImmutable) : Bool
    {
        checkIfDisposed();
        
        return modelContainer.containsModel(model);
    }
    
    /**
		 * @inheritDoc
		 */
    private function get_modelList() : Array<Dynamic>
    {
        checkIfDisposed();
        
        return modelContainer.modelList;
    }
    
    /**
		 * @inheritDoc
		 */
    public function addView(view : IView) : IViewContainer
    {
        checkIfDisposed();
        
        viewContainer.addView(view);
        cast (view, AbstractView).setParent(this);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeView(view : IView, dispose : Bool = false) : IViewContainer
    {
        checkIfDisposed();
        
        viewContainer.removeView(view, dispose);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeAllViews(dispose : Bool = false) : IViewContainer
    {
        checkIfDisposed();
        
        viewContainer.removeAllViews(dispose);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    private function get_numViews() : Int
    {
        checkIfDisposed();
        
        return viewContainer.numViews;
    }
    
    /**
		 * @inheritDoc
		 */
    public function containsView(view : IViewImmutable) : Bool
    {
        checkIfDisposed();
        
        return viewContainer.containsView(view);
    }
    
    /**
		 * @inheritDoc
		 */
    private function get_viewList() : Array<Dynamic>
    {
        checkIfDisposed();
        
        return viewContainer.viewList;
    }
    
    /**
		 * Clears all children, unmaps all commands and nullifies dependencies.
		 */
    override public function dispose() : Void
    {
        modelContainer.dispose();
        viewContainer.dispose();
        commandMapper.dispose();
        
        nullifyDependencies();
        
        super.dispose();
    }
    
    private function nullifyDependencies() : Void
    {
        modelContainer = null;
        viewContainer = null;
        commandMapper = null;
    }
    
    /**
		 * Disposes all children, unmaps all commands and nullifies dependencies.
		 */
    override public function disposeWithAllChildren() : Void
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
    override public function onMessageBubbled(message : IMessage) : Bool
    {
        super.onMessageBubbled(message);
        
        return false;
    }
    
    /**
		 * Handle specified message and send it to context children according context config
		 * @see #com.domwires.core.mvc.context.config.ContextConfigVo
		 * @param message
		 */
    override public function handleMessage(message : IMessage) : Void
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
        }
        else if (Std.is(message.target, IView))
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
    
    /**
		 * @inheritDoc
		 */
    override public function dispatchMessageToChildren(message : IMessage) : Void
    {
        super.dispatchMessageToChildren(message);
        
        tryToExecuteCommand(message);
    }
    
    /**
		 * @inheritDoc
		 */
    public function map(messageType : Enum, commandClass : Class<Dynamic>, data : Dynamic = null, once : Bool = false, stopOnExecute : Bool = false) : MappingConfig
    {
        checkIfDisposed();
        
        return commandMapper.map(messageType, commandClass, data, once, stopOnExecute);
    }
    
    /**
		 * @inheritDoc
		 */
    public function map1(messageType : Enum, commandClassList : Array<Class<Dynamic>>, data : Dynamic = null,
            once : Bool = false, stopOnExecute : Bool = false) : MappingConfigList
    {
        checkIfDisposed();
        
        return commandMapper.map1(messageType, commandClassList, data, once, stopOnExecute);
    }
    
    /**
		 * @inheritDoc
		 */
    public function map2(messageTypeList : Array<Enum>, commandClass : Class<Dynamic>,
            data : Dynamic = null, once : Bool = false, stopOnExecute : Bool = false) : MappingConfigList
    {
        checkIfDisposed();
        
        return commandMapper.map2(messageTypeList, commandClass, data, once, stopOnExecute);
    }
    
    /**
		 * @inheritDoc
		 */
    public function map3(messageTypeList : Array<Enum>, commandClassList : Array<Class<Dynamic>>,
            data : Dynamic = null, once : Bool = false, stopOnExecute : Bool = false) : MappingConfigList
    {
        checkIfDisposed();
        
        return commandMapper.map3(messageTypeList, commandClassList, data, once, stopOnExecute);
    }
    
    /**
		 * @inheritDoc
		 */
    public function unmap(messageType : Enum, commandClass : Class<Dynamic>) : ICommandMapper
    {
        checkIfDisposed();
        
        return commandMapper.unmap(messageType, commandClass);
    }
    
    /**
		 * @inheritDoc
		 */
    public function clear() : ICommandMapper
    {
        checkIfDisposed();
        
        return commandMapper.clear();
    }
    
    /**
		 * @inheritDoc
		 */
    public function unmapAll(messageType : Enum) : ICommandMapper
    {
        checkIfDisposed();
        
        return commandMapper.unmapAll(messageType);
    }
    
    /**
		 * @inheritDoc
		 */
    public function hasMapping(messageType : Enum) : Bool
    {
        checkIfDisposed();
        
        return commandMapper.hasMapping(messageType);
    }
    
    /**
		 * @inheritDoc
		 */
    public function tryToExecuteCommand(message : IMessage) : Void
    {
        checkIfDisposed();
        
        commandMapper.tryToExecuteCommand(message);
    }
    
    /**
		 * @inheritDoc
		 */
    public function dispatchMessageToViews(message : IMessage) : Void
    {
        checkIfDisposed();
        
        viewContainer.dispatchMessageToChildren(message);
    }
    
    /**
		 * @inheritDoc
		 */
    public function dispatchMessageToModels(message : IMessage) : Void
    {
        checkIfDisposed();
        
        modelContainer.dispatchMessageToChildren(message);
    }
    
    /**
		 * @inheritDoc
		 */
    public function executeCommand(commandClass : Class<Dynamic>, data : Dynamic = null, guardList : Array<Class<Dynamic>> = null, guardNotList : Array<Class<Dynamic>> = null) : Bool
    {
        checkIfDisposed();
        
        return commandMapper.executeCommand(commandClass, data, guardList, guardNotList);
    }
    
    private function checkIfDisposed() : Void
    {
        if (isDisposed)
        {
            throw new Error("Context already disposed!");
        }
    }
}

