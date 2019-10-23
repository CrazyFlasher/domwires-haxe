package com.domwires.core.utils;

import haxe.io.Error;

class ArrayUtils
{
    /**
    * Clears array.
    * @param array input array
    **/
    public static function clear<T>(array:Array<T>):Void
    {
        if (array == null) throw Error.Custom("Array is null!");

        #if(js || flash)
      	    untyped array.length = 0;
        #else
            while (array.length > 0)
            {
                array.pop();
            }
        #end
    }

    /**
    * Checks if element is the last in input array.
    * @param array input array
    * @param element element to check
    * @return true, if element is the last
    **/
    public static function isLast<T>(array:Array<T>, element:Dynamic):Bool
    {
        if (array == null) throw Error.Custom("Array is null!");

        return array.length != 0 && array.lastIndexOf(element) == array.length - 1;
    }
}
