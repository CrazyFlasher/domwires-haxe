package com.domwires.core.mvc.command;

class AbstractGuards implements IGuards
{
    public var allows(get, never):Bool;

    private function get_allows():Bool
    {
        return false;
    }

    @:allow(com.domwires.core.mvc.command.CommandMapper)
    private function new()
    {
    }
}

