package com.domwires.core.mvc.model;

import com.domwires.core.mvc.hierarchy.IHierarchyObjectContainerImmutable;

/**
 * @see com.domwires.core.mvc.model.IModelContainer
 */
interface IModelContainerImmutable extends IModelImmutable extends IHierarchyObjectContainerImmutable
{

	/**
     * Returns number of models in current container.
     */
	var numModels(get, never):Int;

	/**
     * Returns list of models in current container.
     */
	var modelListImmutable(get, never):Array<IModelImmutable>;


	/**
     * Returns true, if current container has provided model.
     * @param model
     * @return
     */
	function containsModel(model:IModelImmutable):Bool;
}

