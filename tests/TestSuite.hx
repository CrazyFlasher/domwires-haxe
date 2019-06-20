import massive.munit.TestSuite;

import com.domwires.core.common.DisposableTest;
import com.domwires.core.common.EnumTest;
import com.domwires.core.factory.AppFactoryTest;
import com.domwires.core.mvc.context.AbstractContextTest;
import com.domwires.core.mvc.context.CommandMapperTest;
import com.domwires.core.mvc.hierarchy.HierarchyObjectContainerTest;
import com.domwires.core.mvc.hierarchy.HierarchyObjectTest;
import com.domwires.core.mvc.message.BubblingMessageTest;
import com.domwires.core.mvc.message.MessageDispatcherTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestSuite extends massive.munit.TestSuite
{
	public function new()
	{
		super();

		add(com.domwires.core.common.DisposableTest);
		add(com.domwires.core.common.EnumTest);
		add(com.domwires.core.factory.AppFactoryTest);
		add(com.domwires.core.mvc.context.AbstractContextTest);
		add(com.domwires.core.mvc.context.CommandMapperTest);
		add(com.domwires.core.mvc.hierarchy.HierarchyObjectContainerTest);
		add(com.domwires.core.mvc.hierarchy.HierarchyObjectTest);
		add(com.domwires.core.mvc.message.BubblingMessageTest);
		add(com.domwires.core.mvc.message.MessageDispatcherTest);
	}
}
