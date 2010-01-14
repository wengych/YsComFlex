package com.yspay
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class YsVarString extends YsVar
    {
        public function YsVarString(value:String="", key:String="")
        {
            super(key);
            var_value = value;
            var_type = "STRING";
            var_type_number = 8;
        }

        public override function toXml():String
        {
            var_xml = new XML('<NODE/>');
            var_xml.@KEY = var_key;
            var_xml.@TYPE = var_type;
            var_xml.@LEN = var_value.length;
            var_xml.text()[0] = getBinValue();

            return var_xml.toXMLString();
        }

        public override function Pack():ByteArray
        {
            var_pack = new ByteArray;
            var_pack.endian = Endian.BIG_ENDIAN;

            var_len_of_all = 4 /*length of itself*/ + 2 /*length of len_of_key*/ + var_key.length + var_value.length;
            var_len_of_key_h = var_key.length / 0xff;
            var_len_of_key_l = var_key.length % 0xff;

            var_pack.writeByte(var_type_number);
            var_pack.writeInt(var_len_of_all);
            var_pack.writeByte(var_len_of_key_h);
            var_pack.writeByte(var_len_of_key_l);

            var_pack.writeMultiByte(var_key, '');
            var_pack.writeMultiByte(var_value, '');

            return var_pack;
        }
    }
}