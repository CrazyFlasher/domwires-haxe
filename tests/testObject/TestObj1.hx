/**
 * Created by Anton Nefjodov on 30.05.2016.
 */
package testObject;


class TestObj1
{
    public var d(get, set) : Int;
    public var s(get, set) : String;

    private var _d : Int;
    private var _s : String;
    
    public function new()
    {
    }
    
    private function set_d(value : Int) : Int
    {
        _d = value;
        return value;
    }
    
    private function get_d() : Int
    {
        return _d;
    }
    
    private function get_s() : String
    {
        return _s;
    }
    
    private function set_s(value : String) : String
    {
        _s = value;
        return value;
    }
}

