/**
 * Created by Anton Nefjodov on 10.06.2016.
 */
package com.domwires.core.mvc.message;

import com.domwires.core.common.Enum;

interface IMessage
{
    
    var type(get, never) : Enum;    
    var data(get, never) : Dynamic;    
    var bubbles(get, never) : Bool;    
    var target(get, never) : Dynamic;    
    var currentTarget(get, never) : Dynamic;    
    var previousTarget(get, never) : Dynamic;

}

