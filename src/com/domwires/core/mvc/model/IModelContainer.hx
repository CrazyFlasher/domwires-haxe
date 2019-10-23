package com.domwires.core.mvc.model;

import com.domwires.core.mvc.hierarchy.IHierarchyObjectContainer;

/**
 * Container for models.
 */
interface IModelContainer extends IModelContainerImmutable extends IModel extends IHierarchyObjectContainer
{
	/**
     * Adds model to current container.
     * @param model
     */
	function addModel(model:IModel):IModelContainer;

	/**
     * Removes model from current container.
     * @param model
     * @param dispose
     */
	function removeModel(model:IModel, dispose:Bool = false):IModelContainer;

	/**
     * Removes all models from current container.
     * @param dispose
     */
	function removeAllModels(dispose:Bool = false):IModelContainer;

    /**
     * @return Returns list of models in current container.
     */
    var modelList(get, never):Array<IModel>;
}

