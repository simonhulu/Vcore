package com.ablesky.vcore.model.vo 
{
	import com.ablesky.vcore.events.BaseVideoEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author szhang
	 */
	public class MetaData extends EventDispatcher 
	{
		protected var _video_Height:Number;
		protected var _video_width:Number;
		protected var _duration:Number = 0;
		protected var _keyFrameFilePositions:Array;
		protected var _keyFrameTimes:Array;
		protected var _filesize:uint =0;
		protected var _data:Object;
		protected var _keyFrames:Array  ;
		protected var _videoRate:int;
		protected static const VIDEO_HEIGHT_TAG_NAME:String   = "height";
		protected static const FILE_SIZE_TAG_NAME:String      = "filesize";
		protected static const VIDEO_WIDTH_TAG_NAME:String    = "width";
		protected static const VIDEO_DURATION_TAG_NAME:String = "duration";
		protected static const H264_KEYFRAMES_TAG_NAME:String = "seekpoints";
		protected static const FLV_KEYFRAMES_TAG_NAME:String  = "keyframes";
		protected static const HAS_AUDIO:String               = "hasAudio";
		protected static const HAS_VIDEO:String               = "hasVideo";		
		protected static const VIDEODATARATE:String           = 'videodatarate';
		protected var mp4:Boolean = false;
		public function MetaData() 
		{
			
		}
		
		public function onXMPData(infoObject:Object):void
		{
		}
		
		public function onBWDone(infoObject:Object):void
		{
			
		}
		
		public function onCuePoint(infoObject:Object):void
		{
			
		}
		
		public function onCaption(cps:String, spk:Number):void
		{
			
		}
		
		public function onCaptionInfo(obj:Object):void
		{
			
		}
		
		public function onLastSecond(infoObject:Object):void
		{
			
		}
		
		public function onPlayStatus(infoObject:Object):void
		{
			
		}
		
		public function onImageData(obj:Object):void
		{
			
		}
		
		public function RtmpSampleAccess(obj:Object):void
		{
			
		}
		
		public function onTextData(obj:Object):void
		{
			
		}
		
		public function onMetaData(infoObject:Object):void
		{
			
//			if(_keyFrames ==  null)
//			{
				_data= infoObject; 
				if(data.hasOwnProperty(VIDEO_WIDTH_TAG_NAME))
				{
					_video_width = Number(data[VIDEO_WIDTH_TAG_NAME]);
				}
				if(data.hasOwnProperty(VIDEO_HEIGHT_TAG_NAME))
				{
					_video_Height = Number(data[VIDEO_HEIGHT_TAG_NAME]);
				}
				if(data.hasOwnProperty(VIDEO_DURATION_TAG_NAME))
				{
					_duration = Number(data[VIDEO_DURATION_TAG_NAME]);
				}
				if(data.hasOwnProperty(FILE_SIZE_TAG_NAME))
				{
					_filesize = Math.max(data[FILE_SIZE_TAG_NAME],0);
				}
				if (data.hasOwnProperty(VIDEODATARATE))
				{
					_videoRate = Math.floor(data[VIDEODATARATE]);
				}
				if(data.hasOwnProperty(HAS_AUDIO)&&data.hasOwnProperty(HAS_VIDEO))
				{
					if( data[HAS_AUDIO] == true && data[HAS_VIDEO] == false )
					{
					}
				}
				parseKeyFrames(_data);
				//发送
				//playAfterMetaData();
				//stage.addEventListener(MouseEvent.CLICK,onClick);

				dispatchEvent(new BaseVideoEvent(BaseVideoEvent.GOT_METADATA, _data));
				trace('onMeta');
//			}
		}

		public function parseKeyFrames(data:Object):void
		{
			var keyInfo:KeyInfo;
			var keyFrameFilePositions:Array;
			var keyFrameTimes:Array;
			var currentSize:uint =0;
			var currentTime:Number =0;
			var seekpoints:Array = data.seekpoints;
			if(seekpoints)
			{
				mp4 = true ;
				_keyFrames =  new Array();
				//为mp4容器
				for(var i:int;i<seekpoints.length;i++)
				{
					keyInfo = new KeyInfo();
					keyInfo.size = seekpoints[i].offset;
					keyInfo.time = seekpoints[i].time;
					//如果都比零小 退出本次循环
					if(keyInfo.size <=0 || keyInfo.time <=0)
					{
						continue;
					}
					if(keyInfo.size<=currentSize || keyInfo.time <= currentTime)
					{
						continue;
					}
					currentSize = keyInfo.size;
					currentTime = keyInfo.time;
					_keyFrames.push(keyInfo);
				}
			}else
			{
				keyFrameFilePositions = _data.keyframes.filepositions;
				keyFrameTimes =_data.keyframes.times;
				_keyFrames =  new Array();
				for(var j:int=0;j<keyFrameFilePositions.length;j++)
				{
					keyInfo = new KeyInfo();
					keyInfo.size = keyFrameFilePositions[i];
					keyInfo.time = keyFrameTimes[i];
					//如果都比零小 退出本次循环
					if(keyInfo.size <=0 || keyInfo.time <=0)
					{
						continue;
					}
					if(keyInfo.size<=currentSize || keyInfo.time <= currentTime)
					{
						continue;
					}
					//trace("keyInfo.time="+keyInfo.time+" keyInfo.size="+keyInfo.size);
					_keyFrames.push(keyInfo);
				}
			}
			//给keyFrames加上最后一个keyInfo,time时间为duration,size为fileSize
			//防止有些视频找不到filesize
			if(_filesize == 0)
			{
				_filesize = (_keyFrames[_keyFrames.length-1] as KeyInfo).size;
			}
			//防止有些视频找不到duration
			if(_duration == 0)
			{
				_duration = (_keyFrames[_keyFrames.length-1] as KeyInfo).time
			}
			
			var lastKeyInfo:KeyInfo = new KeyInfo();
			lastKeyInfo.time = _duration;
			lastKeyInfo.size = _filesize;
			_keyFrames.push(lastKeyInfo);
		}
		


		public function get duration():Number
		{
			return _duration;
		}
		
		
		public function get data():Object
		{
			return _data;
		}

		public function get keyFrames():Array
		{
			return _keyFrames;
		}

		public function get filesize():uint
		{
			return _filesize;
		}


		public function get video_Height():Number
		{
			return _video_Height;
		}

		public function get video_width():Number
		{
			return _video_width;
		}
		
		public function get videoRate():int 
		{
			return _videoRate;
		}

		public function resetData():void
		{
			_video_width = 0;
			_video_Height = 0;
			_duration = 0;
			_filesize = 0;
			_keyFrames = null;
		}
		
		
	}
}
