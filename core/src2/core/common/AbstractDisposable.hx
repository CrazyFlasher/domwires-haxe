package com.domwires.core.common;

import haxe.io.Error;

class AbstractDisposable implements IDisposable
{
    public var isDisposed(get, never):Bool;

    private var _isDisposed:Bool;

    public function dispose():Void
    {
        if (_isDisposed)
        {
            throw Error.Custom("Object already disposed!");
        }

        _isDisposed = true;
    }

    private function get_isDisposed():Bool
    {
        return _isDisposed;
    }

    private function new()
    {
    }
}

