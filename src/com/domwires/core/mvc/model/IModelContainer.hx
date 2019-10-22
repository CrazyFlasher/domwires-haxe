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
     * @return
     */
	function addModel(model:IModel):IModelContainer;

	/**
     * Removes model from current container.
     * @param model
     * @param dispose
     * @return
     */
	function removeModel(model:IModel, dispose:Bool = false):IModelContainer;

	/**
     * Removes all models from current container.
     * @param dispose
     * @return
     */
	function removeAllModels(dispose:Bool = false):IModelContainer;

    /**
     * Returns list of models in current container.
     */
    var modelList(get, never):Array<IModel>;
}

