package com.domwires.core.mvc.context.config;

/**
 * <code>ContextConfigVo</code> builder.
 */
class ContextConfigVoBuilder
{
    /**
     * If bubbled up messages from views should be forwarded to models.
     */
    public var forwardMessageFromViewsToModels:Bool;

    /**
     * If bubbled up messages from views should be forwarded to views.
     */
    public var forwardMessageFromViewsToViews:Bool = true;

    /**
     * If bubbled up messages from models be forwarded to views.
     */
    public var forwardMessageFromModelsToViews:Bool = true;

    /**
     * If bubbled up messages from models be forwarded to models.
     */
    public var forwardMessageFromModelsToModels:Bool;

    /**
     * Builds and returns new <code>ContextConfigVo</code> instance.
     * @return
     */
    public function build():ContextConfigVo
    {
        var config:ContextConfigVo = new ContextConfigVo();

        config._forwardMessageFromModelsToModels = forwardMessageFromModelsToModels;
        config._forwardMessageFromModelsToViews = forwardMessageFromModelsToViews;
        config._forwardMessageFromViewsToViews = forwardMessageFromViewsToViews;
        config._forwardMessageFromViewsToModels = forwardMessageFromViewsToModels;

        return config;
    }

    public function new()
    {
    }
}

