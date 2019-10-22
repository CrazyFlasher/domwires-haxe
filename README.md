###### Warning! This is a early alpha version. Use at your own risk :)

## DomWires [![Build Status](https://travis-ci.org/CrazyFlasher/domwires-haxe.svg?branch=dev)](https://travis-ci.org/CrazyFlasher/domwires-haxe)
Flexible and extensible MVC framework ported from [ActionScript 3 version](https://github.com/CrazyFlasher/domwires-as3)

### Features
* Splitting logic from visual part
* Immutable interfaces are separated from mutable, for safe usage of read-only models (for example in views)
* Possibility to use many implementations for interface easily
* Fast communication among components using [IMessageDispatcher](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/mvc/message/IMessageDispatcher.html)
* Object instantiation with dependencies injections using cool [IAppFactory](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/factory/IAppFactory.html)
* Possibility to specify dependencies in config and pass it to [IAppFactory](http://188.166.108.195/projects/domwires-haxe/docs/com/domwires/core/factory/IAppFactory.html)
* Easy object pooling management
* Custom message bus (event bus) for easy and strict communication among objects

***

### Minimum requirements
* Haxe 4.0.0-rc5 or higher

***

- [HaxeDoc](http://188.166.108.195/projects/domwires-haxe/docs)