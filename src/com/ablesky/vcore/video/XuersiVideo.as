package com.ablesky.vcore.video 
{
	import com.ablesky.vcore.events.BaseVideoEvent;
	import com.ablesky.vcore.events.XUERSIVideoEvents;
	import com.ablesky.vcore.model.flv.FLVHeader;
	import com.ablesky.vcore.model.flv.FLVParser;
	import com.ablesky.vcore.model.flv.FLVTag;
	import com.ablesky.vcore.model.vo.MetaData;
	import com.ablesky.vcore.utils.XESURLStream;
	import com.ablesky.vcore.utils.XUERSIKeyinfoUtil;
	import com.ablesky.vcore.model.vo.KeyInfo;
	import com.ablesky.vcore.model.vo.PlayStatus;
	import com.ablesky.vcore.model.vo.XUERSIKeyinfo;
	import com.ablesky.vcore.net.httpstreaming.HTTPStreamingIndexHandlerBase;
	import com.ablesky.vcore.net.httpstreaming.HTTPStreamingState;
	import com.ablesky.vcore.net.httpstreaming.XUERSIHTTPStreamingIndexHandlerBase;
	import com.ablesky.vcore.utils.KeyInfoUtil;
	//import com.demonsters.debugger.MonsterDebugger;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import  cmodule.decryption.CLibInit;
	/**
	 * 
	 * @author szhang
	 */
	public class XuersiVideo extends HttpVideo 
	{
        protected static const MAIN_TIMER_INTERVAL:int = 25;	
        protected var mainTimer:Timer;		
        protected var _flvParser:FLVParser;	
        protected var _indexHandler:XUERSIHTTPStreamingIndexHandlerBase;
        protected var _us:XESURLStream;
		//记录
		protected var _savedBytes:ByteArray ;
		//用来记录 解析了多少个字节
		private  var _flvParserProcessed:Number = 0 ;
		private var _flvParserIsSegmentStart:Boolean = false ;
		private var cEncryptOfC:CLibInit = new cmodule.decryption.CLibInit //新建立一个类	
		private var cEncryptOfCOBJECT:Object = cEncryptOfC.init();	

		private var _seekKeyinfo:XUERSIKeyinfo = new XUERSIKeyinfo()  ;
		private var lastTag:FLVTag;
		private var _bufferTime:int = 240 ;
		private var _time_out:int = 20 ;
		public function XuersiVideo() 
		{
			
		}
		
        override public function init():void{
            super.init();
			_savedBytes = new ByteArray();
			_startKey = new XUERSIKeyinfo();
			_us = new XESURLStream();	
			_us.time_out = _time_out;
            _timer = new Timer(50);
            _timer.addEventListener(TimerEvent.TIMER, this.onTime);
			_us.addEventListener(XUERSIVideoEvents.GETXVESERROR,onXUER);
			_us.addEventListener(XUERSIVideoEvents.GETXVES_TIMEOUT_ERROR, onXUER);		
			_us.addEventListener(XUERSIVideoEvents.GETXVES_TIMEOUT30_ERROR, onXUER);				
            _nc.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
            _ns.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
            _ns.bufferTime = 3;
            _ns.play(null);
			
            mainTimer = new Timer(MAIN_TIMER_INTERVAL);
            mainTimer.addEventListener(TimerEvent.TIMER, this.onMainTimer);
        }		
		

		function onXUER(e:XUERSIVideoEvents):void
		{
			this.dispatchEvent(e);
		}
		
		override public function seek(time:int):void 
		{
			 var key:KeyInfo = XUERSIKeyinfoUtil.getLastKeyByTime(time*1000, indexHandler.keyFrames);
			 _seekKeyinfo = key as XUERSIKeyinfo;
			 _startKey = key ;
	        _ns.seek(0);
			mainTimer.stop();
            setState(HTTPStreamingState.SEEK);	
			mainTimer.start();
			if (_status != PlayStatus.PAUSED)
			{
				setStatus(PlayStatus.PLAYING);	
			}
			
		}
		
		public function get indexHandler():XUERSIHTTPStreamingIndexHandlerBase 
		{
			return _indexHandler;
		}
	
		protected function onMainTimer(e:TimerEvent):void
		{
            switch (_state){
                case HTTPStreamingState.INIT:
                    break;
                case HTTPStreamingState.SEEK:
                    switch (_prevState){
                        case HTTPStreamingState.PLAY:
                        case HTTPStreamingState.PLAY_START_NEXT:
                        case HTTPStreamingState.PLAY_START_SEEK:
						case HTTPStreamingState.PLAY_START_COMMON:
                        case HTTPStreamingState.LOAD_WAIT:
						case HTTPStreamingState.END_SEGMENT:
						case HTTPStreamingState.LOAD_NEXT:
                        case HTTPStreamingState.STOP:
							//_flvParserIsSegmentStart = false;
							//_flvParserProcessed = 0 ; 
							//isComplete = false; 
							//if (this._us.connected){
								//this._us.close();
							//};	
							//_ns.close();
							//_savedBytes.clear();						
                            break;
                    }
					_flvParserIsSegmentStart = false;
					_flvParserProcessed = 0 ; 
					if (this._us.connected){
						this._us.close();
					};	
					_savedBytes.clear();					
					setState(HTTPStreamingState.LOAD_SEEK);
                    break;
                case HTTPStreamingState.LOAD_WAIT:
					//如果当前播放的下载完成,并且当前播放的不是最后一个
					if (_us.isComplete && (_startKey as XUERSIKeyinfo).index < (_indexHandler.clips.length - 1)&& (_ns.bufferLength < bufferTime))
					{
						setState(HTTPStreamingState.LOAD_NEXT);
					}
                    break;
                case HTTPStreamingState.LOAD_NEXT:
					_flvParserIsSegmentStart = false;
					_flvParserProcessed = 0 ; 
					if (this._us.connected){
						this._us.close();
					};	
					_savedBytes.clear();
                    setState(HTTPStreamingState.LOAD);
                    break;
                case HTTPStreamingState.LOAD_SEEK:
                    _ns.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
                    setState(HTTPStreamingState.LOAD);
                    break;
                case HTTPStreamingState.LOAD:
					var urlrequest:URLRequest;
                    switch (_prevState) {
						//拖拽
                        case HTTPStreamingState.LOAD_SEEK:
                        case HTTPStreamingState.LOAD_SEEK_RETRY_WAIT:
							 var obj:Object = this.indexHandler.getFileForTime(_startKey.time);
							 urlrequest =  obj.urlrequest;
							  _startKey = obj.startKey;
							  _seekKeyinfo = _startKey as XUERSIKeyinfo ;
                            break;
						//请求下一段
                        case HTTPStreamingState.LOAD_NEXT:
                        case HTTPStreamingState.LOAD_NEXT_RETRY_WAIT:
                            var obj:Object = this.indexHandler.getNextFile((_startKey as XUERSIKeyinfo).index);
                            urlrequest = obj.urlrequest;
                            _startKey = obj.startKey;
                            break;
                        default:
                            throw (new Error(("in HTTPStreamState.LOAD with unknown _prevState " + _prevState)));
                    };
                    if (urlrequest) {

                        this._us.load(urlrequest);
						//如果没有下载完毕,则一直下载
                        switch (_prevState){
                            case HTTPStreamingState.LOAD_SEEK:
                            case HTTPStreamingState.LOAD_SEEK_RETRY_WAIT:
                                setState(HTTPStreamingState.PLAY_START_SEEK);
                                break;
                            case HTTPStreamingState.LOAD_NEXT:
                            case HTTPStreamingState.LOAD_NEXT_RETRY_WAIT:
                                setState(HTTPStreamingState.PLAY_START_NEXT);
                                break;
                            default:
                                throw (new Error(("in HTTPStreamState.LOAD(2) with unknown _prevState " + _prevState)));
                        };
                    };
                    break;
                case HTTPStreamingState.PLAY_START_SEEK:
                    setState(HTTPStreamingState.PLAY_START_COMMON);
                    break;
                case HTTPStreamingState.PLAY_START_NEXT:
                        setState(HTTPStreamingState.PLAY_START_COMMON);
                    break;
                case HTTPStreamingState.PLAY_START_COMMON:
                    setState(HTTPStreamingState.PLAY);
                    break;
                case HTTPStreamingState.PLAY:
                    if (_state == HTTPStreamingState.PLAY && _us.connected && _us.isComplete) {
						//如果没有解密
						var usBytes:ByteArray = new ByteArray();
						usBytes = _us.data;
                        if (!_flvParserIsSegmentStart){
							var i:int = 0 ;
							var len:int = _indexHandler.encryptions.length ;
							while (i < len && cEncryptOfCOBJECT.c_dec(usBytes, 2000, 2, _indexHandler.encryptions[i]) == -1)
							{
								i++;
							}
							if (i == len)
							{
								//证明所有的key 都不对
								dispatchEvent(new XUERSIVideoEvents(XUERSIVideoEvents.DECRYPTERROR,"all keys useless"));
							}
                            _flvParserIsSegmentStart = true;

							_ns.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
							//如果没有lastTag则表示 是第一段视频开始,则是整个video的开始
							if (_startKey.time == 0)
							{
								dispatchEvent(new BaseVideoEvent(BaseVideoEvent.PLAY_START));								
							}
                        }
						_savedBytes.writeBytes(usBytes);
						if (_status != PlayStatus.PAUSED)
						{
							setStatus(PlayStatus.PLAYING);							
						}
						_ns.appendBytes(usBytes);					
					}
					if (_us.isComplete)
					{
						setState(HTTPStreamingState.END_SEGMENT);
					}
                    break;
                case HTTPStreamingState.END_SEGMENT:
                    setState(HTTPStreamingState.LOAD_WAIT);
                    break;
                case HTTPStreamingState.STOP:
                    this.mainTimer.reset();
                    break;
                case HTTPStreamingState.HALT:
                    break;
            }
	}	

	protected function flvTagHandler(flvTag:FLVTag):Boolean 
	{
		switch(flvTag.tagType)
		{
			case FLVTag.TAG_TYPE_ENCRYPTED_SCRIPTDATAOBJECT:
				break;
			case FLVTag.TAG_TYPE_AUDIO:
			case FLVTag.TAG_TYPE_ENCRYPTED_AUDIO:
			case FLVTag.TAG_TYPE_VIDEO:
			case FLVTag.TAG_TYPE_ENCRYPTED_VIDEO:
				var bytes:ByteArray = new ByteArray();
				flvTag.write(bytes);
				_flvParserProcessed += bytes.length;
				_ns.appendBytes(bytes);		
				lastTag = flvTag ;					
				break;	
		}
		return true ;
	}
	
	
	public function play3(indexHandler:XUERSIHTTPStreamingIndexHandlerBase,startKey:XUERSIKeyinfo):void
	{
		mainTimer.start();
		_indexHandler = indexHandler ;
		setState(HTTPStreamingState.INIT) ;
		setState(HTTPStreamingState.SEEK) ;		
		_startKey = startKey ; 
		_seekKeyinfo = startKey ;
		_us.hostsPath = _indexHandler.hostsPath;
	}
		
		
    override protected function onTime(e:TimerEvent):void
	{
            this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.MEDIATIME, {
                time:this.nstime,
                nsLoaded:this.loadedTime,
                duration:_metaObj.duration 
            }));
    }
	
	override protected function onGotMetaData(e:BaseVideoEvent):void 
	{
				dispatchEvent(new BaseVideoEvent(BaseVideoEvent.GOT_METADATA, e.data));
	}
	
    override protected function onNetStatus(e:NetStatusEvent):void
	{
		trace(e.info.code);
		switch (e.info.code){
			case "NetConnection.Connect.Success":
				break;
			case "NetStream.Play.Start":
				//this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.PLAY_START));
				break;
			case "NetStream.Buffer.Empty":
					
                    if ((_startKey as XUERSIKeyinfo).index == (_indexHandler.clips.length -1)  && _us.isComplete){
                        setState(HTTPStreamingState.STOP);
						setStatus(PlayStatus.STOPPED);
						this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.PLAY_OVER));
						return ;
					};
					if (_state != HTTPStreamingState.STOP){
                        setStatus(PlayStatus.BUFFERING);
                        this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.BUFFER_EMPTY));
                    };
			
				break;
			case "NetStream.Buffer.Full":
				this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.BUFFER_FULL));
				break;
			case "NetStream.Play.Stop":
				//this.dispatchEvent(new BaseVideoEvent(BaseVideoEvent.PLAY_OVER));
				break;
			case "NetStream.Seek.Notify":
				break;
			case "NetStream.Seek.InvalidTime":
				break;
		}
	}	
	
	override protected function onIOError(e:IOErrorEvent):void 
	{
		this.dispatchEvent(new XUERSIVideoEvents(XUERSIVideoEvents.GETXVESERROR,'下载xves失败'));		
		super.onIOError(e);
	}
	
	override public function get nstime():int {
            return (_ns.time+_seekKeyinfo.time/1000);
    }       
	
	override public function get loadedTime():int 
	{
		if (indexHandler)
		{
			return (_startKey.size+_savedBytes.length)/_metaObj.filesize*indexHandler.duration;		
		}
		return 0;
	}
	
	public function set metaObj(meta:MetaData):void
	{
		_metaObj = meta 
	}
	
	public function get bufferTime():int 
	{
		return _bufferTime;
	}
	

	
	public function set bufferTime(value:int):void 
	{
		_bufferTime = value;
	}
	
	public function get time_out():int 
	{
		return _time_out;
	}
	
	public function set time_out(value:int):void 
	{
		_time_out = value;
		if (_us)
		{
			_us.time_out = _time_out;
		}
	}
	
	}
}