/**
 * Created by CrazyFlasher on 28.11.2016.
 */
package com.domwires.core.mvc.command;


/**
	 * @see com.domwires.core.mvc.command.IGuards
	 */
class AbstractGuards implements IGuards
{
    public var allows(get, never) : Bool;

    /**
		 * @inheritDoc
		 */
    private function get_allows() : Bool
    {
        return false;
    }

    public function new()
    {
    }
}

