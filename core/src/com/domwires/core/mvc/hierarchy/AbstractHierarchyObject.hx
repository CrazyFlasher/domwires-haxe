/**
 * Created by Anton Nefjodov on 7.02.2016.
 */
package com.domwires.core.mvc.hierarchy;

import com.domwires.core.mvc.message.MessageDispatcher;

/**
 * Object, that part of hierarchy. Can dispatch and receive messages from hierarchy branch.
 */
class AbstractHierarchyObject extends MessageDispatcher implements IHierarchyObject
{
    public var parent(get, never) : IHierarchyObjectContainer;

    private var _parent : IHierarchyObjectContainer;
    
    public function setParent(value : IHierarchyObjectContainer) : Void
    {
        var hasParent : Bool = _parent != null;
        
        _parent = value;
        
        if (!hasParent && _parent != null)
        {
            addedToHierarchy();
        }
        else if (hasParent && _parent == null)
        {
            removedFromHierarchy();
        }
    }
    
    /**
		 * Called, when object added to hierarchy.
		 */
    private function removedFromHierarchy() : Void
    {
    }
    
    /**
		 * Called, when object removed from hierarchy.
		 */
    private function addedToHierarchy() : Void
    {
    }
    
    /**
		 * @inheritDoc
		 */
    private function get_parent() : IHierarchyObjectContainer
    {
        return _parent;
    }
    
    /**
		 * Disposes hierarchy object and removes reference to parent, if has one.
		 */
    override public function dispose() : Void
    {
        _parent = null;
        
        super.dispose();
    }

    public function new()
    {
        super();
    }
}

