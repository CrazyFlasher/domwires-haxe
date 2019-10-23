package com.domwires.core.mvc.hierarchy;

import com.domwires.core.mvc.message.IMessageDispatcherImmutable;

/**
 * @see com.domwires.core.mvc.hierarchy.IHierarchyObject
 */
interface IHierarchyObjectImmutable extends IMessageDispatcherImmutable
{
    /**
     * @return parent object.
     */
    var parent(get, never):IHierarchyObjectContainer;
}

