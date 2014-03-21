package com.ablesky.vcore.utils {

    public class BaseUtil {

        public static function formatTime(_arg1:int):String{
            var _local2:int = int((_arg1 / 60));
            var _local3:int = int((_arg1 % 60));
            var _local4:String = ("" + _local2);
            var _local5:String = ("" + _local3);
            if (_local2 < 10){
                _local4 = ("0" + _local2);
            };
            if (_local3 < 10){
                _local5 = ("0" + _local3);
            };
            return (((_local4 + ":") + _local5));
        }
		
		/**
		 * spilt  by . not :
		 * @param	_arg1
		 * @return
		 */
        public static function formatTime2(_arg1:int):String{
            var _local2:int = int((_arg1 / 60));
            var _local3:int = int((_arg1 % 60));
            var _local4:String = ("" + _local2);
            var _local5:String = ("" + _local3);
            if (_local2 < 10){
                _local4 = ("0" + _local2);
            };
            if (_local3 < 10){
                _local5 = ("0" + _local3);
            };
            return (((_local4 + ".") + _local5));
        }		

    }
}
