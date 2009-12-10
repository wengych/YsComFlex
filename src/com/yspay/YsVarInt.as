package com.yspay
{
    // Int32
    public class YsVarInt extends YsVar
    {
        public function YsVarInt(value:int = 0, key:String = "")
        {
            super(key);
            var_value = value;
            var_type = "INT";
        }
        
    }
}
