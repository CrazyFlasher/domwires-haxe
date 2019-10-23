package com.domwires.core.mvc.view;

import haxe.ds.ReadOnlyArray;
import com.domwires.core.mvc.hierarchy.IHierarchyObjectContainerImmutable;

/**
 * @see com.domwires.core.mvc.view.IViewContainer
 */
interface IViewContainerImmutable extends IHierarchyObjectContainerImmutable
{

	/**
     * @return number of views in current container.
     */
	var numViews(get, never):Int;

	/**
     * @return list of views in current container.
     */
	var viewListImmutable(get, never):ReadOnlyArray<IViewImmutable>;

	/**
     * @param view
     * @return true, if current container has provided view.
     */
	function containsView(view:IViewImmutable):Bool;
}

