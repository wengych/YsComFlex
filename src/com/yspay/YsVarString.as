package com.yspay
{
    public class YsVarString extends YsVar
    {
        public function YsVarString(value:String = "", key:String = "")
        {
            super(key);
            var_value = value;
            var_type = "STRING";
        }
        
    }
}