/**
 * Created by Anton Nefjodov on 20.05.2016.
 */
package com.domwires.core.factory;

import flash.errors.Error;
import flash.errors.VerifyError;
import avmplus.DescribeTypeJSON;
import com.domwires.core.common.AbstractDisposable;

/**
	 * @see com.domwires.core.factory.IAppFactory
	 */
class AppFactory extends AbstractDisposable implements IAppFactory
{
    public var autoInjectDependencies(never, set) : Bool;
    public var verbose(never, set) : Bool;

    private static var injectionMap : haxe.ds.ObjectMap<Dynamic, Dynamic> = new haxe.ds.ObjectMap<Dynamic, Dynamic>()  /*Class, InjectionDataVo*/  ;
    private static var describeTypeJSON : DescribeTypeJSON = new DescribeTypeJSON();
    
    private var typeMapping : haxe.ds.ObjectMap<Dynamic, Dynamic> = new haxe.ds.ObjectMap<Dynamic, Dynamic>()  /*Class, Class*/  ;
    private var instanceMapping : haxe.ds.ObjectMap<Dynamic, Dynamic> = new haxe.ds.ObjectMap<Dynamic, Dynamic>()  /*Object, Class*/  ;
    private var pool : haxe.ds.ObjectMap<Dynamic, Dynamic> = new haxe.ds.ObjectMap<Dynamic, Dynamic>()  /*Class, PoolModel*/  ;
    
    /**
		 * Automatically injects dependencies to newly created instances, using <code>getInstance</code> method.
		 */
    private var _autoInjectDependencies : Bool = true;
    
    /**
		 * Prints out extra information to logs.
		 * Useful for debugging, but leaks performance.
		 */
    private var _verbose : Bool = false;
    
    /**
		 * @inheritDoc
		 */
    public function mapToType(type : Class<Dynamic>, to : Class<Dynamic>) : IAppFactory
    {
        if (to == null)
        {
            throw new Error("Cannot map type to null type!");
        }
        
        if (_verbose && typeMapping.get(type) != null)
        {
            log("Warning: type " + type + " is mapped to type " + typeMapping.get(type) + ". Remapping to " + to);
        }
        typeMapping.set(type, to);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function mapToValue(type : Class<Dynamic>, to : Dynamic, name : String = null) : IAppFactory
    {
        if (to == null)
        {
            throw new Error("Cannot map type to null value!");
        }
        
        var id : String = getId(type, name);
        
        if (_verbose && instanceMapping.get(id) != null)
        {
            log("Warning: type " + type + " is mapped to instance " + instanceMapping.get(id) + ". Remapping to " + to);
        }
        instanceMapping.set(id,   /*type is Boolean ? to.toString() : */  to);
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function hasTypeMappingForType(type : Class<Dynamic>, name : String = null) : Bool
    {
        return typeMapping.get(type) != null;
    }
    
    /**
		 * @inheritDoc
		 */
    public function hasValueMappingForType(type : Class<Dynamic>, name : String = null) : Bool
    {
        var id : String = getId(type, name);
        
        return instanceMapping.get(id) != null;
    }
    
    /**
		 * @inheritDoc
		 */
    public function unmapType(type : Class<Dynamic>) : IAppFactory
    {
        if (typeMapping.get(type) != null)
        {
            typeMapping.remove(type);
        }
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function unmapValue(type : Class<Dynamic>, name : String = null) : IAppFactory
    {
        var id : String = getId(type, name);
        
        if (instanceMapping.get(id) != null)
        {
            instanceMapping.remove(id);
        }
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function getInstance(type : Class<Dynamic>, constructorArgs : Dynamic = null, name : String = null) : Dynamic
    {
        if (name == null)
        {
            name = "";
        }
        
        var id : String = getId(type, name);
        
        var obj : Dynamic = getInstanceFromInstanceMap(id);
        
        if (obj != null)
        {
            return obj;
        }
        
        if (hasPoolForType(type))
        {
            if (_verbose && constructorArgs != null && constructorArgs.length > 0)
            {
                log("Warning: type " + type + " has registered pool. Ignoring constructorArgs.");
            }
            
            //Do not inject dependencies automatically to instance, that is taken from pool.
            //Call injectDependencies to inject manually.
            obj = getFromPool(type);
        }
        else
        {
            obj = getNewInstance(type, constructorArgs);
            
            if (obj != null)
            {
                if (_autoInjectDependencies)
                {
                    obj = injectDependencies(obj);
                }
                
                var injectionData : InjectionDataVo = getInjectionData(obj);
                if (injectionData.postConstructName != null)
                {
                    Reflect.field(obj, Std.string(injectionData.postConstructName))();
                }
            }
            //in case of getNewInstance returned null, try again using default implementation.
            else
            {
                
                obj = getInstance(type, constructorArgs);
            }
        }
        
        return obj;
    }
    
    private function getInstanceFromInstanceMap(id : String, require : Bool = false) : Dynamic
    {
        if (instanceMapping.get(id) != null)
        {
            return instanceMapping.get(id);
        }
        
        if (require)
        {
            throw new Error("Instance mapping for " + id + " not found!");
        }
        
        return null;
    }
    
    @:allow(com.domwires.core.factory)
    private function getNewInstance(type : Class<Dynamic>, constructorArgs : Dynamic = null) : Dynamic
    {
        var t : Class<Dynamic>;
        
        if (typeMapping.get(type) == null)
        {
            if (_verbose)
            {
                log("Warning: type " + type + " is not mapped to any other type. Creating new instance of " + type);
            }
            
            t = type;
        }
        else
        {
            t = typeMapping.get(type);
        }
        
        try
        {
            return returnNewInstance(t, constructorArgs);
        }
        catch (e : VerifyError)
        {
            var defImplClassName : String = Type.getClassName(type).replace(new as3hx.Compat.Regex('::I', "g"), ".");
            
            if (_verbose)
            {
                log("Warning: interface " + type + " is not mapped to any class. Trying to find default implementation " + defImplClassName);
            }
            mapToType(type, Type.getClass(Type.resolveClass(defImplClassName)));
            
            return null;
        }
    }
    
    private static function returnNewInstance(type : Class<Dynamic>, constructorArgs : Dynamic = null) : Dynamic
    {
        if (constructorArgs == null || (Std.is(constructorArgs, Array) && constructorArgs.length == 0))
        {
            return Type.createInstance(type, []);
        }
        
        if (Std.is(constructorArgs, Array))
        
        //TODO: find better solution{
            
            var _sw0_ = (constructorArgs.length);            

            switch (_sw0_)
            {
                case 1:return Type.createInstance(type, [Reflect.field(constructorArgs, Std.string(0))]);
                case 2:return Type.createInstance(type, [Reflect.field(constructorArgs, Std.string(0)), Reflect.field(constructorArgs, Std.string(1))]);
                case 3:return Type.createInstance(type, [Reflect.field(constructorArgs, Std.string(0)), Reflect.field(constructorArgs, Std.string(1)), Reflect.field(constructorArgs, Std.string(2))]);
                case 4:return Type.createInstance(type, [Reflect.field(constructorArgs, Std.string(0)), Reflect.field(constructorArgs, Std.string(1)), Reflect.field(constructorArgs, Std.string(2)), Reflect.field(constructorArgs, Std.string(3))]);
                case 5:return Type.createInstance(type, [Reflect.field(constructorArgs, Std.string(0)), Reflect.field(constructorArgs, Std.string(1)), Reflect.field(constructorArgs, Std.string(2)), Reflect.field(constructorArgs, Std.string(3)), Reflect.field(constructorArgs, Std.string(4))]);
                case 6:return Type.createInstance(type, [Reflect.field(constructorArgs, Std.string(0)), Reflect.field(constructorArgs, Std.string(1)), Reflect.field(constructorArgs, Std.string(2)), Reflect.field(constructorArgs, Std.string(3)), Reflect.field(constructorArgs, Std.string(4)), Reflect.field(constructorArgs, Std.string(5))]);
                case 7:return Type.createInstance(type, [Reflect.field(constructorArgs, Std.string(0)), Reflect.field(constructorArgs, Std.string(1)), Reflect.field(constructorArgs, Std.string(2)), Reflect.field(constructorArgs, Std.string(3)), Reflect.field(constructorArgs, Std.string(4)), Reflect.field(constructorArgs, Std.string(5)), Reflect.field(constructorArgs, Std.string(6))]);
                case 8:return Type.createInstance(type, [Reflect.field(constructorArgs, Std.string(0)), Reflect.field(constructorArgs, Std.string(1)), Reflect.field(constructorArgs, Std.string(2)), Reflect.field(constructorArgs, Std.string(3)), Reflect.field(constructorArgs, Std.string(4)), Reflect.field(constructorArgs, Std.string(5)), Reflect.field(constructorArgs, Std.string(6)), Reflect.field(constructorArgs, Std.string(7))]);
                case 9:return Type.createInstance(type, [Reflect.field(constructorArgs, Std.string(0)), Reflect.field(constructorArgs, Std.string(1)), Reflect.field(constructorArgs, Std.string(2)), Reflect.field(constructorArgs, Std.string(3)), Reflect.field(constructorArgs, Std.string(4)), Reflect.field(constructorArgs, Std.string(5)), Reflect.field(constructorArgs, Std.string(6)), Reflect.field(constructorArgs, Std.string(7)), Reflect.field(constructorArgs, Std.string(8))]);
                case 10:return Type.createInstance(type, [Reflect.field(constructorArgs, Std.string(0)), Reflect.field(constructorArgs, Std.string(1)), Reflect.field(constructorArgs, Std.string(2)), Reflect.field(constructorArgs, Std.string(3)), Reflect.field(constructorArgs, Std.string(4)), Reflect.field(constructorArgs, Std.string(5)), Reflect.field(constructorArgs, Std.string(6)), Reflect.field(constructorArgs, Std.string(7)), Reflect.field(constructorArgs, Std.string(8)), Reflect.field(constructorArgs, Std.string(9))]);
                default:throw new Error("getNewInstance supports maximum 10 constructor arguments.");
            }
        }
        
        return Type.createInstance(type, [constructorArgs]);
    }
    
    /**
		 * @inheritDoc
		 */
    public function registerPool(type : Class<Dynamic>, capacity : Int = 5) : IAppFactory
    {
        if (capacity == 0)
        {
            throw new Error("Capacity should be > 0!");
        }
        
        if (_verbose && pool.get(type) != null)
        {
            log("Pool " + type + " already registered! Call unregisterPool before.");
        }
        else
        {
            pool.set(type, new PoolModel(this, capacity));
        }
        
        return this;
    }
    
    private function getFromPool(type : Class<Dynamic>) : Dynamic
    {
        if (pool.get(type) == null)
        {
            throw new Error("Pool " + type + "is not registered! Call registerPool.");
        }
        
        return pool.get(type).get(type);
    }
    
    /**
		 * @inheritDoc
		 */
    public function unregisterPool(type : Class<Dynamic>) : IAppFactory
    {
        if (pool.get(type) != null)
        {
            pool.get(type).dispose();
            
            pool.remove(type);
        }
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function hasPoolForType(type : Class<Dynamic>) : Bool
    {
        return pool.get(type) != null;
    }
    
    /**
		 * @inheritDoc
		 */
    public function getSingleton(type : Class<Dynamic>) : Dynamic
    {
        if (!hasPoolForType(type))
        {
            registerPool(type, 1);
        }
        
        return getInstance(type);
    }
    
    /**
		 * @inheritDoc
		 */
    public function removeSingleton(type : Class<Dynamic>) : IAppFactory
    {
        if (hasPoolForType(type))
        {
            unregisterPool(type);
        }
        else if (_verbose)
        {
            log(type + " is not registered as singleton!");
        }
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function clearPools() : IAppFactory
    {
        for (poolModel/* AS3HX WARNING could not determine type for var: poolModel exp: EIdent(pool) type: haxe.ds.ObjectMap<Dynamic, Dynamic> */ in pool)
        {
            poolModel.dispose();
        }
        
        pool = new haxe.ds.ObjectMap<Dynamic, Dynamic>();
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function clearMappings() : IAppFactory
    {
        typeMapping = new haxe.ds.ObjectMap<Dynamic, Dynamic>();
        instanceMapping = new haxe.ds.ObjectMap<Dynamic, Dynamic>();
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function clear() : IAppFactory
    {
        clearPools();
        clearMappings();
        
        return this;
    }
    
    /**
		 * @inheritDoc
		 */
    public function injectDependencies(instance : Dynamic) : Dynamic
    {
        var instanceClass : Class<Dynamic> = instance;
        var injectionData : InjectionDataVo = getInjectionData(instanceClass);
        
        var objVar : String;
        var isOptional : Bool;
        var qualifiedName : String;
        
        for (objVar in Reflect.fields(injectionData.variables))
        {
            isOptional = injectionData.variables[objVar].optional;
            qualifiedName = injectionData.variables[objVar].qualifiedName;
            //				instance[objVar] = getAutowiredValue(injectionData.variables[objVar].qualifiedName, isOptional);
            try
            {
                Reflect.setField(instance, objVar, getInstanceFromInstanceMap(qualifiedName, !isOptional));
            }
            catch (e : Error)
            {
                throw new Error("Cannot inject all required dependencies to '");
            }
        }
        
        if (injectionData.postInjectName != null)
        {
            Reflect.field(instance, Std.string(injectionData.postInjectName))();
        }
        
        return instance;
    }
    
    private function getInjectionData(type : Class<Dynamic>) : InjectionDataVo
    {
        var mappedType : Class<Dynamic> = (typeMapping.get(type) != null) ? typeMapping.get(type) : type;
        
        var injectionData : InjectionDataVo = injectionMap.get(mappedType);
        
        if (injectionData == null)
        {
            injectionData = new InjectionDataVo();
            
            var dtJson : Dynamic = describeTypeJSON.getInstanceDescription(mappedType);
            
            var metadata : Dynamic;
            var method : Dynamic;
            var variable : Dynamic;
            var isOptional : Bool;
            
            for (method/* AS3HX WARNING could not determine type for var: method exp: EField(EField(EIdent(dtJson),traits),methods) type: null */ in dtJson.traits.methods)
            {
                for (metadata/* AS3HX WARNING could not determine type for var: metadata exp: EField(EIdent(method),metadata) type: null */ in method.metadata)
                {
                    if (injectionData.postConstructName &&injectionData.postInjectName  /* && injectionData.preDestroyName*/  )
                    {
                        break;
                    }
                    else if (metadata.name == "PostConstruct")
                    {
                        injectionData.postConstructName = method.name;
                    }
                    else if (metadata.name == "PostInject")
                    {
                        injectionData.postInjectName = method.name;
                    }
                }
            }
            for (variable/* AS3HX WARNING could not determine type for var: variable exp: EField(EField(EIdent(dtJson),traits),variables) type: null */ in dtJson.traits.variables)
            {
                for (metadata/* AS3HX WARNING could not determine type for var: metadata exp: EField(EIdent(variable),metadata) type: null */ in variable.metadata)
                {
                    if (metadata.name == "Autowired")
                    {
                        isOptional = getVariableIsOptional(metadata.value);
                        
                        injectionData.variables[variable.name] = new InjectionVariableVo(variable.type +
                                getVariableMetaName(metadata.value)  /*.replace(/::/g, ".")*/  , isOptional);
                    }
                }
            }
            
            injectionMap.set(mappedType, injectionData);
        }
        
        return injectionData;
    }
    
    private static function getVariableIsOptional(metaPropertyList : Array<Dynamic>) : Bool
    {
        var optional : Bool;
        for (i in 0...metaPropertyList.length)
        {
            if (metaPropertyList[i].key == "optional")
            {
                optional = (metaPropertyList[i].value == "true");
                break;
            }
        }
        
        return optional;
    }
    
    private static function getVariableMetaName(metaPropertyList : Array<Dynamic>) : String
    {
        var metaName : String = "";
        for (i in 0...metaPropertyList.length)
        {
            if (metaPropertyList[i].key == "name")
            {
                metaName = "$" + metaPropertyList[i].value;
                break;
            }
        }
        
        return metaName;
    }
    
    /**
		 * Clears all pools, mappings and injection data of current <code>AppFactory</code>.
		 */
    override public function dispose() : Void
    {
        typeMapping = null;
        instanceMapping = null;
        
        for (poolModel/* AS3HX WARNING could not determine type for var: poolModel exp: EIdent(pool) type: haxe.ds.ObjectMap<Dynamic, Dynamic> */ in pool)
        {
            poolModel.dispose();
        }
        
        pool = null;
        
        super.dispose();
    }
    
    /**
		 * @inheritDoc
		 */
    private function set_autoInjectDependencies(value : Bool) : Bool
    {
        _autoInjectDependencies = value;
        return value;
    }
    
    /**
		 * @inheritDoc
		 */
    private function set_verbose(value : Bool) : Bool
    {
        _verbose = value;
        return value;
    }
    
    private static function getId(type : Class<Dynamic>, name : String) : String
    {
        return Type.getClassName(type) + (!(name != null) ? "" : "$" + name);
    }
    
    /**
		 * @inheritDoc
		 */
    public function appendMappingConfig(config : haxe.ds.ObjectMap<Dynamic, Dynamic>) : IAppFactory
    {
        var i : Class<Dynamic>;
        var c : Class<Dynamic>;
        var name : String;
        var interfaceDefinition : String;
        var d : DependencyVo;
        var splitted : Array<Dynamic>;
        
        for (interfaceDefinition in Reflect.fields(config))
        {
            d = config.get(interfaceDefinition);
            
            splitted = interfaceDefinition.split("$");
            if (splitted.length > 1)
            {
                name = splitted[1];
                interfaceDefinition = splitted[0];
            }
            
            i = Type.getClass(Type.resolveClass(interfaceDefinition));
            
            if (d.value != null)
            {
                mapToValue(i, d.value, name);
            }
            else
            {
                if (d.implementation)
                {
                    c = Type.getClass(Type.resolveClass(d.implementation));
                    
                    log("Mapping '" + interfaceDefinition + "' to '" + c + "'");
                    
                    mapToType(i, c);
                }
                
                if (d.newInstance)
                {
                    mapToValue(i, getNewInstance(i), name);
                }
            }
            
            name = null;
        }
        
        return this;
    }

    public function new()
    {
        super();
    }
}




class InjectionDataVo
{
    @:allow(com.domwires.core.factory)
    private var variables : haxe.ds.ObjectMap<Dynamic, Dynamic> = new haxe.ds.ObjectMap<Dynamic, Dynamic>();
    @:allow(com.domwires.core.factory)
    private var postConstructName : String;
    @:allow(com.domwires.core.factory)
    private var postInjectName : String;
    //	internal var preDestroyName:String;
    
    @:allow(com.domwires.core.factory)
    private function new()
    {
    }
    
    @:allow(com.domwires.core.factory)
    private function dispose() : Void
    {
        variables = null;
    }
}

class InjectionVariableVo
{
    public var qualifiedName(get, never) : String;
    public var optional(get, never) : Bool;

    private var _qualifiedName : String;
    private var _optional : Bool;
    
    @:allow(com.domwires.core.factory)
    private function new(qualifiedName : String, optional : Bool)
    {
        _qualifiedName = qualifiedName;
        _optional = optional;
    }
    
    private function get_qualifiedName() : String
    {
        return _qualifiedName;
    }
    
    private function get_optional() : Bool
    {
        return _optional;
    }
}