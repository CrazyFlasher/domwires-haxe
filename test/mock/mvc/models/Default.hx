package mock.mvc.models;

class Default implements IDefault
{
	public var result(get, never):Int;

	private function get_result():Int
	{
		return 123;
	}
}
