package com.ablesky.vcore.utils 
{
	import com.ablesky.vcore.events.XUERSIVideoEvents;
	import com.ablesky.vcore.model.vo.Config;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author szhang
	 */
	public class XESURLStream extends URLStream 
	{
		private var _data:ByteArray = new ByteArray();
		private var _isComplete:Boolean = false; 
		private var _time_out:int;
		//用来记录某些请求花费的时间,该变量用来记录起始时间
		private var requestInterval:int = 0 ;
		//超时次数只记录三次
		private var repeatTimes = 0 ;
		private var _request:URLRequest;
		private var error:Boolean = false; 
		private var repeatCount:int = 0 ;
		var timer:Timer;
		private var _byteTotal:int;
		private var _hostsPath:Array;
		public function XESURLStream() 
		{
            this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurity);
            this.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            this.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
            this.addEventListener(Event.COMPLETE, onComplete);
            this.addEventListener(ProgressEvent.PROGRESS, onProgress);	
			timer = new Timer(30000);
			timer.addEventListener(TimerEvent.TIMER, onTimerComplete);
			
		}
		
		
		private function onTimerComplete(e:TimerEvent):void
		{
			if (!_isComplete && this.bytesAvailable<_byteTotal)
			{
				dispatchEvent(new XUERSIVideoEvents(XUERSIVideoEvents.GETXVES_TIMEOUT30_ERROR, '超过30秒'));				
				repeatdownload();
			}
		}
		
		override public function load(request:URLRequest):void 
		{
			repeatCount = 0 ;
			timer.reset();
			timer.start();
			_request = request;
			_isComplete = false;
			_data.clear();
			requestInterval = getTimer() / 1000;			
			super.load(request);
		}
		
		public function get isComplete():Boolean 
		{
			return _isComplete;
		}
		
		public function get time_out():int 
		{
			return _time_out;
		}
		
		public function set time_out(value:int):void 
		{
			_time_out = value;
		}
		
		public function get data():ByteArray 
		{
			return _data;
		}
		
		public function get hostsPath():Array 
		{
			return _hostsPath;
		}
		
		public function set hostsPath(value:Array):void 
		{
			_hostsPath = value;
		}
		protected function onProgress(e:ProgressEvent):void
		{
			_byteTotal = e.bytesTotal ;
		}
		
		protected function onHttpStatus(e:HTTPStatusEvent):void
		{

		}
		
		protected function onSecurity(e:SecurityErrorEvent):void
		{
			
		}
		
		protected function onIOError(e:IOErrorEvent):void
		{
			//只发送一次
			if (repeatCount == 0)
			{
				dispatchEvent(new XUERSIVideoEvents(XUERSIVideoEvents.GETXVESERROR, '加载失败,请检查您的网络或刷新页面'));	
			}
			TweenLite.delayedCall(3, function():void { repeatdownload(); } );
		
		}	
		
		protected function repeatdownload():void
		{
			//如果出错了 重新下载
			error = true ;
			
			if (repeatCount < 10)
			{
				//尝试用source.xesv5.com,v1尝试5次,source尝试5次
				var request:URLRequest;
				if (_hostsPath && repeatCount>4)
				{
					var su:String = _request.url;
					var i:int = su.indexOf("/", 7);
					var s:String = _hostsPath[1]+su.slice(i);
					request = new URLRequest(s);
				}else {
					request = _request;
				}
				//用http://source.xesv5.com 替换http://v1.xesv5.com
				repeatCount++; 
				//load(request); 			
				super.load(request);
			}			
		}
		
		protected function onComplete(e:Event):void 
		{
			timer.reset();
			timer.start();
			var interval:int = getTimer() / 1000 - requestInterval ;
			//超时20秒
			if( interval>=_time_out && repeatTimes<3)
			{
				trace("_time_out=" + _time_out);
				var object:Object = new Object();
				object.interval = interval;
				object.fragmenturl = _request.url;
				dispatchEvent(new XUERSIVideoEvents(XUERSIVideoEvents.GETXVES_TIMEOUT_ERROR, object));
				repeatTimes++;
			}
			_isComplete = true ;
			error = false;
			this.readBytes(data);
		}		
	}

}