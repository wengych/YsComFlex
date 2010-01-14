package com.yspay
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class YsVarBin extends YsVar
    {
        public function YsVarBin(value:ByteArray=null, key:String="")
        {
            super(key);
            var_value = value;
            if (var_value == null)
                var_value = new ByteArray;
            var_type = "BIN";
            var_type_number = 0x07;
        }

        protected override function getBinValue():String
        {
            var rtn:String = "";

            for (var index:int = 0; index < var_value.length; ++index)
            {
                var byte:int = var_value[index];
                if (byte < 16)
                    rtn += '0';
                rtn += byte.toString(16);
            }

            return rtn;
        }

        public override function fromXmlValue(value:String):void
        {
            var v_b:int;
            var tmp:String;

            for (var index:int = 0; index < value.length; ++index)
            {
                tmp = '0x';
                tmp += value.charAt(index) + value.charAt(++index);
                v_b = int(tmp);
                var_value.writeByte(v_b);
            }
        }

        public override function toLocalString():String
        {
            var rtn:String =  "[" + var_key + " = '";
            if (var_value == null)
                rtn += 'value is null';
            else
                rtn += getBinValue();
            rtn += "'] ";

            return rtn;
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