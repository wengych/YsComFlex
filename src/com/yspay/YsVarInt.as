package com.yspay
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
    // Int32
    public class YsVarInt extends YsVar
    {
        public function YsVarInt(value:int = 0, key:String = "")
        {
            super(key);
            var_value = value;
            var_type = "INT";
        }
        public override function getXmlValue():String
        {
        	var rtn:String = "";
        	var byte_arr:ByteArray = new ByteArray;
        	var value:int = var_value;
        	byte_arr.endian = Endian.LITTLE_ENDIAN;
        	byte_arr.writeInt(value);
        	
        	var tmp:String = "";
        	var first_valid_num:Boolean = false;
            for(var index:int = byte_arr.length; index > 0; --index)
            {
                var v_b:int = byte_arr[index-1];
                if (first_valid_num == false && v_b == 0)
                    continue;
                first_valid_num = true;
                tmp += v_b.toString(16);
            }
            if (tmp == "")
                rtn += '0';
            else
                rtn += tmp;
        	return rtn;
        }
    }
}
