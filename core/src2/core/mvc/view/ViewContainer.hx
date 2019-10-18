/**
 * Created by Anton Nefjodov on 7.04.2016.
 */
package com.domwires.core.mvc.view;

import com.domwires.core.mvc.hierarchy.HierarchyObjectContainer;

/**
	 * Container for views.
	 */
class ViewContainer extends HierarchyObjectContainer implements IViewContainer
{
    public var numViews(get, never) : Int;
    public var viewList(get, never) : Array<Dynamic>;

    /**
		 * @inheritDoc
		 */
    public function addView(view : IView) : IViewContainer
    {
        add(view);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeView(view : IView, dispose : Bool = false) : IViewContainer
    {
        remove(view, dispose);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeAllViews(dispose : Bool = false) : IViewContainer
    {
        removeAll(dispose);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    private function get_numViews() : Int
    {
        return (children != null) ? children.length : 0;
    }
    
    /**
		 * @inheritDoc
		 */
    public function containsView(view : IViewImmutable) : Bool
    {
        return contains(view);
    }
    
    /**
		 * @inheritDoc
		 */
    private function get_viewList() : Array<Dynamic>
    {
        return children;
    }

    public function new()
    {
        super();
    }
}

