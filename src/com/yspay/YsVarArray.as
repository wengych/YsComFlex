package com.yspay
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    public class YsVarArray extends YsVar
    {
        public function YsVarArray(value:Array = null, key:String="")
        {
            super(key);
            var_value = value;
            if (var_value == null)
                var_value = new Array;
            var_type = "ARRAY";
            var_type_number = 0x65;
        }
        public override function toXml():String
        {
            var_xml = new XML('<NODE/>');
            var_xml.@KEY = var_key;
            var_xml.@TYPE = var_type;
            var child_xml_str:String;
            
            for each(var item:YsVar in var_value)
            {
                child_xml_str = item.toXml();
                var_xml.appendChild(child_xml_str);
            }
            // var_xml.@LEN = array_size;
            var_xml.@MAX = 16777215;
            
            return var_xml.toXMLString();
        }
        public function push(item:YsVar):void
        {
            item.SetKeyName(var_key);
            var_value.push(item);
        }
        public function GetAll():Array
        {
            return var_value;
        }
        public function GetAt(idx:int):*
        {
            return var_value[idx];
        }
        public override function SetKeyName(key:String):void
        {
            super.SetKeyName(key);
            for each(var item:YsVar in var_value)
            {
                item.SetKeyName(key);
            }
        }
        public function Add(ys_var:*):void
        {
            if (ys_var is YsVar)
                AddVar(ys_var);
            else if (ys_var is int)
                AddInt(ys_var);
            else if (ys_var is Number)
                AddDouble(ys_var);
            else if (ys_var is Boolean)
                AddBoolean(ys_var);
            else if (ys_var is String)
                AddString(ys_var);
            else if (ys_var is ByteArray)
                AddByteArray(ys_var);
        }
        public function AddVar(ys_var:YsVar):void
        {
            if (ys_var.GetKeyName() != var_key)
                ys_var.SetKeyName(var_key);
            var_value.push(ys_var);
        }
        public function AddInt(value:int):void
        {
            var ys_var:YsVarInt = new YsVarInt(value, var_key);
            AddVar(ys_var);
        }
        public function AddDouble(value:Number):void
        {
            var ys_var:YsVarDouble = new YsVarDouble(value, var_key);
            AddVar(ys_var);
        }
        public function AddBoolean(value:Boolean):void
        {
            var ys_var:YsVarBool = new YsVarBool(value, var_key);
            AddVar(ys_var);
        }
        public function AddString(value:String):void
        {
            var ys_var:YsVarString = new YsVarString(value, var_key);
            AddVar(ys_var);
        }
        public function AddByteArray(value:ByteArray):void
        {
            var ys_var:YsVarBin = new YsVarBin(value, var_key);
            AddVar(ys_var);
        }
        public override function Pack():ByteArray
        {
            var array_max_length:int = 0xffffff;
            
            var_pack = new ByteArray;
            var_pack.endian = Endian.BIG_ENDIAN;
            
            var_len_of_all = 4/*length of itself*/
                + 2/*length of len_of_key*/
                + var_key.length
                + 4/*length of max*/
                + 4/*length of size*/;
            var_len_of_key_h = var_key.length / 0xff;
            var_len_of_key_l = var_key.length % 0xff;
            
            var_pack.writeByte(var_type_number);
            var_pack.writeInt(var_len_of_all);
            var_pack.writeByte(var_len_of_key_h);
            var_pack.writeByte(var_len_of_key_l);
            
            var_pack.writeMultiByte(var_key, '');
            var_pack.writeInt(array_max_length);
            var_pack.writeInt(var_value.length);
            
            var item_pack:ByteArray;
            for each (var ys_var:YsVar in var_value)
            {
                item_pack = ys_var.Pack();
                var_pack.writeBytes(item_pack);
            }
            
            return var_pack;
        }
        public override function toLocalString():String
        {
            var rtn:String =  "[" + var_key + " = '";
            if (var_value == null)
                rtn += 'value is null';
            else
                rtn += var_value;
            rtn += "' ] ";
            
            return rtn;
        }
        public override function toString():String
        {
            return toLocalString();
        }
    }
}