package com.yspay
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    public class YsVarArray extends YsVar
    {
        public function YsVarArray(value:Array = null, key:String="")
        {
            super(key);
            var_value = value;
            if (var_value == null)
                var_value = new Array;
            var_type = "ARRAY";
            var_type_number = 0x65;
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
        
        public override function Pack():ByteArray
        {
            var array_max_length:int = 0xffffff;
            
            var_pack = new ByteArray;
            var_pack.endian = Endian.BIG_ENDIAN;
            
            var_len_of_all = 4/*length of itself*/
                + 2/*length of len_of_key*/
                + var_key.length
                + 4/*length of max*/
                + 4/*length of size*/;
            var_len_of_key_h = var_key.length / 0xff;
            var_len_of_key_l = var_key.length % 0xff;
            
            var_pack.writeByte(var_type_number);
            var_pack.writeInt(var_len_of_all);
            var_pack.writeByte(var_len_of_key_h);
            var_pack.writeByte(var_len_of_key_l);
            
            var_pack.writeMultiByte(var_key, '');
            var_pack.writeInt(array_max_length);
            var_pack.writeInt(var_value.length);
            
            return var_pack;
        }
    }
}