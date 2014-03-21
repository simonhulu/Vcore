
package com.ablesky.vcore.net.httpstreaming {
    import flash.events.*;
    import flash.utils.*;
    import com.ablesky.vcore.model.vo.*;
    import flash.net.*;
    import com.ablesky.vcore.utils.*;

    public class HTTPStreamingIndexHandlerBase extends EventDispatcher {

        private var _videoFileUrl:String = "";
        private var _keyframes:Array;
        private var _duration:Number;
        private var _filesize:Number;
        private var _initStartKey:KeyInfo;
        private var _initEndKey:KeyInfo;
        private var _metaDataAndFirstAudioAndFirst:ByteArray;

        public function HTTPStreamingIndexHandlerBase(url:String, keyFrames:Array=null, duration:Number=0, initKey:KeyInfo=null, initEndKey:KeyInfo=null){
            this._videoFileUrl = url;
            this._keyframes = keyFrames;
            this._duration = duration;
            this._initStartKey = initKey;
            this._initEndKey = initEndKey;
        }
        public function getFileForTime(_arg1:int, _arg2:Array, _arg3:KeyInfo, _arg4:String=null):URLRequest{
            var _local6:KeyInfo;
            var _local5:KeyInfo = _arg3;
            if (_arg2){
                _local6 = KeyInfoUtil.getEndKey(_arg3, _arg2, _arg1);
            } else {
                _local6 = this._initEndKey;
            };
            var _local7:String = ((((this._videoFileUrl + "&start=") + _local5.size) + "&end=") + _local6.size);
            if (_arg4){
                _local7 = (_local7 + ("&" + _arg4));
            };
            return (new URLRequest(_local7));
        }
        public function getNextFile(_arg1:KeyInfo, _arg2:int, _arg3:Array, _arg4:String=null):Object{
            var _local5:KeyInfo = _arg1;
            var _local6:KeyInfo = KeyInfoUtil.getEndKey(_local5, _arg3, _arg2);
            var _local7:Object = new Object();
            var _local8:String = ((((this._videoFileUrl + "&start=") + _local5.size) + "&end=") + _local6.size);
            if (_arg4){
                _local8 = (_local8 + ("&" + _arg4));
            };
            _local7.urlrequest = new URLRequest(_local8);
            _local7.startKey = _local5;
            _local7.endKey = _local6;
            return (_local7);
        }
        public function getClips(_arg1:int, _arg2:Array):Array{
            var _local5:KeyInfo;
            var _local6:Clip;
            var _local3:KeyInfo = new KeyInfo();
            var _local4:Array = new Array();
            while (true) {
                _local5 = KeyInfoUtil.getEndKey(_local3, _arg2, _arg1);
                _local6 = new Clip();
                _local6.startKey = _local3;
                _local6.endKey = _local5;
                _local4.push(_local6);
                _local3 = _local5;
                if (_local5 == KeyInfoUtil.getMaxKeyinfo(_arg2)){
                    break;
                };
            };
            return (_local4);
        }
		

		
		
        public function get videoFileUrl():String{
            return (this._videoFileUrl);
        }
        public function set videoFileUrl(_arg1:String):void{
            this._videoFileUrl = _arg1;
        }
        public function get keyframes():Array{
            return (this._keyframes);
        }
        public function set keyframes(_arg1:Array):void{
            this._keyframes = _arg1;
        }
        public function get duration():Number{
            return (this._duration);
        }
        public function set duration(_arg1:Number):void{
            this._duration = _arg1;
        }
        public function get filesize():Number{
            return (this._filesize);
        }
        public function set filesize(_arg1:Number):void{
            this._filesize = _arg1;
        }
        public function get initStartKey():KeyInfo{
            return (this._initStartKey);
        }
        public function set initStartKey(_arg1:KeyInfo):void{
            this._initStartKey = _arg1;
        }
        public function get initEndKey():KeyInfo{
            return (this._initEndKey);
        }
        public function set initEndKey(_arg1:KeyInfo):void{
            this._initEndKey = _arg1;
        }
        public function get metaDataAndFirstAudioAndFirst():ByteArray{
            return (this._metaDataAndFirstAudioAndFirst);
        }
        public function set metaDataAndFirstAudioAndFirst(_arg1:ByteArray):void{
            this._metaDataAndFirstAudioAndFirst = _arg1;
        }

    }
}
