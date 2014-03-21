
package com.ablesky.vcore.utils {
    import flash.events.*;
    import flash.display.*;
    import flash.net.*;
    import flash.system.*;

    public class ModuleLoader extends EventDispatcher {

        private var urlReq:URLRequest;
        public var loader:Loader;
        private var loaderContext:LoaderContext;

        public function ModuleLoader(target:IEventDispatcher=null){
            super(target);
        }
        private function onIOError(e:IOErrorEvent):void{
            this.dispatchEvent(e);
        }
        private function onProgress(e:ProgressEvent):void{
            this.dispatchEvent(e);
        }
        public function load(url:String, addLoaderContext:Boolean=true):void{
            var url:* = url;
            var addLoaderContext:Boolean = addLoaderContext;
            if (!this.loader){
                this.loader = new Loader();
            };
            if (addLoaderContext){
                this.loaderContext = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
            };
            if (this.urlReq){
                this.urlReq.url = url;
            } else {
                this.urlReq = new URLRequest();
                this.urlReq.url = url;
            };
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.onInit);
            this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onProgress);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
            this.loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.onStatus);
            this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurity);
            try {
                this.loader.load(this.urlReq, this.loaderContext);
                trace(this.urlReq.url);
            } catch(e:Error) {
                this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
            };
        }
        private function onStatus(e:HTTPStatusEvent):void{
            trace(e.status);
        }
        private function onInit(e:Event):void{
            this.dispatchEvent(e);
        }
        private function onComplete(e:Event):void{
            trace("load Success ready");
            this.dispatchEvent(e);
        }
        private function onSecurity(e:SecurityErrorEvent):void{
			this.dispatchEvent(e);
        }

    }
}//package com.ablesky.asUi.utils 
