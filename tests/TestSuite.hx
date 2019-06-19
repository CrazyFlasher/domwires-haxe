package ;
/**
 * Created by Anton Nefjodov on 2.02.2016.
 */
import com.domwires.core.common.DisposableTest;
import com.domwires.core.factory.AppFactoryTest;
import com.domwires.core.mvc.context.AbstractContextTest;
import com.domwires.core.mvc.context.CommandMapperTest;
import com.domwires.core.mvc.hierarchy.HierarchyObjectContainerTest;
import com.domwires.core.mvc.hierarchy.HierarchyObjectTest;
import com.domwires.core.mvc.message.BubblingMessageTest;
import com.domwires.core.mvc.message.MessageDispatcherTest;

class TestSuite
{
    static function main()
    {
        var r = new haxe.unit.TestRunner();

        r.add(new BubblingMessageTest());
        r.add(new DisposableTest());
        r.add(new HierarchyObjectContainerTest());
        r.add(new HierarchyObjectTest());
        r.add(new MessageDispatcherTest());
        r.add(new AppFactoryTest());
        r.add(new CommandMapperTest());
        r.add(new AbstractContextTest());

        r.run();
    }
}

