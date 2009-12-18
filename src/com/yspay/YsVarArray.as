package com.yspay
{
    public class YsVarArray extends YsVar
    {
        public function YsVarArray(value:Array = null, key:String="")
        {
            super(key);
            var_value = value;
            if (var_value == null)
                var_value = new Array;
            var_type = "ARRAY";
        }
        public override function toXml():String
        {
            var_xml = new XML('<NODE/>');
            var_xml.@KEY = var_key;
            var_xml.@TYPE = var_type;
            var child_xml_str:String;
            
            for each(var item:YsVar in var_value)
            {
                child_xml_str = item.toXml();
                var_xml.appendChild(child_xml_str);
            }
            // var_xml.@LEN = array_size;
            var_xml.@MAX = 16777215;
            
            return var_xml.toXMLString();
        }
        public function push(item:YsVar):void
        {
            item.SetKeyName(var_key);
            var_value.push(item);
        }
        public function GetAll():Array
        {
            return var_value;
        }
        public function GetAt(idx:int):*
        {
            return var_value[idx];
        }
        public override function SetKeyName(key:String):void
        {
            super.SetKeyName(key);
            for each(var item:YsVar in var_value)
            {
                item.SetKeyName(key);
            }
        }
    }
}