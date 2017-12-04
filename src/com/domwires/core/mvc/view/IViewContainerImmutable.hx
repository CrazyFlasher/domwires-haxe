/**
 * Created by CrazyFlasher on 6.11.2016.
 */
package com.domwires.core.mvc.view;

import com.domwires.core.mvc.hierarchy.IHierarchyObjectContainerImmutable;

/**
	 * @see com.domwires.core.mvc.view.IViewContainer
	 */
interface IViewContainerImmutable extends IHierarchyObjectContainerImmutable
{
    
    /**
		 * Returns number of views in current container.
		 */
    var numViews(get, never) : Int;    
    
    /**
		 * Returns list of views in current container.
		 */
    var viewList(get, never) : Array<Dynamic>;

    
    /**
		 * Returns true, if current container has provided view.
		 * @param view
		 * @return
		 */
    function containsView(view : IViewImmutable) : Bool
    ;
}

