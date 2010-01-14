package com.yspay
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    // Int32
    public class YsVarInt extends YsVar
    {
        public function YsVarInt(value:int=0, key:String="")
        {
            super(key);
            var_value = value;
            var_type = "INT32";
            var_type_number = 4;
        }

        protected override function getBinValue():String
        {
            var rtn:String = "";
            var byte_arr:ByteArray = new ByteArray;
            var value:int = var_value;
            byte_arr.endian = Endian.BIG_ENDIAN;
            byte_arr.writeInt(value);

            for (var index:int = 0; index < byte_arr.length; ++index)
            {
                var v_b:int = byte_arr[index];
                if (v_b < 16)
                    rtn += '0';
                rtn += v_b.toString(16);
            }
            return rtn;
        }

        public override function fromXmlValue(value:String):void
        {
            var byte_arr:ByteArray = new ByteArray;
            byte_arr.endian = Endian.BIG_ENDIAN;
            var v_b:int;
            var tmp:String;

            for (var index:int = 0; index < value.length; ++index)
            {
                tmp = '0x';
                tmp += value.charAt(index) + value.charAt(++index);
                v_b = int(tmp);
                byte_arr.writeByte(v_b);
            }
            byte_arr.position = 0;
            var_value = byte_arr.readInt();
        }

        public override function Pack():ByteArray
        {
            var_pack = new ByteArray;
            var_pack.endian = Endian.BIG_ENDIAN;

            var_len_of_all = 4 /*length of itself*/ + 2 /*length of len_of_key*/ + var_key.length + 4 /*length of an int*/;
            var_len_of_key_h = var_key.length / 0xff;
            var_len_of_key_l = var_key.length % 0xff;

            var_pack.writeByte(var_type_number);
            var_pack.writeInt(var_len_of_all);
            var_pack.writeByte(var_len_of_key_h);
            var_pack.writeByte(var_len_of_key_l);

            var_pack.writeMultiByte(var_key, '');
            var_pack.writeInt(var_value);

            return var_pack;
        }
    }
}
