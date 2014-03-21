package com.ablesky.vcore.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @author szhang
	 */
	public class Bezel extends Sprite 
	{
		protected var currentIcon:DisplayObject;
		protected var _enable:Boolean = true ;		
		public function Bezel() 
		{
	
		}
		
		

		
		public function play(param1:DisplayObject) : void
        {
            if (this.currentIcon && contains(this.currentIcon))
            {
                removeChild(this.currentIcon);
            }// end if
            this.currentIcon = DisplayObject(addChild(param1));
			
            return;
        }// end function

		public function isCurrentIcon(param1:DisplayObject):Boolean
		{
			if (param1 == currentIcon || contains(param1))
			{
				return true ;
			}
			return false;
		}
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			if (!_enable)
			{
				this.mouseChildren = false; 
				this.mouseEnabled = false ;
			}else {
				this.mouseChildren = true; 
				this.mouseEnabled = true ;				
			}
		}		
		
		
	}

}