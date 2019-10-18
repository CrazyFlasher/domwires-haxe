package com.domwires.core.mvc.hierarchy;

import com.domwires.core.mvc.message.IMessage;
import haxe.io.Error;

class HierarchyObjectContainer extends AbstractHierarchyObject implements IHierarchyObjectContainer
{
    public var children(get, never):Array<IHierarchyObjectImmutable>;

    private var _childrenList:Array<IHierarchyObjectImmutable> = [];

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
                _childrenList.splice(index, 1)[0];
            }
            _childrenList.insert(index, child);
        }

        if (!contains)
        {
            if (index == -1)
            {
                _childrenList.push(child);
            }

            if (child.parent != null)
            {
                child.parent.remove(child);
            }
            (try cast(child, AbstractHierarchyObject) catch (e:Dynamic) null).setParent(this);
        }

        return this;
    }

    public function remove(child:IHierarchyObject, dispose:Bool = false):IHierarchyObjectContainer
    {
        var childIndex:Int = _childrenList.indexOf(child);

        if (childIndex != -1)
        {
            _childrenList.splice(childIndex, 1)[0];

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
                }
                else
                {
                    child.dispose();
                }
            }
            else
            {
               cast(child, AbstractHierarchyObject).setParent(null);
            }
        }

        if (_childrenList != null)
        {
            _childrenList.splice(0, _childrenList.length);
        }

        return this;
    }

    override public function dispose():Void
    {
        removeAll();

        _childrenList = null;

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

        super.dispose();
    }

    private function get_children():Array<IHierarchyObjectImmutable>
    {
        return _childrenList;
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
        return _childrenList != null && _childrenList.indexOf(child) != -1;
    }

    public function new()
    {
        super();
    }
}
