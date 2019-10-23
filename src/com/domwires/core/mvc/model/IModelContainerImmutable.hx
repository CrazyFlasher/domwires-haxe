package com.domwires.core.mvc.model;

import haxe.ds.ReadOnlyArray;
import com.domwires.core.mvc.hierarchy.IHierarchyObjectContainerImmutable;

/**
 * @see com.domwires.core.mvc.model.IModelContainer
 */
interface IModelContainerImmutable extends IModelImmutable extends IHierarchyObjectContainerImmutable
{

	/**
     * @return number of models in current container.
     */
	var numModels(get, never):Int;

	/**
     * @return list of models in current container.
     */
	var modelListImmutable(get, never):ReadOnlyArray<IModelImmutable>;


	/**
     * @param model
     * @return true, if current container has provided model.
     */
	function containsModel(model:IModelImmutable):Bool;
}

