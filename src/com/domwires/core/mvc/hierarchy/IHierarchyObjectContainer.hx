package com.domwires.core.mvc.hierarchy;

import com.domwires.core.mvc.message.IBubbleMessageHandler;
import com.domwires.core.mvc.message.IMessage;

/**
 * Container of <code>IHierarchyObject</code>'s
 */
interface IHierarchyObjectContainer extends IHierarchyObjectContainerImmutable extends IHierarchyObject extends IBubbleMessageHandler
{
    /**
     * @return all children of current container.
     */
    var children(get, never):Array<IHierarchyObject>;

    /**
     * Adds object to hierarchy. Object becomes a part of hierarchy branch.
     * @param child
     * @param index
     * @return true if successfully added.
     */
    function add(child:IHierarchyObject, index:Int = -1):Bool;

    /**
     * Removes object from hierarchy.
     * @param child
     * @param dispose
     * @return true if successfully removed.
     */
    function remove(child:IHierarchyObject, dispose:Bool = false):Bool;

    /**
     * Removes all objects from hierarchy.
     * @param dispose
     */
    function removeAll(dispose:Bool = false):IHierarchyObjectContainer;

    /**
     * Sends message to children.
     * @param message
     */
    function dispatchMessageToChildren(message:IMessage):Void;
}

