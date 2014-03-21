
package com.ablesky.vcore.model.vo {

    public class Clip {

        private var _startKey:KeyInfo;
        private var _endKey:KeyInfo;

        public function get startKey():KeyInfo{
            return (this._startKey);
        }
        public function set startKey(_arg1:KeyInfo):void{
            this._startKey = _arg1;
        }
        public function get endKey():KeyInfo{
            return (this._endKey);
        }
        public function set endKey(_arg1:KeyInfo):void{
            this._endKey = _arg1;
        }

    }
}
