package com.domwires.core.mvc.view;

import haxe.ds.ReadOnlyArray;
import com.domwires.core.mvc.hierarchy.IHierarchyObjectContainerImmutable;

/**
 * @see com.domwires.core.mvc.view.IViewContainer
 */
interface IViewContainerImmutable extends IHierarchyObjectContainerImmutable
{

	/**
     * Returns number of views in current container.
     */
	var numViews(get, never):Int;

	/**
     * Returns list of views in current container.
     */
	var viewListImmutable(get, never):ReadOnlyArray<IViewImmutable>;

	/**
     * Returns true, if current container has provided view.
     * @param view
     * @return
     */
	function containsView(view:IViewImmutable):Bool;
}

