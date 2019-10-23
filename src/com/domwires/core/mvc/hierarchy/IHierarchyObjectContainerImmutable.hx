package com.domwires.core.mvc.hierarchy;

/**
 * @see com.domwires.core.mvc.hierarchy.IHierarchyObjectContainer
 */
import haxe.ds.ReadOnlyArray;

interface IHierarchyObjectContainerImmutable extends IHierarchyObjectImmutable
{
    /**
     * Returns all children of current container.
     */
    var childrenImmutable(get, never):ReadOnlyArray<IHierarchyObjectImmutable>;

    /**
     * Returns true, if current container has provided child.
     * @param child
     * @return
     */
    function contains(child:IHierarchyObjectImmutable):Bool;
}

