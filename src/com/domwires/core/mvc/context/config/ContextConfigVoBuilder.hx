package com.domwires.core.mvc.context.config;

/**
 * <code>ContextConfigVo</code> builder.
 */
class ContextConfigVoBuilder
{
    /**
     * If bubbled up messages from mediators should be forwarded to models.
     */
    public var forwardMessageFromMediatorsToModels:Bool;

    /**
     * If bubbled up messages from mediators should be forwarded to mediators.
     */
    public var forwardMessageFromMediatorsToMediators:Bool = true;

    /**
     * If bubbled up messages from models be forwarded to mediators.
     */
    public var forwardMessageFromModelsToMediators:Bool = true;

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
        config._forwardMessageFromModelsToMediators = forwardMessageFromModelsToMediators;
        config._forwardMessageFromMediatorsToMediators = forwardMessageFromMediatorsToMediators;
        config._forwardMessageFromMediatorsToModels = forwardMessageFromMediatorsToModels;

        return config;
    }

    public function new()
    {
    }
}

