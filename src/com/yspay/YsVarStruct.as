package com.yspay
{
    import flash.utils.ByteArray;
    public class YsVarStruct extends YsVar
    {
        public function YsVarStruct(value:Object = null, key:String="")
        {
            super(key);
            var_value = value;
            if (var_value == null)
                var_value = new Object;
            var_type = "STRUCT";
        }
        public override function toXml():String
        {
            var_xml = new XML('<NODE/>');
            var_xml.@KEY = var_key;
            var_xml.@TYPE = var_type;
            var size:int = 0;
            for each(var item:YsVar in var_value)
            {
                var_xml.appendChild(item.toXml());
                ++size;
            }
            var_xml.@SIZE = size;
            
            return var_xml.toXMLString();
        }
        public override function toString():String
        {
            var rtn:String = var_key + ":";
            
            for each(var ys_var:YsVar in var_value)
            {
                rtn += '\t' + ys_var.toString();
            }
            return rtn;
        }
        public function Add(key:String, ys_var:*):void
        {
            if (ys_var is YsVar)
                AddVar(key, ys_var);
            else if (ys_var is int)
                AddInt(key, ys_var);
            else if (ys_var is Number)
                AddDouble(key, ys_var);
            else if (ys_var is Boolean)
                AddBoolean(key, ys_var);
            else if (ys_var is String)
                AddString(key, ys_var);
            else if (ys_var is ByteArray)
                AddByteArray(key, ys_var);
        }
        public function AddVar(key:String, ys_var:YsVar):void
        {
            var_value[key] = ys_var;
            ys_var.SetKeyName(key);
        }
        public function AddInt(key:String, value:int):void
        {
            var ys_var:YsVarInt = new YsVarInt(value);
            AddVar(key, ys_var);
        }
        public function AddDouble(key:String, value:Number):void
        {
            var ys_var:YsVarDouble = new YsVarDouble(value);
            AddVar(key, ys_var);
        }
        public function AddBoolean(key:String, value:Boolean):void
        {
            var ys_var:YsVarBool = new YsVarBool(value);
            AddVar(key, ys_var);
        }
        public function AddString(key:String, value:String):void
        {
            var ys_var:YsVarString = new YsVarString(value);
            AddVar(key, ys_var);
        }
        public function AddByteArray(key:String, value:ByteArray):void
        {
            var ys_var:YsVarBin = new YsVarBin(value);
            AddVar(key, ys_var);
        }
    }
}