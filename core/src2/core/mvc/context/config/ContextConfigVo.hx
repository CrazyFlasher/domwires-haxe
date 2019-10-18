/**
 * Created by CrazyFlasher on 20.11.2016.
 */
package com.domwires.core.mvc.context.config;


/**
	 * <code>IContext</code> configuration value object.
	 */
class ContextConfigVo
{
    public var forwardMessageFromViewsToModels(get, never) : Bool;
    public var forwardMessageFromViewsToViews(get, never) : Bool;
    public var forwardMessageFromModelsToViews(get, never) : Bool;
    public var forwardMessageFromModelsToModels(get, never) : Bool;

    /**
		 * @private
		 */
    @:allow(com.domwires.core.mvc.context.config)
    private var _forwardMessageFromViewsToModels : Bool;
    /**
		 * @private
		 */
    @:allow(com.domwires.core.mvc.context.config)
    private var _forwardMessageFromViewsToViews : Bool;
    /**
		 * @private
		 */
    @:allow(com.domwires.core.mvc.context.config)
    private var _forwardMessageFromModelsToViews : Bool;
    /**
		 * @private
		 */
    @:allow(com.domwires.core.mvc.context.config)
    private var _forwardMessageFromModelsToModels : Bool;
    
    /**
		 * Returns true, if messages bubbled up from views should be forwarded to models.
		 */
    private function get_forwardMessageFromViewsToModels() : Bool
    {
        return _forwardMessageFromViewsToModels;
    }
    
    /**
		 * Returns true, if messages bubbled up from views should be forwarded to views.
		 */
    private function get_forwardMessageFromViewsToViews() : Bool
    {
        return _forwardMessageFromViewsToViews;
    }
    
    /**
		 * Returns true, if messages bubbled up from models should be forwarded to views.
		 */
    private function get_forwardMessageFromModelsToViews() : Bool
    {
        return _forwardMessageFromModelsToViews;
    }
    
    /**
		 * Returns true, if messages bubbled up from models should be forwarded to models.
		 */
    private function get_forwardMessageFromModelsToModels() : Bool
    {
        return _forwardMessageFromModelsToModels;
    }

    public function new()
    {
    }
}

