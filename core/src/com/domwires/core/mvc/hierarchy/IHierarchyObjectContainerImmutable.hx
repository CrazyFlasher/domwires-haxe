/**
 * Created by CrazyFlasher on 6.11.2016.
 */
package com.domwires.core.mvc.hierarchy;


/**
	 * @see com.domwires.core.mvc.hierarchy.IHierarchyObjectContainer
	 */
interface IHierarchyObjectContainerImmutable extends IHierarchyObjectImmutable
{
    
    /**
     * Returns all children of current container.
     */
    var children(get, never) : Array<Dynamic>;

    
    /**
     * Returns true, if current container has provided child.
     * @param child
     * @return
     */
    function contains(child : IHierarchyObjectImmutable) : Bool;
}

