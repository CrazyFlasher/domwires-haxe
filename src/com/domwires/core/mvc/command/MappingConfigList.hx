package com.domwires.core.mvc.command;

class MappingConfigList
{
    private var list:Array<MappingConfig>;

    public function new()
    {
        list = [];
    }

    @:allow(com.domwires.core.mvc.command)
    private function push(item:MappingConfig):Void
    {
        list.push(item);
    }

    /**
     * @see com.domwires.core.mvc.command.MappingConfig
     * @param value
     */
    public function addGuards(value:Class<IGuards>):MappingConfigList
    {
        var mappingConfig:MappingConfig;

        for (mappingConfig in list)
        {
            mappingConfig.addGuards(value);
        }

        return this;
    }

    /**
     * @see com.domwires.core.mvc.command.MappingConfig
     * @param value
     */
    public function addGuardsNot(value:Class<IGuards>):MappingConfigList
    {
        for (mappingConfig in list)
        {
            mappingConfig.addGuardsNot(value);
        }

        return this;
    }
}