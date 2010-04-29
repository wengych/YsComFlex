package com.yspay
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public dynamic class YsVarStruct extends YsVar
    {
        public dynamic function YsVarStruct(key:String="")
        {
            super(key);
            
            var_value = new Object;
            var_type = "STRUCT";
            var_type_number = 0x0a;
        }

        public override function toXml():String
        {
            var_xml = new XML('<NODE/>');
            var_xml.@KEY = var_key;
            var_xml.@TYPE = var_type;
            var size:int = 0;
            for each (var item:YsVar in var_value)
            {
                var_xml.appendChild(item.toXml());
                ++size;
            }
            if (var_xml.children().length() == 0)
            {
                var_xml.appendChild(new XML('<NODE />'));
            }
            var_xml.@SIZE = size;

            return var_xml.toXMLString();
        }

        public override function toLocalString():String
        {
            var rtn:String = var_key + ":";

            for each (var ys_var:YsVar in var_value)
            {
                rtn += '\t' + ys_var.toLocalString();
            }
            return rtn;
        }

        public override function toString():String
        {
            return toLocalString();
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

        public override function Pack():ByteArray
        {
            var_pack = new ByteArray;
            var_pack.endian = Endian.BIG_ENDIAN;

            var_len_of_all = 4 /*length of itself*/ + 2 /*length of len_of_key*/ + var_key.length + 4 /*length of size*/;
            var_len_of_key_h = var_key.length / 0xff;
            var_len_of_key_l = var_key.length % 0xff;

            var_pack.writeByte(var_type_number);
            var_pack.writeInt(var_len_of_all);
            var_pack.writeByte(var_len_of_key_h);
            var_pack.writeByte(var_len_of_key_l);

            var_pack.writeMultiByte(var_key, char_set);
            // var_pack.writeUTFBytes(var_key);

            var size:int = 0;
            for each (var item:YsVar in var_value)
                size++;
            var_pack.writeInt(size);

            var item_pack:ByteArray;
            for each (var ys_var:YsVar in var_value)
            {
                item_pack = ys_var.Pack();
                var_pack.writeBytes(item_pack);
            }

            return var_pack;
        }
    }
}
