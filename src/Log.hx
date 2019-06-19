package ;
/**
 * Created by Anton Nefjodov on 29.04.2016.
 */

/**
 * Class for log
 */
@:final class ClassForLog
{
    /**
	 * Show detailed logs.
	 * @param args Arguments to print out
	 */
    public function log(args : Array<Dynamic> = null) : Void
    {
//        if (Capabilities.isDebugger)
//        {

//            trace("[" + new Error().stack.split("\n")[2].split("at ")[1].split("/")[0] + "]: " + args);
//        }
//        else
//        {
//            trace(args);
//        }
    }

    public function new()
    {
        var e:Error = new Error();
    }
}

