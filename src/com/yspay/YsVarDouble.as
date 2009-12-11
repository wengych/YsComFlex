package com.yspay
{
    public class YsVarDouble extends YsVar
    {
        import flash.utils.ByteArray;
        import flash.utils.Endian;
        public function YsVarDouble(value:Number = 0.0, key:String = "")
        {
            super(key);
            var_value = value;
            var_type = "DOUBLE";
        }
        public override function getXmlValue():String
        {
        	var rtn:String = "";
        	var byte_arr:ByteArray = new ByteArray;
        	var value:int = var_value;
        	byte_arr.endian = Endian.BIG_ENDIAN;
        	// byte_arr.writeFloat(value);
        	byte_arr.writeDouble(value);
        	
            for(var index:int = 0; index < byte_arr.length; ++index)
            {
                var v_b:int = byte_arr[index];
                if (v_b < 16)
                    rtn += '0';
                rtn += v_b.toString(16);
            }
        	return rtn;
        }
    }
}