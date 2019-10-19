package com.domwires.core.mvc.message;

interface IMessage
{
    var type(get, never):EnumValue;
    var data(get, never):Dynamic;
    var bubbles(get, never):Bool;
    var target(get, never):Dynamic;
    var currentTarget(get, never):Dynamic;
    var previousTarget(get, never):Dynamic;
}

