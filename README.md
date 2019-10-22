## DomWires
Flexible and extensible MVC framework ported from [ActionScript 3 version](https://github.com/CrazyFlasher/domwires-as3)

### Features
* Splitting logic from visual part
* Immutable interfaces are separated from mutable, for safe usage of read-only models (for example in views)
* Possibility to use many implementations for interface easily
* Fast communication among components using [IMessageDispatcher](http://188.166.108.195/projects/domwires/core/doc/com/domwires/core/mvc/message/IMessageDispatcher.html)
* Object instantiation with dependencies injections using cool [IAppFactory](http://188.166.108.195/projects/domwires/core/doc/com/domwires/core/factory/IAppFactory.html#includeExamplesSummary)
* Possibility to specify dependencies in config and pass it to [IAppFactory](http://188.166.108.195/projects/domwires/core/doc/com/domwires/core/factory/IAppFactory.html#includeExamplesSummary)
* Easy object pooling management
* Custom message bus (event bus) for easy and strict communication among objects

***

### Minimum requirements
* Haxe 4.0.0 or higher

***

### Examples
* [simpleMVC](https://github.com/CrazyFlasher/domwires-as3/tree/master/examples/simpleMVC)

(Other primitive examples can be seen in [unit tests](https://github.com/CrazyFlasher/domwires-as3/tree/master/core/tests))

***

### Extensions
* [StarlingApp](https://github.com/CrazyFlasher/domwires-ext-starlingApp-as3) - extension that is useful to render visual stuff using Starling 2.x

***

- [Building from core source](https://github.com/CrazyFlasher/domwires-as3/wiki/Building-core-(Windows)/)
- [Building simpleMVC example from source](https://github.com/CrazyFlasher/domwires-as3/wiki/Building-simpleMVC-example-(Windows)/)
- [Latest SWC](http://188.166.108.195/projects/domwires/core/dw-core.swc)
- [ASDoc](http://188.166.108.195/projects/domwires/core/doc)