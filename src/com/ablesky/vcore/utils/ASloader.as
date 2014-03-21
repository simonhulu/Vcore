
package com.ablesky.vcore.utils
{
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.system.*;
	import org.osflash.signals.Signal;

    public class ASloader extends Sprite {

        private var totalBytes:int;
        private var addAlpah:Boolean = true;
        private var time:Timer;
        private var loadingMovie:Shape;
        private var moduleLoad:ModuleLoader;
        private var _playType:String;
		private var _className:String;
		private var _signal:Signal;
        public function ASloader(className:String):void {
			_signal = new Signal();			
            _className = className ;
            Security.allowDomain("*");
            this.init();
        }
        //private function onTimer(e:TimerEvent):void{
            //if (!this.addAlpah){
                //this.loadingText.alpha = (this.loadingText.alpha - 0.1);
                //if (this.loadingText.alpha < 0){
                    //this.addAlpah = true;
                //};
            //} else {
                //this.loadingText.alpha = (this.loadingText.alpha + 0.1);
                //if (Math.floor(this.loadingText.alpha) == 1){
                    //this.addAlpah = false;
                //};
            //};
        //}
        private function onProgress(e:ProgressEvent):void{
            var width:int;
            var loadedBytes:Number = e.bytesLoaded;
            if (this.totalBytes == 0){
                this.totalBytes = loadedBytes;
            };
        }
        private function onInit(e:Event):void{
        }
        private function init(e:Event=null):void{
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            //this.time = new Timer(100);
            //this.time.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.moduleLoad = new ModuleLoader();
            this.moduleLoad.addEventListener(Event.COMPLETE, this.onComplete);
            this.moduleLoad.addEventListener(ProgressEvent.PROGRESS, this.onProgress);
            this.moduleLoad.addEventListener(Event.INIT, this.onInit);
			this.moduleLoad.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
			this.moduleLoad.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			this.moduleLoad.addEventListener(ErrorEvent.ERROR, onError);
            //var currentUrl:String = ParseUrl.getLoaderInfourl(stage.loaderInfo.url);
            //var index:int = stage.loaderInfo.url.indexOf("?");
            //var version:String = stage.loaderInfo.parameters.v;
            //this._playType = stage.loaderInfo.parameters.type;
            //if (this._playType == "video"){
            //} else {
                //if (this._playType == "document"){
                    //this.moduleLoad.load(((currentUrl + "/DocPlayer.swf?") + version));
                //};
            //};
            //this.loadingMovie = new Shape();
            //this.loadingMovie.graphics.beginFill(0x666666, 1);
            //this.loadingMovie.graphics.drawRect(0, 0, 204, 8);
            //this.loadingMovie.graphics.endFill();
            //this.loadingMovie.graphics.beginFill(0, 1);
            //this.loadingMovie.graphics.drawRect(1, 1, 202, 6);
            //this.loadingMovie.graphics.endFill();
            //this.loadingMovie.graphics.beginFill(6737151, 1);
            //this.loadingMovie.graphics.drawRect(2, 2, 1, 4);
            //this.loadingMovie.graphics.endFill();
            //this.loadingMovie.x = ((stage.stageWidth / 2) - (this.loadingMovie.width / 2));
            //this.loadingMovie.y = ((stage.stageHeight / 2) - (this.loadingMovie.height / 2));
            //addChild(this.loadingMovie);
            //this.loadingText.alpha = 0.1;
            //this.loadingText.x = (this.loadingMovie.x + 54);
            //this.loadingText.y = ((this.loadingMovie.y + this.loadingMovie.height) + 9);
            //addChild(this.loadingText);
            //this.time.start();
        }
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			signal.dispatch("error");
		}
		
		private function onError(e:ErrorEvent):void
		{
			signal.dispatch("error");			
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			_signal.dispatch("io_error");
		}
		
		public function load(url:String):void
		{
			
		     this.moduleLoad.load(url,true);
		}
		
		
		
        private function onComplete(e:Event):void{
            var main:Class;
            main = (this.moduleLoad.loader.contentLoaderInfo.applicationDomain.getDefinition(_className) as Class);
            this.moduleLoad.removeEventListener(Event.COMPLETE, this.onComplete);
            this.moduleLoad.removeEventListener(ProgressEvent.PROGRESS, this.onProgress);
            this.moduleLoad.removeEventListener(Event.INIT, this.onInit);
            this.moduleLoad = null;
			_signal.dispatch(new main() as DisplayObject);
        }
		
		public function get signal():Signal 
		{
			return _signal;
		}

    }
}
