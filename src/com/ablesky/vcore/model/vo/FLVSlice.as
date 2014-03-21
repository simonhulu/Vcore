package com.ablesky.vcore.model.vo 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author szhang
	 */
	public class FLVSlice 
	{
		private static var input:ByteArray;		
		private static var signature:String;
		private static var version:int;
		private static var typeFlagsReserved1:int;
		private static var typeFlagsReserved2:int;
		private static var typeFlagsAudio:int;
		private static var typeFlagsVideo:int;
		private static var dataOffset:int;		
		private static const AUDIO_TAG:int = 0x08;
		private static const VIDEO_TAG:int = 0x09;
		private static const SCRIPT_TAG:int = 0x12;
		private static const SECOND_TAG:int = 0xD;
		private static const SIGNATURE:String = "FLV";
		private static const SHORT:int = 0x3;
		private static const METADATA:String = "onMetaData";
		private static const DURATION:String = "duration";		
		public function FLVSlice() 
		{
			
		}
		
		
		public static function getTime(bytes:ByteArray):int
		{
			input = bytes;
			input.position = 0;
			signature = input.readUTFBytes(3);
			if ( signature != SIGNATURE ) throw new Error("Not a valid FLV file!.");
			version = input.readByte();
			var infos:int = input.readByte();
			typeFlagsReserved1 = (infos >> 3);
			typeFlagsAudio = ((infos & 0x4 ) >> 2);
			typeFlagsReserved2 = ((infos & 0x2 ) >> 1);
			typeFlagsVideo = (infos & 0x1);
			dataOffset = input.readUnsignedInt();
			input.position += 4;
			var currentPos:int = input.position;
			var offset:int; 
			var end:int;
			var tagLength:int;
			var currentTag:int;
			var step:int;
			var fb:int;
			var time:int;
			var keyframe:int;
			var timestampExtended:int;
			var streamID:int;
			var soundFormat:int;
			var soundRate:int;
			var soundSize:int;
			var soundType:int;
			var codecID:int;
			while ( input.bytesAvailable > 0 )
			{
				offset = input.position; 
				currentTag = input.readByte();
				step = (input.readUnsignedShort() << 8) | input.readUnsignedByte();
				time = ((input.readUnsignedShort() << 8) | input.readUnsignedByte());
				timestampExtended = input.readUnsignedByte();
				streamID = ((input.readUnsignedShort() << 8) | input.readUnsignedByte());
				fb = input.readByte();
				end = input.position + step + 3;
				tagLength = end - offset;
				if (currentTag == VIDEO_TAG)
				{
					input.position = end;
					return time;
				}
				input.position = end;				
			}
			return 0;
		}
		
	}

}