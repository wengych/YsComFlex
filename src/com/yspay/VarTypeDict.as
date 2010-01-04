package com.yspay
{
    import flash.utils.Dictionary;
    
    public class VarTypeDict 
    {
        protected static var dict:Dictionary;
        protected static var is_dict_init:Boolean = false;
        public function VarTypeDict()
        {
            if (!is_dict_init)
                InitDict();
        }
        protected static function InitDict():void
        {
            /*
            dict["BOOL"]   = 1;
            dict["INT32"]  = 4;
            dict["BIN"]    = 7;
            dict["STRING"] = 8;
            dict["STRUCT"] = 10;
            dict["ARRAY"]  = 101;
            dict["HASH"]   = 105;
            */
            dict = new Dictionary;
            dict[1]     = 'BOOL';
            dict[4]     = 'INT32';
            dict[7]     = 'BIN';
            dict[8]     = 'STRING';
            dict[10]    = 'STRUCT';
            dict[101]   = 'ARRAY';
            dict[105]   = 'HASH';
            is_dict_init = true;
        }
        public static function FindType(type_info:*):String
        {
            if (!is_dict_init)
                InitDict();
            return dict[type_info];
        }
    }
}
