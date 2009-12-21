package com.yspay
{
    import flash.utils.ByteArray;
    
    public class YsVarBin extends YsVar
    {
        public function YsVarBin(value:ByteArray = null, key:String="")
        {
            super(key);
            var_value = value;
            if (var_value == null)
                var_value = new ByteArray;
            var_type = "BIN";
        }
        protected override function getBinValue():String
        {
            var rtn:String = "";
            
            for(var index:int = 0; index < var_value.length; ++index)
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
        public override function toString():String
        {
            var rtn:String =  "[" + var_key + " = '";
            if (var_value == null)
                rtn += 'value is null';
            else
                rtn += getBinValue();
            rtn += "'] ";
            
            return rtn;
        }
    }
}