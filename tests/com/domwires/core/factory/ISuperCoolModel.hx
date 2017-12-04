/**
 * Created by CrazyFlasher on 18.11.2016.
 */
package com.domwires.core.factory;

import com.domwires.core.mvc.model.IModel;

interface ISuperCoolModel extends IModel
{
    
    var value(get, never) : Int;    
    var def(get, never) : IDefault;    
    var object(get, never) : Dynamic;    
    var array(get, never) : Array<Dynamic>;

    function getMyBool() : Bool
    ;
    function getCoolValue() : Int
    ;
}

