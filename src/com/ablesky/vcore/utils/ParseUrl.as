
package com.ablesky.vcore.utils {

    public class ParseUrl {

        public function ParseUrl(){
            super();
        }
        public static function getLoaderInfourl(url:String):String{
            var endIndex:int = url.lastIndexOf("/");
            return (url.slice(0, endIndex));
        }
        public static function getDomain(url:String):String{
            if (((!(url)) || ((url == "")))){
                return ("");
            };
            var slashIndex:int = url.indexOf("//");
            var endIndex:int = url.indexOf("/", (slashIndex + 2));
            return (url.slice(0, endIndex));
        }

    }
}//package com.ablesky.asUi.utils 
