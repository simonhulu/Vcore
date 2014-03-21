package com.ablesky.vcore.model.vo
{
	public class KeyInfo
	{
		protected var _size:uint =0;
		protected var _time:Number =0;
		public function KeyInfo(size:uint=0,time:Number=0)
		{
			_size = size;
			_time = time
		}

		public function get size():uint
		{
			return _size;
		}

		public function set size(value:uint):void
		{
			_size = value;
		}

		public function get time():Number
		{
			return _time;
		}

		public function set time(value:Number):void
		{
			_time = value;
		}


	}
}