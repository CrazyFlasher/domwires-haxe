package com.domwires.core.mvc.model;

import com.domwires.core.mvc.hierarchy.HierarchyObjectContainer;

class ModelContainer extends HierarchyObjectContainer implements IModelContainer
{
	public var numModels(get, never):Int;

	public var modelList(get, never):Array<IModel>;
	public var modelListImmutable(get, never):Array<IModelContainerImmutable>;

	public function addModel(model:IModel):IModelContainer
	{
		add(model);

		return this;
	}

	public function removeModel(model:IModel, dispose:Bool = false):IModelContainer
	{
		remove(model, dispose);

		return this;
	}

	public function removeAllModels(dispose:Bool = false):IModelContainer
	{
		removeAll(dispose);

		return this;
	}

	private function get_numModels():Int
	{
		return (children != null) ? children.length : 0;
	}

	public function containsModel(model:IModelImmutable):Bool
	{
		return contains(model);
	}

	private function get_modelList():Array<IModel>
		//better to return copy, but in sake of performance, we do that way.
	{
		return children;
	}

	private function get_modelListImmutable():Array<IModelImmutable>
		//better to return copy, but in sake of performance, we do that way.
	{
		return childrenImmutable;
	}

	public function new()
	{
		super();
	}
}

