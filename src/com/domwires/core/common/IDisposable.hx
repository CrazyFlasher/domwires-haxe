package com.domwires.core.common;

import hex.di.IInjectorContainer;

interface IDisposable extends IDisposableImmutable extends IInjectorContainer
{

    /**
     * Removes all references, objects. After that object is ready to be cleaned by GC.
     */
    function dispose():Void;
}