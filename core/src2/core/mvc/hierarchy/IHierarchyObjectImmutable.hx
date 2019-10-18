/**
 * Created by CrazyFlasher on 6.11.2016.
 */
package com.domwires.core.mvc.hierarchy;

import com.domwires.core.mvc.message.IMessageDispatcherImmutable;

/**
	 * @see com.domwires.core.mvc.hierarchy.IHierarchyObject
	 */
interface IHierarchyObjectImmutable extends IMessageDispatcherImmutable
{
    
    /**
		 * Returns parent object.
		 */
    var parent(get, never) : IHierarchyObjectContainer;

}

