/**
 * Created by CrazyFlasher on 18.11.2016.
 */
package com.domwires.core.testObject;

import com.domwires.core.mvc.model.IModel;
import com.domwires.core.testObject.IDefault;

interface ISuperCoolModel extends IModel
{
	var value(get, never):Int;
	var def(get, never):IDefault;
	var object(get, never):Dynamic;
	var array(get, never):Array<Dynamic>;

	function getMyBool():Bool;
	function getCoolValue():Int;
}

