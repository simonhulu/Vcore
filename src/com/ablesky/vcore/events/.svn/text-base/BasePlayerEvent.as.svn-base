package com.ablesky.vcore.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author szhang
	 */
	public class BasePlayerEvent extends Event 
	{
	    protected var _data:Object;	
		public function BasePlayerEvent(type:String,data:Object, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		public function get data():Object {
			return _data;
		}
		
	}

}