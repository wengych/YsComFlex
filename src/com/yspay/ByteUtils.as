package com.yspay
{
    import flash.utils.ByteArray;

    public class ByteUtils
    {
        public function ByteUtils()
        {
        }

        public static function Bytes2String(bytes:ByteArray):String
        {
            if (bytes == null)
                return '';
            var rtn:String = '';
            for (var i:int = 0; i < bytes.length; ++i)
            {
                var v_b:int = bytes[i];
                if (v_b < 16)
                    rtn += '0';
                rtn += v_b.toString(16);

                /*if ((i+1) % 16 == 0)
                   rtn += '\n';
                 else*/
                rtn += ' ';
            }
            return rtn;
        }

        public static function InitByteArray(int_arr:Array):ByteArray
        {
            var byte_arr:ByteArray = new ByteArray;
            for each (var ii:int in int_arr)
            {
                byte_arr.writeByte(ii);
            }

            return byte_arr;
        }

        public static function CompareByteArray(rhs:ByteArray, lhs:ByteArray):Boolean
        {
            if (rhs == null || lhs == null)
                return false;
            if (rhs.length != lhs.length)
                return false;
            for (var idx:int = 0; idx < rhs.length; ++idx)
            {
                if (rhs[idx] != lhs[idx])
                    return false;
            }
            return true;
        }
    }
}