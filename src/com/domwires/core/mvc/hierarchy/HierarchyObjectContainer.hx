/**
 * Created by Anton Nefjodov on 6.04.2016.
 */
package com.domwires.core.mvc.hierarchy;

import flash.errors.Error;
import com.domwires.core.mvc.message.IMessage;

/**
	 * Container of <code>IHierarchyObject</code>s
	 */
class HierarchyObjectContainer extends AbstractHierarchyObject implements IHierarchyObjectContainer
{
    public var children(get, never) : Array<Dynamic>;

    /*
		* Have to use Array instead of Vector, because of Vector casing issues and
		* "abc bytecode decoding failed" compile error.
		*/
    private var _childrenList : Array<Dynamic> = [];
    
    /**
		 * @inheritDoc
		 */
    public function add(child : IHierarchyObject, index : Int = -1) : IHierarchyObjectContainer
    {
        if (index != -1 && index > _childrenList.length)
        {
            throw new Error("Invalid child index! Index shouldn't be bigger that children list length!");
        }
        
        var contains : Bool = Lambda.indexOf(_childrenList, child) != -1;
        
        if (index != -1)
        {
            if (contains)
            {
                _childrenList.splice(Lambda.indexOf(_childrenList, child), 1)[0];
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
            (try cast(child, AbstractHierarchyObject) catch(e:Dynamic) null).setParent(this);
        }
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function remove(child : IHierarchyObject, dispose : Bool = false) : IHierarchyObjectContainer
    {
        var childIndex : Int = Lambda.indexOf(_childrenList, child);
        
        if (childIndex != -1)
        {
            _childrenList.splice(childIndex, 1)[0];
            
            if (dispose)
            {
                child.dispose();
            }
            else
            {
                (try cast(child, AbstractHierarchyObject) catch(e:Dynamic) null).setParent(null);
            }
        }
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeAll(dispose : Bool = false) : IHierarchyObjectContainer
    {
        for (child in _childrenList)
        {
            if (dispose)
            {
                if (Std.is(child, IHierarchyObjectContainer))
                {
                    (try cast(child, IHierarchyObjectContainer) catch(e:Dynamic) null).disposeWithAllChildren();
                }
                else
                {
                    child.dispose();
                }
            }
            else
            {
                (try cast(child, AbstractHierarchyObject) catch(e:Dynamic) null).setParent(null);
            }
        }
        
        if (_childrenList != null)
        {
            _childrenList.splice(0, _childrenList.length);
        }
        
        return this;
    }
    
    /**
		 * Disposes object and removes all children, but doesn't dispose them.
		 */
    override public function dispose() : Void
    {
        removeAll();
        
        _childrenList = null;
        
        super.dispose();
    }
    
    /**
		 * @inheritDoc
		 */
    public function onMessageBubbled(message : IMessage) : Bool
    {
        handleMessage(message);
        
        return true;
    }
    
    /**
		 * @inheritDoc
		 */
    public function disposeWithAllChildren() : Void
    {
        removeAll(true);
        
        _childrenList = null;
        
        super.dispose();
    }
    
    /**
		 * @inheritDoc
		 */
    private function get_children() : Array<Dynamic>
    {
        return _childrenList;
    }
    
    /**
		 * @inheritDoc
		 */
    public function dispatchMessageToChildren(message : IMessage) : Void
    {
        for (child in _childrenList)
        {
            if (message.previousTarget != child)
            {
                if (Std.is(child, IHierarchyObjectContainer))
                {
                    (try cast(child, IHierarchyObjectContainer) catch(e:Dynamic) null).dispatchMessageToChildren(message);
                }
                else if (Std.is(child, IHierarchyObject))
                {
                    child.handleMessage(message);
                }
            }
        }
    }
    
    /**
		 * @inheritDoc
		 */
    public function contains(child : IHierarchyObjectImmutable) : Bool
    {
        return children && Lambda.indexOf(children, child) != -1;
    }

    public function new()
    {
        super();
    }
}
