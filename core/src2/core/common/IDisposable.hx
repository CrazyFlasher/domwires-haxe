package com.domwires.core.common;

interface IDisposable extends IDisposableImmutable
{

    /**
     * Removes all references, objects. After that object is ready to be cleaned by GC.
     */
    function dispose():Void;
}

