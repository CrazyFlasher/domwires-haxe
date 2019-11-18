/**
 * Created by Anton Nefjodov on 26.01.2016.
 */
package com.domwires.core.mvc.context;

import com.domwires.core.mvc.context.IContextImmutable;
import com.domwires.core.mvc.command.ICommandMapper;
import com.domwires.core.mvc.message.IMessage;
import com.domwires.core.mvc.model.IModelContainer;
import com.domwires.core.mvc.mediator.IMediatorContainer;

/**
 * Context contains models, mediators and services. Also implements <code>ICommandMapper</code>. You can map specific messages, that
 * came out
 * from hierarchy, to <code>ICommand</code>s.
 */
interface IContext extends IContextImmutable extends IModelContainer extends IMediatorContainer extends ICommandMapper
{

    /**
     * Dispatches messages to mediators.
     * @param message
     */
    function dispatchMessageToMediators(message:IMessage):Void;

    /**
     * Dispatches message to models.
     * @param message
     */
    function dispatchMessageToModels(message:IMessage):Void;
}

