package com.yspay
{
    public class YsVarDouble extends YsVar
    {
        public function YsVarDouble(value:Number = 0.0, key:String = "")
        {
            super(key);
            var_value = value;
            var_type = "DOUBLE";
        }
        
    }
}