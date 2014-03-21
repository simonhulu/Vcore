package com.ablesky.vcore.net.httpstreaming 
{
	import com.ablesky.vcore.model.vo.KeyInfo;
	import com.ablesky.vcore.model.vo.XUERSIKeyinfo;
	import com.ablesky.vcore.utils.KeyInfoUtil;
	import com.ablesky.vcore.utils.XUERSIKeyinfoUtil;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author szhang
	 */
	
	public class XUERSIHTTPStreamingIndexHandlerBase extends EventDispatcher 
	{
		private var _keyFrames:Array;
		private var _clips:Array;
		private var _url:String;
		private var _encryptions:Array;
		private var _duration:Number;
		private var _hostsPath:Array;
		public function XUERSIHTTPStreamingIndexHandlerBase(url:String, keyFrames:Array=null, duration:Number=0,clips:Array=null,encryptions:Array = null ) 
		{
			_keyFrames = keyFrames;
			_url  = url ;
			_clips = clips ;
			_encryptions = encryptions ;
			_duration = duration ;
		}
		
		public function getFileForTime(seekTime:int):Object
		{
			var key:KeyInfo = XUERSIKeyinfoUtil.getLastKeyByTime(seekTime, _keyFrames);
			var urlrequest:URLRequest = new URLRequest(_url +_clips[(key as XUERSIKeyinfo).index]);
			var startKeyinfo:XUERSIKeyinfo = XUERSIKeyinfoUtil.getLastKeyByIndex((key as XUERSIKeyinfo).index,_keyFrames);			
			return {urlrequest:urlrequest,startKey:startKeyinfo};
		}
		
		public function getNextFile(lastClipIndex:int):Object
		{
			var clipIndex:int = lastClipIndex + 1 ;
			var startKeyinfo:XUERSIKeyinfo = XUERSIKeyinfoUtil.getLastKeyByIndex(clipIndex, _keyFrames);
			if (!startKeyinfo)
			{
				return null;
			}
			var urlrequest:URLRequest = new URLRequest(_url +_clips[(startKeyinfo as XUERSIKeyinfo).index]);
			
			return {urlrequest:urlrequest,startKey:startKeyinfo};
		}
		
		public function get encryptions():Array 
		{
			return _encryptions;
		}
		
		public function get duration():Number 
		{
			return _duration;
		}
		
		public function get clips():Array 
		{
			return _clips;
		}
		
		public function get keyFrames():Array 
		{
			return _keyFrames;
		}
		
		public function get hostsPath():Array 
		{
			return _hostsPath;
		}
		
		public function set hostsPath(value:Array):void 
		{
			_hostsPath = value;
		}
		
		
		
		
		
		
	}

}