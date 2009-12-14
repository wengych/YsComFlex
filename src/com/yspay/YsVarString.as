package com.yspay
{
    public class YsVarString extends YsVar
    {
        public function YsVarString(value:String = "", key:String = "")
        {
            super(key);
            var_value = value;
            var_type = "STRING";
        }
        public override function toXml():String
        {
            var_xml = new XML('<NODE/>');
            var_xml.@KEY = var_key;
            var_xml.@TYPE = var_type;
            var_xml.@LEN = var_value.length;
            var_xml.text()[0] = getXmlValue();
            
            return var_xml.toXMLString();
        }
    }
}