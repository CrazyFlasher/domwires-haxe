/**
 * Created by CrazyFlasher on 17.11.2016.
 */
package com.domwires.core.factory;


/**
	 * Used by <code>IAppFactory</code> to create new instances, map types and inject dependencies via json config.
	 * See last example in <code>IAppFactory</code>
	 * @see IAppFactory#appendMappingConfig
	 */
class MappingConfigDictionary extends haxe.ds.ObjectMap<Dynamic, Dynamic>
{
    public function new(json : Dynamic)
    {
        super();
        if (json != null)
        {
            var key : Dynamic;
            for (key in Reflect.fields(json))
            {
                Reflect.setField(this, Std.string(key), new DependencyVo(Reflect.field(json, Std.string(key))));
            }
        }
    }
}

