/**
 * Created by Anton Nefjodov
 */
package com.domwires.core.preloader;

import flash.errors.Error;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;

/**
 * Application internal preloader. Application should be built with additional compiler option:
 * "-frame=two,my.cool.package.MyMain", where "my.cool.package.MyMain" is the main application class.
 * After app is completely downloaded, preloader will move to second frame.
 * Before that, use as less classes as possible, so preloader will be shown faster.
 */
class AbstractInternalPreloader extends MovieClip
{
    private var _preloader : Sprite;
    
    public function new()
    {
        super();
        
        if (!stage)
        {
            addEventListener(Event.ADDED_TO_STAGE, added);
        }
        else
        {
            init();
        }
    }
    
    private function added(event : Event) : Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, added);
        
        init();
    }
    
    /**
		 * Default preloader added to display list and ready to process preloader actions.
     * Override with super, if you want to add additional logic.
     */
    private function init() : Void
    {
        stop();
        
        loaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderInfo_progressHandler);
        loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
    }
    
    private function loaderInfo_progressHandler(event : ProgressEvent) : Void
    {
        reDrawPreloader(event.bytesLoaded, event.bytesTotal);
    }
    
    private function loaderInfo_completeHandler(event : Event) : Void
    {
        removePreloader();
        
        this.gotoAndStop(2);
        
        appLoaded();
    }
    
    /**
     * Override this method and add initialize implementation here.
     */
    private function appLoaded() : Void
    {
        throw new Error("AbstractInternalPreloader#appLoaded: method MUST be overriden!");
    }
    
    /**
		 * Redraws native display list preloader.
     * Override, if you wan't to use other way to display preloader.
     * @param bytesLoaded
     * @param bytesTotal
     */
    private function reDrawPreloader(bytesLoaded : Float, bytesTotal : Float) : Void
    {
        if (_preloader == null)
        {
            _preloader = new Sprite();
            addChild(_preloader);
        }
        
        _preloader.graphics.clear();
        _preloader.graphics.beginFill(0xFFFE6E);
        _preloader.graphics.drawRect(200, (this.stage.stageHeight - 10) / 2, 
                (_preloader.stage.stageWidth - 400) * bytesLoaded / bytesTotal, 10
        );
        _preloader.graphics.endFill();
    }
    
    /**
		 * Removes native display list preloader.
     * Override, if you are using your own way to draw preloader.
     */
    private function removePreloader() : Void
    {
        if (_preloader != null)
        {
            removeChild(_preloader);
            _preloader = null;
        }
    }
}

