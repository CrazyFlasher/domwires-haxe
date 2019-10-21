/**
 * Created by Anton Nefjodov on 26.01.2016.
 */
package com.domwires.core.mvc.context;

import com.domwires.core.mvc.context.IContextImmutable;
import com.domwires.core.mvc.command.ICommandMapper;
import com.domwires.core.mvc.message.IMessage;
import com.domwires.core.mvc.model.IModelContainer;
import com.domwires.core.mvc.view.IViewContainer;

/**
 * Context contains models, views and services. Also implements <code>ICommandMapper</code>. You can map specific messages, that
 * came out
 * from hierarchy, to <code>ICommand</code>s.
 */
interface IContext extends IContextImmutable extends IModelContainer extends IViewContainer extends ICommandMapper
{

    /**
     * Dispatches messages to views.
     * @param message
     */
    function dispatchMessageToViews(message:IMessage):Void;

    /**
     * Dispatches message to models.
     * @param message
     */
    function dispatchMessageToModels(message:IMessage):Void;
}

