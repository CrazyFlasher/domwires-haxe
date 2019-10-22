package com.domwires.core.mvc.view;

import com.domwires.core.mvc.hierarchy.IHierarchyObjectContainer;

/**
 * Container for views.
 */
interface IViewContainer extends IViewContainerImmutable extends IView extends IHierarchyObjectContainer
{
    /**
     * Returns list of views in current container.
     */
    var viewList(get, never):Array<IView>;

	/**
     * Adds view to current container.
     * @param view
     * @return
     */
	function addView(view:IView):IViewContainer;

	/**
     * Removes view from current container.
     * @param view
     * @param dispose
     * @return
     */
	function removeView(view:IView, dispose:Bool = false):IViewContainer;

	/**
     * Removes all views from current container.
     * @param dispose
     * @return
     */
	function removeAllViews(dispose:Bool = false):IViewContainer;
}

