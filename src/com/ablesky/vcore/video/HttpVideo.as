package com.ablesky.vcore.video 
{
	import com.ablesky.vcore.events.BaseVideoEvent;
	import com.ablesky.vcore.model.vo.KeyInfo;
	import com.ablesky.vcore.model.vo.PlayStatus;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author szhang
	 */
	public class HttpVideo extends BaseVideo 
	{
		protected var _source:String ;
		public function HttpVideo() 
		{
			
		}
		
		override public function init():void 
		{
			super.init();
			_timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER, onTime);
			_timer.start();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		
		protected function onTime(e:TimerEvent):void
		{
			this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.MEDIATIME,{'time': nstime,'nsLoaded':loadedTime}));
		}
		
		override protected function onGotMetaData(e:BaseVideoEvent):void
		{
			trace("gotmatedata");
		}
		
		override protected function onNetStatus(e:NetStatusEvent):void 
		{
			trace(e.info.code);
			switch(e.info.code)
			{
				case "NetConnection.Connect.Success":
					
					break;
				case "NetStream.Play.Start":
				this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.PLAY_START));				
					break;
				case "NetStream.Buffer.Empty":
					if (_ns.bufferLength == 0 && Math.floor(_nsBytsLoaded) == Math.floor(_nsBytesTotal))
					{
						if (_status != PlayStatus.STOPPED)
						{
							this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.PLAY_OVER));	
							return;							
						}
					}else {
						this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.BUFFER_EMPTY));							
						this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.BUFFER_EMPTY));							
					}
					break;
				case "NetStream.Buffer.Full":
				this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.BUFFER_FULL));				
					break;
				case "NetStream.Play.Stop":
					setStatus(PlayStatus.STOPPED);
					this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.PLAY_OVER));
					break;
				case "NetStream.Seek.Notify":
				
					break;
				case 'NetStream.Seek.InvalidTime':
				
					break;
			}
		}
		
		override public function seek(time:int):void 
		{
			super.seek(time);
			_ns.seek(time);
		}
		
		override public function play(url:String,startKey:KeyInfo,endKey:KeyInfo=null):void 
		{
			super.play(url, startKey, endKey);
			if (!_ns)
			{
				init();
			}
			jumpT = startKey.time ;
			_ns.play(url);
			if (_status == PlayStatus.PAUSED)
			{
				pause();
			}else {
				setStatus(PlayStatus.PLAYING);				
			}
			

		}
		
		override public function get nstime():int 
		{
			_nstime = jumpT + _ns.time;
			return super.nstime;
		}
		
		override public function get nsBytsLoaded():uint 
		{
			_nsBytsLoaded = _ns.bytesLoaded;
			return _nsBytsLoaded;
		}
		
		override public function get nsBytesTotal():uint 
		{
			 _nsBytesTotal = _ns.bytesTotal;
			 return _nsBytesTotal;
		}
		
		//加载的数据对应文件的时间位置
		override public function get loadedTime():int
		{
			var loadedTime:int;
			if (_ns.bytesTotal)
			{
				loadedTime = Math.floor(_ns.bytesLoaded / _ns.bytesTotal * _metaObj.duration + _startKey.time);
			}
			return loadedTime;
		}
		
		public function get source():String 
		{
			return _source;
		}
		
		public function set source(value:String):void 
		{
			_source = value;
		}
		
	}

}