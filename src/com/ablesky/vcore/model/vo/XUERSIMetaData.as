package com.ablesky.vcore.model.vo 
{
	/**
	 * ...
	 * @author szhang
	 */
	public class XUERSIMetaData extends MetaData 
	{
		private var _clips:Array;
		public function XUERSIMetaData() 
		{
			
		}
		
		override public function onMetaData(infoObject:Object):void 
		{
			_video_width = infoObject.BaseInfo.@VideoWidth;
			_video_Height = infoObject.BaseInfo.@VideoHeight; 
			_filesize = infoObject.BaseInfo.@FileSize;
			_duration = infoObject.BaseInfo.@Duration;
			parseKeyFrames(infoObject);
		}
		
		override public function parseKeyFrames(xml:Object):void 
		{
			var item:XML;
			_clips = new Array();
			_keyFrames = new Array();
			for each (item in xml..FC) 	
			{
				clips.push(item.@URL);
			}
			trace("length======"+clips.length);
			
			for each(item in xml..i)
			{
				var itemString:String = item.toString();
				var index:int = itemString.split(":")[0];
				var position:Number = itemString.split(":")[1];
				var time:Number = item.@t;
				var keyonfo:XUERSIKeyinfo = new XUERSIKeyinfo(position, time, index);
				keyFrames.push(keyonfo);
			}
			

		}
		
		public function get clips():Array 
		{
			return _clips;
		}
		
	}

}