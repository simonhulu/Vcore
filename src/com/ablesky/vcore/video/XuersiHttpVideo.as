package com.ablesky.vcore.video 
{
	import com.ablesky.vcore.events.BaseVideoEvent;
	import com.ablesky.vcore.model.vo.KeyInfo;
	import com.ablesky.vcore.model.vo.PlayStatus;
	import com.ablesky.vcore.utils.KeyInfoUtil;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.hash.IHash;
	import com.hurlant.util.Hex;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author szhang
	 */
	public class XuersiHttpVideo extends HttpVideo 
	{
		private var _mp4:Boolean = true;
		public function XuersiHttpVideo() 
		{
			
		}
		
		override public function play(url:String,startKey:KeyInfo,endKey:KeyInfo=null):void 
		{
			_startKey  = startKey ;
			if (_source.indexOf(".flv") >= 0)
			{
				mp4 = false ;
			}
			if (!_ns)
			{
				init();
			}
			jumpT = startKey.time ;
			super.play(url, startKey, endKey);
			setStatus(PlayStatus.PLAYING);

		}
		
		override public function seek(time:int):void 
		{
			//super.seek(time);
			//先判断是flv还是mp4 flv start接offset mp4 start 接时间
			var start:Number ;

			var st:KeyInfo=KeyInfoUtil.getLastKeyByTime(time, _metaObj.keyFrames);;
			if (mp4)
			{
				start = st.time;
			}else {
				start = st.size ;
			}
			//如果不在缓存中就从服务器申请
			if (st.time<_startKey.time|| st.time> this.loadedTime)
			{
				var url:String = _source + "?start=" + start + "&" + getParams();
				play(url, st, new KeyInfo());
			}else {
				_ns.seek(st.time - _startKey.time);
				if (_status != PlayStatus.PAUSED)
				{
					setStatus(PlayStatus.PLAYING);		
				}
			}
		}
			
		public  function getParams():String {
            var _local1:String = new Date().getTime().toString().substr(0, 10);			
            var _local2 = (("3*^" + _local1) + "!D$");
            var _local3:IHash = Crypto.getHash("md5");       
            var _local4:ByteArray = Hex.toArray(Hex.fromString(_local2));
            var _local5:ByteArray = _local3.hash(_local4);
            var _local6:String = Hex.fromArray(_local5);
            return (((("time=" + _local1) + "&key=") + _local6));
        }		
		
		override protected function onGotMetaData(e:BaseVideoEvent):void 
		{
			if (mp4)
			{
				_metaObj.removeEventListener(BaseVideoEvent.GOT_METADATA,onGotMetaData);
			}
			dispatchEvent(new BaseVideoEvent(BaseVideoEvent.GOT_METADATA, e.data));		
			
		}
		
		
		override protected function onTime(e:TimerEvent):void
		{
			this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.MEDIATIME,{'time': nstime,'nsLoaded':loadedTime}));
		}		
		
		override public function get nstime():int 
		{
			_nstime = jumpT + _ns.time;
			return _nstime;
		}		
		
		public function get mp4():Boolean 
		{
			return _mp4;
		}
		
		public function set mp4(value:Boolean):void 
		{
			_mp4 = value;
		}
		
		override protected function onComplete(e:Event):void 
		{

		}
	}

}