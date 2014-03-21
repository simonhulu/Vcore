package com.ablesky.vcore.model.vo 
{
	/**
	 * ...
	 * @author szhang
	 */
	public class XUERSIKeyinfo extends KeyInfo 
	{
		protected var _index:int ;
		public function XUERSIKeyinfo(size:uint=0,time:Number=0,index:int=0) 
		{
			_index = index ;
			super(size,time);
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
		}
		
	}

}