package com.domwires.core.mvc.view;

import com.domwires.core.mvc.hierarchy.HierarchyObjectContainer;

class ViewContainer extends HierarchyObjectContainer implements IViewContainer
{
	public var numViews(get, never):Int;
	public var viewList(get, never):Array<IView>;
	public var viewListImmutable(get, never):Array<IViewImmutable>;

	public function addView(view:IView):IViewContainer
	{
		add(view);

		return this;
	}

	public function removeView(view:IView, dispose:Bool = false):IViewContainer
	{
		remove(view, dispose);

		return this;
	}

	public function removeAllViews(dispose:Bool = false):IViewContainer
	{
		removeAll(dispose);

		return this;
	}

	private function get_numViews():Int
	{
		return (children != null) ? children.length : 0;
	}

	public function containsView(view:IViewImmutable):Bool
	{
		return contains(view);
	}

	private function get_viewList():Array<Dynamic>
	{
		return children;
	}

    private function get_viewListImmutable():Array<Dynamic>
    {
        return childrenImmutable;
    }

	public function new()
	{
		super();
	}
}

