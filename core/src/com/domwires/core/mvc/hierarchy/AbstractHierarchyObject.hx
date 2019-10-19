package com.domwires.core.mvc.hierarchy;

import com.domwires.core.mvc.message.MessageDispatcher;

class AbstractHierarchyObject extends MessageDispatcher implements IHierarchyObject
{
    public var parent(get, never):IHierarchyObjectContainer;

    private var _parent:IHierarchyObjectContainer;

    @:allow(com.domwires.core.mvc.hierarchy.HierarchyObjectContainer)
    private function setParent(value:IHierarchyObjectContainer):Void
    {
        var hasParent:Bool = _parent != null;

        _parent = value;

        if (!hasParent && _parent != null)
        {
            addedToHierarchy();
        } else
        if (hasParent && _parent == null)
        {
            removedFromHierarchy();
        }
    }

    private function removedFromHierarchy():Void
    {
    }

    private function addedToHierarchy():Void
    {
    }

    private function get_parent():IHierarchyObjectContainer
    {
        return _parent;
    }

    override public function dispose():Void
    {
        _parent = null;

        super.dispose();
    }

    private function new()
    {
        super();
    }
}

