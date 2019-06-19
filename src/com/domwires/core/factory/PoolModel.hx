/**
 * Created by Anton Nefjodov on 21.05.2016.
 */
package com.domwires.core.factory;


class PoolModel
{
    private var list : Array<Dynamic> = [];
    private var capacity : Int;
    
    private var currentIndex : Int;
    private var factory : AppFactory;
    
    @:allow(com.domwires.core.factory)
    private function new(factory : AppFactory, capacity : Int)
    {
        this.factory = factory;
        this.capacity = capacity;
    }
    
    @:allow(com.domwires.core.factory)
    private function get(type : Class<Dynamic>) : Dynamic
    {
        var instance : Dynamic;
        
        if (list.length < capacity)
        {
            instance = factory.getNewInstance(type);
            list.push(instance);
        }
        else
        {
            instance = list[currentIndex];
            
            currentIndex++;
            
            if (currentIndex == capacity)
            {
                currentIndex = 0;
            }
        }
        
        return instance;
    }
    
    @:allow(com.domwires.core.factory)
    private function dispose() : Void
    {
        list = null;
        factory = null;
    }
}

