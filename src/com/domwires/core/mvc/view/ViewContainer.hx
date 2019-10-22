package com.domwires.core.mvc.view;

import com.domwires.core.utils.ArrayUtils;
import com.domwires.core.mvc.hierarchy.HierarchyObjectContainer;

class ViewContainer extends HierarchyObjectContainer implements IViewContainer
{
	public var numViews(get, never):Int;

	public var viewList(get, never):Array<IView>;
	public var viewListImmutable(get, never):Array<IViewImmutable>;

	private var _viewList:Array<IView> = [];
	private var _viewListImmutable:Array<IViewImmutable> = [];

	public function addView(view:IView):IViewContainer
	{
		add(view);

		_viewList.push(view);
		_viewListImmutable.push(view);

		return this;
	}

	public function removeView(view:IView, dispose:Bool = false):IViewContainer
	{
		remove(view, dispose);

		_viewList.remove(view);
		_viewListImmutable.remove(view);

		return this;
	}

	public function removeAllViews(dispose:Bool = false):IViewContainer
	{
		removeAll(dispose);

		ArrayUtils.clear(_viewList);
		ArrayUtils.clear(_viewListImmutable);

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

	private function get_viewList():Array<IView>
	{
		return _viewList;
	}

    private function get_viewListImmutable():Array<IViewImmutable>
    {
        return _viewListImmutable;
    }

	public function new()
	{
		super();
	}
}

