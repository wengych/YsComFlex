package com.yspay
{
    public class YsVar
    {
        protected var var_key:String;
        protected var var_value:*;
        protected var var_type:String;
        protected var var_xml:XML;
        public function YsVar(key:String = "")
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
        public function toString():String
        {
            var rtn:String =  "[" + var_key + " = '";
            if (var_value == null)
                rtn += 'value is null';
            else
                rtn += var_value;
            rtn += "'] ";
            
            return rtn;
        }
        public function getXmlValue():String
        {
            if (var_value == null)
                return "";
            
            return var_value.toString();
        }
        public function fromXmlValue(value:String):void
        {
            return ;
        }
        public function toXml():String
        {
            var_xml = new XML('<NODE/>');
            var_xml.@KEY = var_key;
            var_xml.@TYPE = var_type;
            var_xml.text()[0] = getXmlValue();
            
            return var_xml.toXMLString();
        }
    }
}
