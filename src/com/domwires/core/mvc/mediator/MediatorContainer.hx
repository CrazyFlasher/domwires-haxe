package com.domwires.core.mvc.mediator;

import haxe.ds.ReadOnlyArray;
import com.domwires.core.utils.ArrayUtils;
import com.domwires.core.mvc.hierarchy.HierarchyObjectContainer;

class MediatorContainer extends HierarchyObjectContainer implements IMediatorContainer
{
	public var numMediators(get, never):Int;

	public var mediatorList(get, never):Array<IMediator>;
	public var mediatorListImmutable(get, never):ReadOnlyArray<IMediatorImmutable>;

	private var _mediatorList:Array<IMediator> = [];
	private var _mediatorListImmutable:Array<IMediatorImmutable> = [];

	public function addMediator(mediator:IMediator):IMediatorContainer
	{
		add(mediator);

		_mediatorList.push(mediator);
		_mediatorListImmutable.push(mediator);

		return this;
	}

	public function removeMediator(mediator:IMediator, dispose:Bool = false):IMediatorContainer
	{
		remove(mediator, dispose);

		_mediatorList.remove(mediator);
		_mediatorListImmutable.remove(mediator);

		return this;
	}

	public function removeAllMediators(dispose:Bool = false):IMediatorContainer
	{
		removeAll(dispose);

		ArrayUtils.clear(_mediatorList);
		ArrayUtils.clear(_mediatorListImmutable);

		return this;
	}

	private function get_numMediators():Int
	{
		return (children != null) ? children.length : 0;
	}

	public function containsMediator(mediator:IMediatorImmutable):Bool
	{
		return contains(mediator);
	}

	private function get_mediatorList():Array<IMediator>
	{
		return _mediatorList;
	}

    private function get_mediatorListImmutable():ReadOnlyArray<IMediatorImmutable>
    {
        return _mediatorListImmutable;
    }

	public function new()
	{
		super();
	}
}

