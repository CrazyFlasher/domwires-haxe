package com.domwires.core.common;

/**
 * @see com.domwires.core.common.IDisposable
 */
interface IDisposableImmutable
{

    /**
     * @return true if object has already been disposed.
     */
    var isDisposed(get, never):Bool;
}

