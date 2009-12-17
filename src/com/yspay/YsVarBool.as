package com.yspay
{
    public class YsVarBool extends YsVar
    {
        public function YsVarBool(value:Boolean = false, key:String = "")
        {
            super(key);
            var_value = value;
            var_type = "BOOL";
        }
        protected override function getXmlValue():String
        {
            if (var_value == true)
                return "TRUE";
            else
                return "FALSE";
        }
    }
}