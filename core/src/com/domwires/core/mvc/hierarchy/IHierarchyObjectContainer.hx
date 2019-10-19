package com.domwires.core.mvc.hierarchy;

import com.domwires.core.mvc.message.IBubbleMessageHandler;
import com.domwires.core.mvc.message.IMessage;

/**
 * Container of <code>IHierarchyObject</code>'s
 */
interface IHierarchyObjectContainer extends IHierarchyObjectContainerImmutable extends IHierarchyObject extends IBubbleMessageHandler
{
    /**
     * Returns all children of current container.
     */
    var children(get, never):Array<IHierarchyObject>;

    /**
     * Adds object to hierarchy. Object becomes a part of hierarchy branch.
     * @param child
     * @param index
     * @return
     */
    function add(child:IHierarchyObject, index:Int = -1):IHierarchyObjectContainer;

    /**
     * Removes object from hierarchy.
     * @param child
     * @param dispose
     * @return
     */
    function remove(child:IHierarchyObject, dispose:Bool = false):IHierarchyObjectContainer;

    /**
     * Removes all objects from hierarchy.
     * @param dispose
     * @return
     */
    function removeAll(dispose:Bool = false):IHierarchyObjectContainer;

    /**
     * Disposes current container and its children.
     */
    function disposeWithAllChildren():Void;

    /**
     * Sends message to children.
     * @param message
     * @return
     */
    function dispatchMessageToChildren(message:IMessage):Void;
}

