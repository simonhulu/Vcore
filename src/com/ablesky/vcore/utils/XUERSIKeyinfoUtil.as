package com.ablesky.vcore.utils 
{
	import com.ablesky.vcore.model.vo.KeyInfo;
	import com.ablesky.vcore.model.vo.XUERSIKeyinfo;
	/**
	 * ...
	 * @author szhang
	 */
	public class XUERSIKeyinfoUtil extends KeyInfoUtil 
	{
		
		public function XUERSIKeyinfoUtil() 
		{
			
		}
		
		public static function getLastKeyByIndex(index:int,keyFrames:Array):XUERSIKeyinfo
		{
			var i:int = 0 ;
			var len:int = keyFrames.length;
			while (i < len)
			{
				if ((keyFrames[i] as XUERSIKeyinfo).index == index)
				{
					return keyFrames[i] as XUERSIKeyinfo;
				}
				i++;
			}
			return null;
		}
	
		/**
		 * 
		 * @param time
		 * @param keyFrames
		 * @return 
		 * 用于拖拽时,找到前一帧
		 */		
		public static function getLastKeyByTime(time:Number,keyFrames:Array):XUERSIKeyinfo
		{
			for(var i:int;i<keyFrames.length;i++)
			{
				if(((keyFrames[i]) as KeyInfo).time >=time){
					if(i == 0)
					{
						var key:XUERSIKeyinfo = new XUERSIKeyinfo();
						key.size = 0;
						key.time = 0;
						key.index = 0 ;
						return key;
					}
					return keyFrames[i-1] as XUERSIKeyinfo;
				}
			}
			//否则返回最后一个帧
			
			return keyFrames[keyFrames.length-2];
		}		
		
	}

}