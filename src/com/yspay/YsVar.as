package com.yspay
{
    
    public class YsVar
    {
        protected var var_key:String;
        protected var var_value:*;
        protected var var_type:String;
        public function YsVar(key:String = "")
        {
            var_key = key;
            var_type = "VAR";
        }
        
        public function SetKeyName(key:String):void
        {
            var_key = key;
        }
        
        public function toString():String
        {
            var rtn:String =  "[" + var_key + " = '";
            if (var_value == null)
                rtn += 'value is null';
            else
                rtn += var_value;
            rtn += "'] ";
            
            return rtn;
        }
        public function getXmlValue():String
        {
            if (var_value == null)
                return "";
            
            return var_value.toString();
        }
        public function toXml():String
        {
            //<NODE KEY="mykey-7:--var" TYPE="STRING" LEN="5">--var1</NODE>
            var rtn:String = '<NODE KEY="'; 
            rtn += var_key;
            rtn += '" TYPE="';
            rtn += var_type;
            rtn += '">';
            rtn += getXmlValue();
            rtn += '</NODE>\n';
            
            return rtn;
        }
    }
}
