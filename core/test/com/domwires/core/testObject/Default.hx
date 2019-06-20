/**
 * Created by Anton Nefjodov on 16.06.2016.
 */
package com.domwires.core.testObject;

@:rtti
class Default implements IDefault
{
	public var result(get, never):Int;

	private function get_result():Int
	{
		return 123;
	}

	public function new()
	{
	}
}

