package com.domwires.core.mvc.mediator;

import com.domwires.core.mvc.hierarchy.IHierarchyObjectContainer;

/**
 * Container for mediators.
 */
interface IMediatorContainer extends IMediatorContainerImmutable extends IMediator extends IHierarchyObjectContainer
{
    /**
     * @return list of mediators in current container.
     */
    var mediatorList(get, never):Array<IMediator>;

	/**
     * Adds mediator to current container.
     * @param mediator
     */
	function addMediator(mediator:IMediator):IMediatorContainer;

	/**
     * Removes mediator from current container.
     * @param mediator
     * @param dispose
     */
	function removeMediator(mediator:IMediator, dispose:Bool = false):IMediatorContainer;

	/**
     * Removes all mediators from current container.
     * @param dispose
     */
	function removeAllMediators(dispose:Bool = false):IMediatorContainer;
}

