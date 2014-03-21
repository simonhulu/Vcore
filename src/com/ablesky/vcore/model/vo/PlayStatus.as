package com.ablesky.vcore.model.vo
{
	public class PlayStatus
	{
		public static const NOINIT:int=0;
		public static const READY:int=3;
		public static const ERROR:int=-1;
		public static const BUFFERING:int=8;
		public static const STOPPED:int=7;
		public static const PLAYING:int=4;
		//为该流初始化数据
		public static const INITED:int=0;
		public static const COMMPLETED:int=6;
		public static const PAUSED:int=5;
		public static const LOADING:int=1;
		public function PlayStatus()
		{
			
		}

		
		
	}
}