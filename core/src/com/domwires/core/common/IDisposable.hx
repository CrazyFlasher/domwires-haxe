package com.domwires.core.common;

import hex.di.IInjectorAcceptor;

interface IDisposable extends IDisposableImmutable extends IInjectorAcceptor
{

    /**
     * Removes all references, objects. After that object is ready to be cleaned by GC.
     */
    function dispose():Void;
}

