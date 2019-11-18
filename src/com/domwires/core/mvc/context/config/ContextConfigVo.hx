package com.domwires.core.mvc.context.config;


/**
 * <code>IContext</code> configuration value object.
 */
class ContextConfigVo
{
    public var forwardMessageFromMediatorsToModels(get, never):Bool;
    public var forwardMessageFromMediatorsToMediators(get, never):Bool;
    public var forwardMessageFromModelsToMediators(get, never):Bool;
    public var forwardMessageFromModelsToModels(get, never):Bool;

    @:allow(com.domwires.core.mvc.context.config)
    private var _forwardMessageFromMediatorsToModels:Bool;

    @:allow(com.domwires.core.mvc.context.config)
    private var _forwardMessageFromMediatorsToMediators:Bool;

    @:allow(com.domwires.core.mvc.context.config)
    private var _forwardMessageFromModelsToMediators:Bool;

    @:allow(com.domwires.core.mvc.context.config)
    private var _forwardMessageFromModelsToModels:Bool;

    /**
     * @return true, if messages bubbled up from Mediators should be forwarded to models.
     */
    private function get_forwardMessageFromMediatorsToModels():Bool
    {
        return _forwardMessageFromMediatorsToModels;
    }

    /**
     * @return true, if messages bubbled up from Mediators should be forwarded to Mediators.
     */
    private function get_forwardMessageFromMediatorsToMediators():Bool
    {
        return _forwardMessageFromMediatorsToMediators;
    }

    /**
     * @return true, if messages bubbled up from models should be forwarded to Mediators.
     */
    private function get_forwardMessageFromModelsToMediators():Bool
    {
        return _forwardMessageFromModelsToMediators;
    }

    /**
     * @return true, if messages bubbled up from models should be forwarded to models.
     */
    private function get_forwardMessageFromModelsToModels():Bool
    {
        return _forwardMessageFromModelsToModels;
    }

    @:allow(com.domwires.core.mvc.context.config.ContextConfigVoBuilder)
    private function new()
    {
    }
}

