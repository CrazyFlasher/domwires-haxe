/**
 * Created by CrazyFlasher on 6.11.2016.
 */
package com.domwires.core.common;


/**
	 * @see com.domwires.core.common.IDisposable
	 */
interface IDisposableImmutable
{
    
    /**
		 * Returns true/false if object has already been disposed.
		 */
    var isDisposed(get, never) : Bool;

}

