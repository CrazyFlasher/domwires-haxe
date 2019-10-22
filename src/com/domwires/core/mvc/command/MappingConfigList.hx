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
     * @return
     */
    public function addGuards(value:Class<Dynamic>):MappingConfigList
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
     * @return
     */
    public function addGuardsNot(value:Class<Dynamic>):MappingConfigList
    {
        for (mappingConfig in list)
        {
            mappingConfig.addGuardsNot(value);
        }

        return this;
    }
}