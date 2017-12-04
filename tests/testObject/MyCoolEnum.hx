/**
 * Created by Anton Nefjodov on 2.04.2016.
 */
package testObject;

import com.domwires.core.common.Enum;

class MyCoolEnum extends Enum
{
    public static var PREVED : MyCoolEnum = new MyCoolEnum("preved");
    public static var BOGA : MyCoolEnum = new MyCoolEnum("boga");
    public static var SHALOM : MyCoolEnum = new MyCoolEnum("shalom");

    public function new(name : String)
    {
        super(name);
    }
}

