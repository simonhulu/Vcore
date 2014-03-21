package com.ablesky.vcore.model.vo 
{
	/**
	 * ...
	 * @author szhang
	 */
	public class PlayListItem 
	{
		private var _url:String
		private var _isUsed:Boolean = false
		private var _startKeyInfo:KeyInfo;
		private var _endKeyInfo:KeyInfo;
		public function PlayListItem() 
		{
			
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		public function set url(value:String):void 
		{
			_url = value;
		}
		
		public function get isUsed():Boolean 
		{
			return _isUsed;
		}
		
		public function set isUsed(value:Boolean):void 
		{
			_isUsed = value;
		}
		
		public function get startKeyInfo():KeyInfo 
		{
			return _startKeyInfo;
		}
		
		public function set startKeyInfo(value:KeyInfo):void 
		{
			_startKeyInfo = value;
		}
		
		public function get endKeyInfo():KeyInfo 
		{
			return _endKeyInfo;
		}
		
		public function set endKeyInfo(value:KeyInfo):void 
		{
			_endKeyInfo = value;
		}
		
	}

}