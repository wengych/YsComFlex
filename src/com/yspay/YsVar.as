package com.yspay
{
    import flash.utils.ByteArray;

    public class YsVar
    {
        protected var var_key:String;
        protected var var_value:*;
        protected var var_type:String;
        protected var var_xml:XML;

        protected var var_pack:ByteArray;
        protected var var_type_number:int;
        protected var var_len_of_all:int;
        protected var var_len_of_key_h:int; /*高位*/
        protected var var_len_of_key_l:int; /*低位*/

        public function YsVar(key:String="")
        {
            var_key = key;
            var_type = "VAR";
            var_xml = new XML('<NODE />');
        }

        public function SetKeyName(key:String):void
        {
            var_key = key;
        }

        public function GetKeyName():String
        {
            return var_key;
        }

        public function getValue():*
        {
            return var_value;
        }

        public function get value():*
        {
            return getValue();
        }

        public function toLocalString():String
        {
            var rtn:String = "{" + var_key + " = '";
            if (var_value == null)
                rtn += 'value is null';
            else
                rtn += var_value;
            rtn += "' } ";

            return rtn;
        }

        public function toString():String
        {
            return var_value.toString();
        }

        protected function getBinValue():String
        {
            if (var_value == null)
                return "";

            return var_value.toString();
        }

        public function fromXmlValue(value:String):void
        {
            return;
        }

        public function toXml():String
        {
            var_xml = new XML('<NODE/>');
            var_xml.@KEY = var_key;
            var_xml.@TYPE = var_type;
            var_xml.text()[0] = getBinValue();

            return var_xml.toXMLString();
        }

        public function Pack():ByteArray
        {
            return null;
        }
    }
}
