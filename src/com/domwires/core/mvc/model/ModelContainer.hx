package com.domwires.core.mvc.model;

import com.domwires.core.mvc.hierarchy.HierarchyObjectContainer;
import com.domwires.core.utils.ArrayUtils;

class ModelContainer extends HierarchyObjectContainer implements IModelContainer
{
	public var numModels(get, never):Int;

	public var modelList(get, never):Array<IModel>;
	public var modelListImmutable(get, never):Array<IModelImmutable>;

	private var _modelList:Array<IModel> = [];
	private var _modelListImmutable:Array<IModelImmutable> = [];

	public function addModel(model:IModel):IModelContainer
	{
		add(model);

		_modelList.push(model);
		_modelListImmutable.push(model);

		return this;
	}

	public function removeModel(model:IModel, dispose:Bool = false):IModelContainer
	{
		remove(model, dispose);

		_modelList.remove(model);
		_modelListImmutable.remove(model);

		return this;
	}

	public function removeAllModels(dispose:Bool = false):IModelContainer
	{
		removeAll(dispose);

		ArrayUtils.clear(_modelList);
		ArrayUtils.clear(_modelListImmutable);

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
		return _modelList;
	}

	private function get_modelListImmutable():Array<IModelImmutable>
		//better to return copy, but in sake of performance, we do that way.
	{
		return _modelListImmutable;
	}

	public function new()
	{
		super();
	}
}

