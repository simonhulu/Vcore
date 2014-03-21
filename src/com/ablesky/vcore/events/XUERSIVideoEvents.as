package com.ablesky.vcore.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author szhang
	 */
	public class XUERSIVideoEvents extends BasePlayerEvent 
	{
		public static const DECRYPTERROR:String = "decrypterror";
		public static const GETXVES_TIMEOUT_ERROR:String = 'getxves_time_out_error';
		public static const GETXVESERROR:String = 'getxves_error';
		public static const GETXVES_TIMEOUT30_ERROR:String = 'getxves_30';
		private var _type:String;
		public function XUERSIVideoEvents(type:String,data:Object, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			_type = type;
			_data = data;
			super(type, data, bubbles, cancelable);
		}
		
		override public function clone():Event 
		{
			return new XUERSIVideoEvents(_type,_data,false,false);
		}
		
	}

}