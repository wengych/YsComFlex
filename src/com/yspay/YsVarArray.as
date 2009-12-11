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
            var array_size:int = 0;
            
            for each(var item:YsVar in var_value)
            {
                var_xml.appendChild(item.toXml());
                ++array_size;
            }
            var_xml.@LEN = array_size;
            
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