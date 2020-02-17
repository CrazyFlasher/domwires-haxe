package mock.mvc.hierarchy;

import com.domwires.core.mvc.hierarchy.HierarchyObjectContainer;

class MockHierarchyObjectContainer extends HierarchyObjectContainer
{
    private var value:Bool;

    override public function dispose():Void
    {
        value = true;

        super.dispose();
    }

    public function getValue():Bool
    {
        return value;
    }
}
