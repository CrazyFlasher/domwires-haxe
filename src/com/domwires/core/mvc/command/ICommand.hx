/**
 * Created by Anton Nefjodov on 27.05.2016.
 */
package com.domwires.core.mvc.command;


/**
	 * Command (or service) that operates on provided (injected) models.
	 */
interface ICommand
{

    /**
		 * Executes command.
		 */
    function execute() : Void
    ;
}

