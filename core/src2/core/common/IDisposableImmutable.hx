package com.domwires.core.common;

/**
 * @see com.domwires.core.common.IDisposable
 */
interface IDisposableImmutable
{

    /**
     * Returns true/false if object has already been disposed.
     */
    var isDisposed(get, never):Bool;
}

