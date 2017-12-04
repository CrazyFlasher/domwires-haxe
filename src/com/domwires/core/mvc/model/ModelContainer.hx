/**
 * Created by Anton Nefjodov on 26.01.2016.
 */
package com.domwires.core.mvc.model;

import com.domwires.core.mvc.hierarchy.HierarchyObjectContainer;
import com.domwires.core.mvc.hierarchy.NsHierarchy;

class ModelContainer extends HierarchyObjectContainer implements IModelContainer
{
    public var numModels(get, never) : Int;
    public var modelList(get, never) : Array<Dynamic>;

    /**
		 * @inheritDoc
		 */
    public function addModel(model : IModel) : IModelContainer
    {
        add(model);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeModel(model : IModel, dispose : Bool = false) : IModelContainer
    {
        remove(model, dispose);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeAllModels(dispose : Bool = false) : IModelContainer
    {
        removeAll(dispose);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    private function get_numModels() : Int
    {
        return (children != null) ? children.length : 0;
    }
    
    /**
		 * @inheritDoc
		 */
    public function containsModel(model : IModelImmutable) : Bool
    {
        return contains(model);
    }
    
    /**
		 * @inheritDoc
		 */
    private function get_modelList() : Array<Dynamic>
    //better to return copy, but in sake of performance, we do that way.
    {
        
        return children;
    }

    public function new()
    {
        super();
    }
}

