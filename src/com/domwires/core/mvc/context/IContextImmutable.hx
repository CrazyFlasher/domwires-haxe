package com.domwires.core.mvc.context;

import com.domwires.core.mvc.command.ICommandMapperImmutable;
import com.domwires.core.mvc.model.IModelContainerImmutable;
import com.domwires.core.mvc.mediator.IMediatorContainerImmutable;

/**
 * @see com.domwires.core.mvc.context.IContext
 */
interface IContextImmutable extends IModelContainerImmutable extends IMediatorContainerImmutable extends ICommandMapperImmutable
{

}

