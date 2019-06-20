package com.domwires.core.mvc.message;

import com.domwires.core.common.Enum;

class Message implements IMessage {
    public var data(get, never):Dynamic;
    public var bubbles(get, never):Bool;
    public var target(get, never):Dynamic;
    public var currentTarget(get, never):Dynamic;
    public var previousTarget(get, never):Dynamic;
    public var type(get, never):Enum;

    @:allow(com.domwires.core.mvc.message)
    private var _data:Dynamic;
    @:allow(com.domwires.core.mvc.message)
    private var _bubbles:Bool;
    @:allow(com.domwires.core.mvc.message)
    private var _target:Dynamic;
    @:allow(com.domwires.core.mvc.message)
    private var _previousTarget:Dynamic;
    @:allow(com.domwires.core.mvc.message)
    private var _type:Enum;

    private var _currentTarget:Dynamic;

    @:allow(com.domwires.core.mvc.message)
    private function new(type:Enum, data:Dynamic = null, bubbles:Bool = true) {
        _type = type;
        _data = data;
        _bubbles = bubbles;
    }

    @:allow(com.domwires.core.mvc.message)
    private function setCurrentTarget(value:Dynamic):Dynamic {
        _previousTarget = _currentTarget;

        _currentTarget = value;

        return _currentTarget;
    }

    private function get_type():Enum {
        return _type;
    }

    private function get_data():Dynamic {
        return _data;
    }

    private function get_bubbles():Bool {
        return _bubbles;
    }

    private function get_target():Dynamic {
        return _target;
    }

    private function get_currentTarget():Dynamic {
        return _currentTarget;
    }

    private function get_previousTarget():Dynamic {
        return _previousTarget;
    }
}
