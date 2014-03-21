package 
{
	import com.ablesky.asUi.display.SpriteUI;
	import com.ablesky.vcore.model.flv.FLVHeader;
	import com.ablesky.vcore.model.flv.FLVParser;
	import com.ablesky.vcore.model.flv.FLVTag;
	import com.ablesky.vcore.model.vo.KeyInfo;
	import com.ablesky.vcore.video.BaseVideo;
	import com.ablesky.vcore.video.BytesVideo;
	import com.ablesky.vcore.video.HttpSegmentBytesVideo;
	import com.ablesky.vcore.video.HttpVideo;
	import com.ablesky.vcore.video.XuersiVideo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.net.NetStreamAppendBytesAction;
	
	/**
	 * 工程说明,该工程为视频播放的核心,基于playList的架构
	 * 核心是NetStream，在他之上是VideoStreamManage
	 * NetStream分为两种Http和Bytes
	 * ...
	 * @author szhang
	 */
	public class Main extends Sprite 
	{
		//var video:HttpVideo = new HttpVideo();		
		//var baseVideo:BytesVideo = new BytesVideo();
		//private var flvParser:FLVParser = new FLVParser(true);;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			var video:XuersiVideo = new XuersiVideo();
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//video.play('http://127.0.0.1/vod/a.flv',new KeyInfo());
			//video.width = 640;
			//video.height = 360 ;
			//video.play("http://127.0.0.1/1109HJKCX5ASQHLN410040.mp4",new KeyInfo(),new KeyInfo());
			//addChild(video);
			//baseVideo.addEventListener(MouseEvent.CLICK, onClick);
			//var url:String = "http://127.0.0.1/vod/a.flv";
			//var urlload:URLStream = new URLStream();
			//urlload.addEventListener(Event.COMPLETE, onComplete);
			//urlload.load(new URLRequest(url));
			 //var sp:SpriteUI = new SpriteUI();
			 //sp.graphics.beginFill(0x00ff00, 1);
			 //sp.graphics.drawRect(0, 0, 100, 100);
			 //sp.graphics.endFill();
			 //this.addChild(sp);
			//sp.addEventListener(MouseEvent.CLICK, onClickb);
			//
			//video.addEventListener(MouseEvent.CLICK, onClick);
			 //var sp2:SpriteUI = new SpriteUI();
			 //sp2.graphics.beginFill(0x00ff00, 1);
			 //sp2.graphics.drawRect(0, 0, 100, 100);
			 //sp2.graphics.endFill();
			 //this.addChild(sp2);
			 //sp2.x = 300;
			 //sp2.y = 300 ;
			//sp2.addEventListener(MouseEvent.CLICK, onClickc);				
		}
		
		//private function onComplete(e:Event):void
		//{
			//var urlstream:URLStream = e.target as URLStream
			//var bytes:ByteArray = new ByteArray();
			//urlstream.readBytes(bytes);
					//var header:FLVHeader = new FLVHeader();
					//var headerBytes:ByteArray = new ByteArray();
					//header.write(headerBytes);
			//baseVideo.ns.appendBytes(headerBytes);		
			//flvParser.parse(bytes, true, flvTagHandler);
		//}
		
		//private function flvTagHandler(tag:FLVTag):Boolean
		//{
			//var bytes:ByteArray = new ByteArray();
			//tag.write(bytes);		
			//switch(tag.tagType)
			//{
				//case FLVTag.TAG_TYPE_AUDIO:
					//baseVideo.ns.appendBytes(bytes);			
					//break;
				//case FLVTag.TAG_TYPE_VIDEO:
					//baseVideo.ns.appendBytes(bytes);							
					//break;
				//case FLVTag.TAG_TYPE_ENCRYPTED_SCRIPTDATAOBJECT:
					//trace('ENCRYPTED');
					//baseVideo.ns.appendBytes(bytes);						
					//break;
				//case FLVTag.TAG_TYPE_SCRIPTDATAOBJECT:
					//baseVideo.ns.appendBytes(bytes);					
					//break;
			//}
			//return true ;
		//}
		
		//private function onClick(e:MouseEvent):void
		//{
			//trace(baseVideo.ns.time);
			//var file:FileReference = new FileReference();
			//file.save(video.stream, 'aa.flv');
		//}
		
	}
	
}