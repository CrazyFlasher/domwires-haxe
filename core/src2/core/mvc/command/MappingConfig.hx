package com.domwires.core.mvc.command;

class MappingConfig
{
    public var commandClass(get, never):Class<Dynamic>;
    public var once(get, never):Bool;
    public var data(get, never):Dynamic;
    public var guardList(get, never):Array<Class<Dynamic>>;
    public var stopOnExecute(get, never):Bool;
    public var oppositeGuardList(get, never):Array<Class<Dynamic>>;

    private var _commandClass:Class<Dynamic>;
    private var _data:Dynamic;
    private var _once:Bool;
    private var _guardList:Array<Class<Dynamic>>;
    private var _oppositeGuardList:Array<Class<Dynamic>>;
    private var _stopOnExecute:Bool;

    public function new(commandClass:Class<Dynamic>, data:Dynamic, once:Bool, stopOnExecute:Bool = false)
    {
        _commandClass = commandClass;
        _data = data;
        _once = once;
        _stopOnExecute = stopOnExecute;
    }

    /**
     * Class, that implements <code>IGuards</code> interface.
     * @see com.domwires.core.mvc.command.IGuards
     * @param value
     * @return
     */
    public function addGuards(value:Class<Dynamic>):MappingConfig
    {
        if (_guardList == null)
        {
            _guardList = [];
        }
        _guardList.push(value);

        return this;
    }

    /**
     * Opposite guards
     * @see addGuards
     * @param value
     * @return
     */
    public function addGuardsNot(value:Class<Dynamic>):MappingConfig
    {
        if (_oppositeGuardList == null)
        {
            _oppositeGuardList = [];
        }
        _oppositeGuardList.push(value);

        return this;
    }

    @:allow(com.domwires.core.mvc.command)
    private function get_commandClass():Class<Dynamic>
    {
        return _commandClass;
    }

    @:allow(com.domwires.core.mvc.command)
    private function get_once():Bool
    {
        return _once;
    }

    @:allow(com.domwires.core.mvc.command)
    private function get_data():Dynamic
    {
        return _data;
    }

    @:allow(com.domwires.core.mvc.command)
    private function get_guardList():Array<Class<Dynamic>>
    {
        return _guardList;
    }

    private function get_stopOnExecute():Bool
    {
        return _stopOnExecute;
    }

    private function get_oppositeGuardList():Array<Class<Dynamic>>
    {
        return _oppositeGuardList;
    }
}