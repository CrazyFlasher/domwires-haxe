package com.domwires.core.utils;

class ArrayUtils
{
    public static function clear(array:Array<Dynamic>):Void
    {
        if (array == null) return;

        while (array.length > 0)
        {
            array.pop();
        }
    }

    public static function isLast(array:Array<Dynamic>, element:Dynamic):Bool
    {
        return array.indexOf(element) == array.length - 1;
    }
}
