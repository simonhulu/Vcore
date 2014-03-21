package com.ablesky.vcore.interfaces 
{
	import com.ablesky.vcore.model.vo.KeyInfo;
	
	/**
	 * ...
	 * @author szhang
	 */
	public interface IPlayCore 
	{
		function seek(time:int):void;
		function play(url:String,startKey:KeyInfo,endKey:KeyInfo=null):void;
		function pause():void;
		function resume():void;
		function close():void;
	}
	
}