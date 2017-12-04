/**
 * Created by Anton Nefjodov on 16.06.2016.
 */
package com.domwires.core.factory;


//default implementation
interface IDefault
{
    
    var result(get, never) : Int;

    private static var IDefault_static_initializer = {
        Default;
        true;
    }

}

