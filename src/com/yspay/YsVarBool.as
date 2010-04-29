package com.yspay
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class YsVarBool extends YsVar
    {
        public function YsVarBool(value:Boolean=false, key:String="")
        {
            super(key);
            var_value = value;
            var_type = "BOOL";
            var_type_number = 1;
        }

        protected override function getBinValue():String
        {
            if (var_value == true)
                return "TRUE";
            else
                return "FALSE";
        }

        public override function Pack():ByteArray
        {
            var_pack = new ByteArray;
            var_pack.endian = Endian.BIG_ENDIAN;
            var tmp:int = 0;
            if (var_value == true)
                tmp = 1;

            var_len_of_all = 4 /*length of itself*/ + 2 /*length of len_of_key*/ + var_key.length + 4 /*length of an int*/;
            var_len_of_key_h = var_key.length / 0xff;
            var_len_of_key_l = var_key.length % 0xff;

            var_pack.writeByte(var_type_number);
            var_pack.writeInt(var_len_of_all);
            var_pack.writeByte(var_len_of_key_h);
            var_pack.writeByte(var_len_of_key_l);

            var_pack.writeMultiByte(var_key, char_set);
            // var_pack.writeUTFBytes(var_key);
            var_pack.writeInt(tmp);

            return var_pack;
        }
    }
}
