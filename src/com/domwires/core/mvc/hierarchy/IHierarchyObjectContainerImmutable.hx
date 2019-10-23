package com.domwires.core.mvc.hierarchy;

/**
 * @see com.domwires.core.mvc.hierarchy.IHierarchyObjectContainer
 */
import haxe.ds.ReadOnlyArray;

interface IHierarchyObjectContainerImmutable extends IHierarchyObjectImmutable
{
    /**
     * @return all children of current container.
     */
    var childrenImmutable(get, never):ReadOnlyArray<IHierarchyObjectImmutable>;

    /**
     * @return true, if current container has provided child.
     * @param child
     */
    function contains(child:IHierarchyObjectImmutable):Bool;
}

