package com.domwires.core.mvc.command;

class AbstractCommand implements ICommand
{
    private var _logExecution : Bool;

    public function execute() : Void
    {
    }

    @:allow(com.domwires.core.mvc.command.CommandMapper)
    private function new()
    {
    }
}

