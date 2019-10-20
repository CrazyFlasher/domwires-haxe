package com.domwires.core.mvc.command;

/**
 * Checks, if command can be executed.
 */
import hex.di.IInjectorAcceptor;

interface IGuards extends IInjectorAcceptor
{
    /**
     * Returns true, if all conditions suit, and command can be executed.
     */
    var allows(get, never):Bool;
}