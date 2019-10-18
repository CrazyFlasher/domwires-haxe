/**
 * Created by Anton Nefjodov on 30.05.2016.
 */
package com.domwires.core.mvc.command;

class AbstractCommand implements ICommand
{
    private var _logExecution : Bool;

    public function execute() : Void
    {
    }

    private function new()
    {
    }
}

