/**
 * Created by CrazyFlasher on 28.11.2016.
 */
package com.domwires.core.mvc.command;


class MappingConfig
{
    private var commandClass(get, never) : Class<Dynamic>;
    private var once(get, never) : Bool;
    private var data(get, never) : Dynamic;
    private var guardList(get, never) : Array<Class<Dynamic>>;

    private var _commandClass : Class<Dynamic>;
    private var _data : Dynamic;
    private var _once : Bool;
    private var _guardList : Array<Class<Dynamic>>;
    
    public function new(commandClass : Class<Dynamic>, data : Dynamic, once : Bool)
    {
        _commandClass = commandClass;
        _data = data;
        _once = once;
    }
    
    /**
		 * Class, that implements <code>IGuards</code> interface.
		 * @see com.domwires.core.mvc.command.IGuards
		 * @param value
		 * @return
		 */
    public function addGuards(value : Class<Dynamic>) : MappingConfig
    {
        if (_guardList == null)
        {
            _guardList = [];
        }
        _guardList.push(value);
        
        return this;
    }
    
    @:allow(com.domwires.core.mvc.command)
    private function get_commandClass() : Class<Dynamic>
    {
        return _commandClass;
    }
    
    @:allow(com.domwires.core.mvc.command)
    private function get_once() : Bool
    {
        return _once;
    }
    
    @:allow(com.domwires.core.mvc.command)
    private function get_data() : Dynamic
    {
        return _data;
    }
    
    @:allow(com.domwires.core.mvc.command)
    private function get_guardList() : Array<Class<Dynamic>>
    {
        return _guardList;
    }
}

