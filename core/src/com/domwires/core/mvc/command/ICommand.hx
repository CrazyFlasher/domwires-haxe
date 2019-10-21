package com.domwires.core.mvc.command;

/**
 * Command (or service) that operates on provided (injected) models.
 * For deep logging, create static constant values in your commands classes:
 * <code>public static const LOG_EXECUTION_SUCCESS:Boolean = true;</code>
 * Considered as true, if not specified.
 *
 * <code>public static const LOG_EXECUTION_FAIL:Boolean = false;</code>
 * Considered as false, if not specified.
 */
import hex.di.IInjectorContainer;

interface ICommand extends IInjectorContainer
{
	/**
      * Executes command.
     */
	function execute():Void;
}

