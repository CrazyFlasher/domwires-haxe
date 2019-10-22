package com.domwires.core.mvc.hierarchy;

import com.domwires.core.utils.ArrayUtils;
import com.domwires.core.mvc.message.IMessage;
import haxe.io.Error;

class HierarchyObjectContainer extends AbstractHierarchyObject implements IHierarchyObjectContainer
{
    public var children(get, never):Array<IHierarchyObject>;
    public var childrenImmutable(get, never):Array<IHierarchyObjectImmutable>;

    private var _childrenList:Array<IHierarchyObject> = [];
    private var _childrenListImmutable:Array<IHierarchyObjectImmutable> = [];

    public function add(child:IHierarchyObject, index:Int = -1):IHierarchyObjectContainer
    {
        if (index != -1 && index > _childrenList.length)
        {
            throw Error.Custom("Invalid child index! Index shouldn't be bigger that children list length!");
        }

        var contains:Bool = _childrenList.indexOf(child) != -1;

        if (index != -1)
        {
            if (contains)
            {
                _childrenList.remove(child);
                _childrenListImmutable.remove(child);
            }
            _childrenList.insert(index, child);
            _childrenListImmutable.insert(index, child);
        }

        if (!contains)
        {
            if (index == -1)
            {
                _childrenList.push(child);
                _childrenListImmutable.push(child);
            }

            if (child.parent != null)
            {
                child.parent.remove(child);
            }
            cast(child, AbstractHierarchyObject).setParent(this);
        }

        return this;
    }

    public function remove(child:IHierarchyObject, dispose:Bool = false):IHierarchyObjectContainer
    {
        if (contains(child))
        {
            _childrenList.remove(child);
            _childrenListImmutable.remove(child);

            if (dispose)
            {
                if (Std.is(child, IHierarchyObjectContainer))
                {
                    cast(child, IHierarchyObjectContainer).disposeWithAllChildren();
                } else
                {
                    child.dispose();
                }
            } else
            {
                cast(child, AbstractHierarchyObject).setParent(null);
            }
        }

        return this;
    }

    public function removeAll(dispose:Bool = false):IHierarchyObjectContainer
    {
        for (child in _childrenList)
        {
            if (dispose)
            {
                if (Std.is(child, IHierarchyObjectContainer))
                {
                    cast(child, IHierarchyObjectContainer).disposeWithAllChildren();
                } else
                {
                    child.dispose();
                }
            } else
            {
               cast(child, AbstractHierarchyObject).setParent(null);
            }
        }

        if (_childrenList != null)
        {
            ArrayUtils.clear(_childrenList);
            ArrayUtils.clear(_childrenListImmutable);
        }

        return this;
    }

    override public function dispose():Void
    {
        removeAll();

        _childrenList = null;
        _childrenListImmutable = null;

        super.dispose();
    }

    public function onMessageBubbled(message:IMessage):Bool
    {
        handleMessage(message);

        return true;
    }

    public function disposeWithAllChildren():Void
    {
        removeAll(true);

        _childrenList = null;
        _childrenListImmutable = null;

        super.dispose();
    }

    private function get_children():Array<IHierarchyObject>
    {
        return _childrenList;
    }

    private function get_childrenImmutable():Array<IHierarchyObjectImmutable>
    {
        return _childrenListImmutable;
    }

    public function dispatchMessageToChildren(message:IMessage):Void
    {
        for (child in _childrenList)
        {
            if (message.previousTarget != child)
            {
                if (Std.is(child, IHierarchyObjectContainer))
                {
                    cast(child, IHierarchyObjectContainer).dispatchMessageToChildren(message);
                } else
                if (Std.is(child, IHierarchyObject))
                {
                    child.handleMessage(message);
                }
            }
        }
    }

    public function contains(child:IHierarchyObjectImmutable):Bool
    {
        return _childrenListImmutable != null && _childrenListImmutable.indexOf(child) != -1;
    }

    public function new()
    {
        super();
    }
}
