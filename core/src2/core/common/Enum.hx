/**
 * Created by Anton Nefjodov on 2.04.2016.
 */
package com.domwires.core.common;


/**
	 * Abstract enum class.
	 */
class Enum
{
    public var name(get, never) : String;

    private var _name : String;
    
    /**
		 * Creates new enum.
		 * @param name
		 */
    public function new(name : String)
    {
        _name = name;
    }
    
    /**
		 * Returns enum name.
		 */
    private function get_name() : String
    {
        return _name;
    }
    
    public function toString() : String
    {
        return _name;
    }
}

