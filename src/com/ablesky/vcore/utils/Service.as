package com.ablesky.vcore.utils
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osflash.signals.Signal;

	public class Service
	{
		protected var urlloader:URLLoader = null;
		public var signal:Signal = new Signal();
		public function Service(requestVars:Object=null)
		{
			urlloader = new URLLoader();
			if (requestVars && "format" in requestVars)
			{
				urlloader.dataFormat = String(requestVars.format);
			}
		}
		
		
		public function load(url:String):void
		{
			if(url.indexOf("http://")>=0||url.indexOf("https://")>=0)
			{
				addListener()
				urlloader.load(new URLRequest(url));	
			}else {
				signal.dispatch("error");					
			}
		}
		
		public function post(urlRequest:URLRequest):void
		{
			if(urlRequest.url.indexOf("http://")>=0||urlRequest.url.indexOf("https://")>=0)
			{
				addListener()
				urlloader.load(urlRequest);	
			}else {
				signal.dispatch("error");					
			}
		}		
		
		protected function addListener():void
		{
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			urlloader.addEventListener(Event.COMPLETE, onComplete);
			urlloader.addEventListener(ProgressEvent.PROGRESS,onProgress);
			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
			urlloader.addEventListener(HTTPStatusEvent.HTTP_STATUS,onHttpStatus);
		}
		
		protected function onProgress(e:ProgressEvent):void
		{
			
		}
		
		protected function onSecurityError(e:SecurityErrorEvent):void
		{
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			urlloader.removeEventListener(Event.COMPLETE,onComplete);	
			signal.dispatch("error");	
		}
		
		private function onHttpStatus(e:HTTPStatusEvent):void
		{
			
		}
		
		protected  function onIOError(e:IOErrorEvent):void
		{
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			urlloader.removeEventListener(Event.COMPLETE,onComplete);	
			signal.dispatch("io_error");
		}
		
		protected  function onComplete(e:Event):void
		{
			urlloader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
			urlloader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,onHttpStatus);			
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			urlloader.removeEventListener(Event.COMPLETE,onComplete);	
			signal.dispatch(e.target.data);
		}
		
	}
}