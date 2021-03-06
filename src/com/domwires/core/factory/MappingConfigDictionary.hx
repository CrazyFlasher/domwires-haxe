package com.domwires.core.factory;

/**
* Used by <code>IAppFactory</code> to create new instances, map types and inject dependencies via json config.
* See last example in <code>IAppFactory</code>
* @see IAppFactory#appendMappingConfig
*/
import com.domwires.core.factory.DependencyVo;
import Reflect;

class MappingConfigDictionary
{
	public var map(get, never):Map<String, DependencyVo>;

	private var _map:Map<String, DependencyVo> = new Map();

	public function new(json:Dynamic)
	{
		if (json != null)
		{
			for (key in Reflect.fields(json))
			{
				_map.set(key, new DependencyVo(Reflect.field(json, key)));
			}
		}
	}

	private function get_map():Map<String, DependencyVo>
	{
		return _map;
	}
}

