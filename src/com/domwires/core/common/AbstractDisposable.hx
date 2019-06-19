/**
 * Created by Anton Nefjodov on 30.01.2016.
 */
package com.domwires.core.common;

import flash.errors.Error;

/**
	 * Any object that need to be disposed to free memory can extends this class.
	 */
class AbstractDisposable implements IDisposable
{
    public var isDisposed(get, never) : Bool;

    private var _isDisposed : Bool;
    
    /**
		 * @inheritDoc
		 */
    public function dispose() : Void
    {
        if (_isDisposed)
        {
            log("Object already disposed!");
            throw new Error("Object already disposed!");
        }
        
        _isDisposed = true;
    }
    
    /**
		 * @inheritDoc
		 */
    private function get_isDisposed() : Bool
    {
        return _isDisposed;
    }

    public function new()
    {
    }
}

