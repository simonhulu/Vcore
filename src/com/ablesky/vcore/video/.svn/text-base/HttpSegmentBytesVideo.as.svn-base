package com.ablesky.vcore.video 
{
	import com.ablesky.asUi.display.SpriteUI;
	import com.ablesky.vcore.events.BaseVideoEvent;
	import com.ablesky.vcore.model.flv.FLVHeader;
	import com.ablesky.vcore.model.flv.FLVParser;
	import com.ablesky.vcore.model.flv.FLVTag;
	import com.ablesky.vcore.model.flv.FLVTagScriptDataObject;
	import com.ablesky.vcore.model.flv.FLVTagVideo;
	import com.ablesky.vcore.model.vo.Config;
	import com.ablesky.vcore.model.vo.FLVSlice;
	import com.ablesky.vcore.model.vo.KeyInfo;
	import com.ablesky.vcore.utils.KeyInfoUtil;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.events.NetStatusEvent;	
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.Timer;
	import com.ablesky.vcore.net.httpstreaming.HTTPStreamingState;
	import flash.net.NetStreamAppendBytesAction;
	/**
	 * ...
	 * @author szhang
	 */
	public class HttpSegmentBytesVideo extends BaseVideo 
	{
		private var _bytes:ByteArray = new ByteArray();
		private var _us:URLStream = new URLStream();
		//保存下载下来的数据
		public var _savedBytes:ByteArray = new ByteArray();
		public var complete:Boolean = false;
		private var fileInit:Boolean = false;
		//记录送进去的数据在文件中的位置
		private var playPos:int;
		private var _url:String;
		private var flvParser:FLVParser = new FLVParser(false);;
		private static const MAIN_TIMER_INTERVAL:int = 25 ;
		private var mainTimer:Timer;
		private var _flvParser:FLVParser = null;	// this is the new common FLVTag Parser		
		private var _flvParserProcessed:uint;//解析出来的tag数据一共的长度
		private var _enhancedSeekTags:Vector.<FLVTagVideo> = new Vector.<FLVTagVideo>()	
		private var _flvParserIsSegmentStart:Boolean = false;	
		private var _inputBytesNeeded:Number = 17 ;//期望获得多少数据
		private var _scriptTag:FLVTagScriptDataObject;
		private var _dataAvailable:Boolean = false;		
		public function HttpSegmentBytesVideo() 
		{
			
		}
		
		private function onClick(e:MouseEvent):void
		{

		}
		protected function createCacaheVideo():void
		{
			/**
			 * 当seek In Server的时候更新
			 */
			
		}
		
		override public function init():void 
		{
			 super.init();
			_timer = new Timer(50);
			_timer.addEventListener(TimerEvent.TIMER, onTime);
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);	
			_ns.bufferTime = 3 ;
			_ns.play(null);
			_us.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurity);
			_us.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_us.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			_us.addEventListener(Event.COMPLETE, onComplete);
			_us.addEventListener(ProgressEvent.PROGRESS, onProgress);
			mainTimer = new Timer(MAIN_TIMER_INTERVAL);
			mainTimer.addEventListener(TimerEvent.TIMER, onMainTimer);
			mainTimer.start();
		}
		
		private function onMainTimer(e:TimerEvent):void
		{
			var bytes:ByteArray;
			switch(_state)
			{
				case HTTPStreamingState.INIT:
				//do nothing,but not an error to be here,could make timer run slower if we wanted
				break;
				case HTTPStreamingState.SEEK:
					switch(_prevState)
					{
						case HTTPStreamingState.PLAY:
						case HTTPStreamingState.PLAY_START_NEXT:
						case HTTPStreamingState.PLAY_START_NEXT:
							//调用close方法
						break;
						default :
						//already not open
						break;
					}
					setState(HTTPStreamingState.LOAD_SEEK);
					break;
				case HTTPStreamingState.LOAD_SEEK:
					_ns.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
					setState(HTTPStreamingState.LOAD);
					break;
				case HTTPStreamingState.LOAD:
					_us.load(new URLRequest('http://127.0.0.1/vod/1c3190f0-5a04-480c-afa8-49ff538154ee.asv'));	
					switch (_prevState)
					{
						case HTTPStreamingState.LOAD_SEEK:
						case HTTPStreamingState.LOAD_SEEK_RETRY_WAIT:
							setState(HTTPStreamingState.PLAY_START_SEEK);
							break;
						case HTTPStreamingState.LOAD_NEXT:
						case HTTPStreamingState.LOAD_NEXT_RETRY_WAIT:
							setState(HTTPStreamingState.PLAY_START_NEXT);
							break;
						default:
							throw new Error("in HTTPStreamState.LOAD(2) with unknown _prevState " + _prevState);
							break;
					}					
					break;
				case HTTPStreamingState.PLAY_START_NEXT:
					setState(HTTPStreamingState.PLAY_START_COMMON);
					break;
				case HTTPStreamingState.PLAY_START_COMMON:
					
					setState(HTTPStreamingState.PLAY);					
					break;
				case HTTPStreamingState.PLAY:
					//调用appendBytes
					var input:ByteArray = null;					
					while (_state == HTTPStreamingState.PLAY &&_us.bytesAvailable)
					{
						//先保存到_saveByets中
						//从头开始的
						if (!_flvParserIsSegmentStart)
						{
							input = new ByteArray();
							//13+4
							_us.readBytes(input as ByteArray, 0, 17);
							var tempBytes:ByteArray = new ByteArray();
							tempBytes.writeBytes(input as ByteArray, 13);
							tempBytes.endian = Endian.BIG_ENDIAN;
							tempBytes.position = 0;
							var encryLen:int = tempBytes.readInt();
							//让_us的position跳到除FLV header+encry data的位置
							_us.readBytes(tempBytes, 0, encryLen+4);
							_flvParserIsSegmentStart = true ;
							input = null;
						}
						_us.readBytes(_savedBytes, _savedBytes.length);	
						_savedBytes.position = _flvParserProcessed;
						trace('_flvParserProcessed='+_flvParserProcessed);
						input = new ByteArray();
						_savedBytes.readBytes(input);
						trace(input[0]);
						flvParser.parse(input, false, flvTagHandler);
						trace('************************************************************');
					}			
					break;
				case HTTPStreamingState.END_SEGMENT:
				
					break;
				case HTTPStreamingState.STOP:
				
					break;
				case HTTPStreamingState.HALT:
				
					break;
				case HTTPStreamingState.PLAY_START_SEEK:		
					setState(HTTPStreamingState.PLAY_START_COMMON);
					break;
			}
		}
		
		
		private function processAndAppend(inBytes:ByteArray):uint
		{
			inBytes.position = 0 ;
			return 0;
		}
		
		private function byteSourceFromUs(input:IDataInput, numBytes:Number):IDataInput
		{
			if (numBytes > input.bytesAvailable)
			{
				return null;
			}else {
				var bytes:ByteArray = new ByteArray();
				input.readBytes(bytes, 0, numBytes);
				return bytes;
			}
		}
		
		
		
		
		private function byteSource(input:IDataInput, numBytes:Number):IDataInput
		{
			if (numBytes < 0)
			{
				return null;
			}
			
			if (numBytes)
			{
			 	if (_savedBytes.bytesAvailable + input.bytesAvailable < numBytes)
			 	{
					return null;
				}
			}
			else
			{
				if (_savedBytes.bytesAvailable + input.bytesAvailable < 1)
				{
					return null;
				}
			}
			
			if (_savedBytes.bytesAvailable)
			{
				var needed:int = numBytes - _savedBytes.bytesAvailable;
				if (needed > 0)
				{
					input.readBytes(_savedBytes, _savedBytes.length, needed);
				}
				
				return _savedBytes;
			}
			
			_savedBytes.length = 0;
			
			return input;
		}	
		
		public function reInit():void
		{
			_video.clear();
			if (_us.connected)
			{
				_us.close();				
			}	
			//stream.clear();
		    //stream = new ByteArray();
		   complete = false;
		   fileInit  = false;
		   //记录送进去的数据在文件中的位置
		   playPos = 0 ;			
	}
		
		protected function onTime(e:TimerEvent):void
		{
			this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.MEDIATIME,{'time': nstime,'nsLoaded':loadedTime}));			
		}
		
		override public function play(url:String,startKey:KeyInfo,endKey:KeyInfo=null):void 
		{
			super.play(url, startKey, endKey);
			//if (!_ns)
			//{
				//init();
			//}
			//reInit();
			//jumpT = startKey.time;
			//_url = url;
			//if (_ns.time > 0)
			//{
				//_ns.seek(0);
			//}else {
				//_timer.start();
				//_us.load(new URLRequest(_url));			
			//}
			setState(HTTPStreamingState.INIT);
			setState(HTTPStreamingState.SEEK);
		}
		
		 public function play2(url:String,startKey:KeyInfo,endKey:KeyInfo=null):void 
		{
			super.play(url, startKey, endKey);
			if (!_ns)
			{
				init();
			}
init();
			_url = url;
			if (_ns.time > 0)
			{
				_ns.seek(0);
			}else {
				_timer.start();
				_us.load(new URLRequest(_url));			
			}
		}		
		
		
		override public function seek(time:int):void 
		{
			jumpT = time;
			_ns.seek(0);
		}
		
		override protected function onNetStatus(e:NetStatusEvent):void 
		{
			//trace(e.info.code);
			//switch(e.info.code)
			//{
				//case "NetConnection.Connect.Success":
					//
					//break;
				//case "NetStream.Play.Start":
				//this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.PLAY_START));					
					//break;
				//case "NetStream.Buffer.Empty":
					//if (Math.floor(_ns.bufferLength) == 0 && playPos == stream.length &&complete )
					//{
						//this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.PLAY_OVER));				
					//}else {
						//this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.BUFFER_EMPTY));							
					//}				
					//break;
				//case "NetStream.Buffer.Full":
					//this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.BUFFER_FULL));						
					//break;
				//case "NetStream.Play.Stop":
					//this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.PLAY_OVER));				
					//break;
				//case "NetStream.Seek.Notify":
				//trace(_ns.bufferLength);
					//if (stream.length == 0 && _ns.bufferLength == 0)
					//{
						//_timer.start();
						//_us.load(new URLRequest(_url));
					//}else {
						//_timer.stop();
						//本地加载,首先根据jumpT,找到keuinfo,然后找到key的size
						//var k:KeyInfo = KeyInfoUtil.getLastKeyByTime(jumpT, _metaObj.keyFrames);
						//jumpT = k.time;
						//var offset:int;
						//var cb:ByteArray = new ByteArray();
						//if (_startKey.size == 0)
						//{						
							//offset = k.size - _startKey.size;
						//}else
						//{
							//offset = k.size - startKey.size + Config.FLVHEADER_BYTE_COUNT;
						//}
						//stream.position = offset;
						//_ns.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
						//while (stream.position < stream.length)
						//{
							//stream.readBytes(cb, 0);
							//_ns.appendBytes(cb);
							//cb.clear();
						//}
						//_timer.start();
					//}
					//break;
				//case 'NetStream.Seek.InvalidTime':
					//
					//break;
			//}
		}	
		
		
		override protected function onHttpStatus(e:HTTPStatusEvent):void 
		{
			trace(e.status)
		}
		
		override protected function onProgress(e:ProgressEvent):void 
		{
			_nsBytsLoaded = e.bytesLoaded;
			_nsBytesTotal = e.bytesTotal;
			_dataAvailable = true;			
		//	reStructData();
			
		}
		
		
		override protected function onComplete(e:Event):void 
		{
			complete = true ;
			trace("=============================complete"+_us.bytesAvailable+"=============================" );
			//_timer.stop();
		}

		private function reStructData():void
		{
			_timer.stop();
			//if (_us.bytesAvailable > 100)
			//{
				//_us.readBytes(stream, stream.length);
				//如果还没有初始化
				//if (!fileInit)
				//{
					//stream.position = 0 ;
					//stream.readBytes(FLVHeader, 0, Config.FLVHEADER_BYTE_COUNT);
					//var insertLen:int ;
					//var tempByte:ByteArray = new ByteArray();
					//tempByte.writeBytes(stream, Config.FLVHEADER_BYTE_COUNT, Config.INTBYTELENGTH);
					//tempByte.position = 0 ;
					//tempByte.endian = Endian.BIG_ENDIAN;
					//insertLen = tempByte.readInt();
					//tempByte.clear();
					//tempByte = null ;
					//var lastByte:ByteArray = new ByteArray();
					//var n:int = 0;
					//if (_startKey.size == 0)
					//{
						//lastByte.writeBytes(stream, Config.FLVHEADER_BYTE_COUNT + insertLen + Config.INTBYTELENGTH + Config.PRETAGLEN);
					//}else
					//{
						//lastByte.writeBytes(stream, Config.FLVHEADER_BYTE_COUNT + insertLen + Config.INTBYTELENGTH);												
					//}
					//stream.clear();
					//stream.writeBytes(FLVHeader);
					//stream.writeBytes(lastByte);
					//lastByte.clear();
					//lastByte = null;
					//fileInit = true ;
					//_ns.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
					//_ns.appendBytes(stream);
					//playPos = stream.length;
				//}else
				//{
					//if ((stream.length - playPos) > 0)
					//{
						//var tempByte2:ByteArray = new ByteArray();
						//tempByte2.writeBytes(stream, playPos);								
						//_ns.appendBytes(tempByte2);
						//playPos  += tempByte2.length;
						//tempByte2.clear();
					//}
				//}
			//}
			//stream.position = 0 ;
			//flvParser.parse(stream, true, flvTagHandler);					
			_timer.start();

		}
		
		private function flvTagHandler(tag:FLVTag):Boolean
		{
			//trace('tag.time=' + tag.timestamp/1000);
			var byte:ByteArray = new ByteArray();
			tag.write(byte);
			_flvParserProcessed += byte.length;
			switch(tag.tagType)
			{
				case FLVTag.TAG_TYPE_SCRIPTDATAOBJECT:
					_scriptTag = tag as FLVTagScriptDataObject;
					var header:FLVHeader = new FLVHeader();
					var headerBytes:ByteArray = new ByteArray();
					header.write(headerBytes);
					_ns.appendBytes(headerBytes);				
					break;
				case FLVTag.TAG_TYPE_VIDEO:
					_enhancedSeekTags.push(tag);
					break;
			}
			_ns.appendBytes(byte);
			if (0<tag.timestamp <71119)
			{
				return true;
			}
			return false;
		}
		
		
		//获取加载了多少数据
		override public function get nsBytsLoaded():uint 
		{
			return 0;// stream.length;
		}
		
		override public function get nsBytesTotal():uint 
		{
			if (_metaObj)
			{
				 _nsBytesTotal = _metaObj.filesize;
			}
			 return _nsBytesTotal;
		}
		
		//加载的数据对应文件的时间位置
		override public function get loadedTime():int
		{
			var loadedTime:int;
			if (_nsBytesTotal)
			{
				loadedTime = Math.floor(nsBytsLoaded / nsBytesTotal * _metaObj.duration + _startKey.time);
			}
			return loadedTime;
		}
		//获取当前播放在整个文件中的时间位置
		override public function get nstime():int 
		{
			_nstime = jumpT + _ns.time;
			return _nstime;
		}
		override public function get startKey():KeyInfo 
		{
			return _startKey;
		}
		
		override public function set startKey(value:KeyInfo):void 
		{
			_startKey = value;
		}
		
		override public function get endKey():KeyInfo 
		{
			return _endKey;
		}
		
		override public function set endKey(value:KeyInfo):void 
		{
			_endKey = value;
		}
		
		
		
	}

}