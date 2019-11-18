package com.domwires.core.mvc.mediator;

import haxe.ds.ReadOnlyArray;
import com.domwires.core.mvc.hierarchy.IHierarchyObjectContainerImmutable;

/**
 * @see com.domwires.core.mvc.mediator.IMediatorContainer
 */
interface IMediatorContainerImmutable extends IHierarchyObjectContainerImmutable
{

	/**
     * @return number of mediators in current container.
     */
	var numMediators(get, never):Int;

	/**
     * @return list of mediators in current container.
     */
	var mediatorListImmutable(get, never):ReadOnlyArray<IMediatorImmutable>;

	/**
     * @param mediator
     * @return true, if current container has provided mediator.
     */
	function containsMediator(mediator:IMediatorImmutable):Bool;
}

