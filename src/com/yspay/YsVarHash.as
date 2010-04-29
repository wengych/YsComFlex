package com.yspay
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import mx.utils.object_proxy;

    public dynamic class YsVarHash extends YsVar
    {
        protected var hash_object:Object;
        protected static const hash_value:int = 0x11;

        public function YsVarHash(key:String="HASH")
        {
            super(key);
            var_value = new Object;
            var_type = "HASH";
            var_type_number = 0x69;
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

        public function Remove(obj:*):void
        {
            if (obj is String)
                RemoveByKey(obj);
            else if (obj is YsVar)
                RemoveVar(obj);
            else
                throw String("VarHash.Remove : object's type not support.");
        }

        public function RemoveByKey(key:String):void
        {
            delete var_value[key];
        }

        public function RemoveVar(ys_var:YsVar):void
        {
            var key:String = ys_var.GetKeyName();
            var_value[key].Remove(ys_var);
        }

        public function AddVar(key:String, ys_var:YsVar):void
        {
            var user_bus_array:YsVarArray;
            if (ys_var is YsVarArray)
            {
                user_bus_array = ys_var as YsVarArray;
                ys_var.SetKeyName(key);
                var_value[key] = user_bus_array;
            }
            else if (!var_value.hasOwnProperty(key))
            {
                user_bus_array = new YsVarArray(new Array, key);
                ys_var.SetKeyName(key);
                user_bus_array.push(ys_var);
                var_value[key] = user_bus_array;
            }
            else
            {
                user_bus_array = var_value[key];
                ys_var.SetKeyName(key);
                user_bus_array.push(ys_var);

                var_value[key] = user_bus_array;
            }
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

        public function GetVarArray(key:String):Array
        {
            if (var_value.hasOwnProperty(key))
                return var_value[key].GetAll();
            return null;
        }

        public function GetFirst(key:String):*
        {
            if (var_value.hasOwnProperty(key))
            {
                var array:YsVarArray = var_value[key] as YsVarArray;
                return array.GetAt(0).getValue();
            }
            return null;
        }
        
        public function GetKeyArray():Array
        {
            var rtn:Array = new Array;
            for (var key_name:String in var_value)
            {
                rtn.push(key_name);
            }
            
            return rtn;
        }

        public override function toLocalString():String
        {
            var rtn:String = var_key + ":\n";

            for (var key:String in var_value)
            {
                rtn += '\t';
                var array:YsVarArray = var_value[key];
                for each (var item:YsVar in array.GetAll())
                    rtn += item.toLocalString();
                // rtn += array.every(arrayToString);
                rtn += '\n';
            }
            return rtn;
        }

        public override function toString():String
        {
            return toLocalString();
        }

        public override function toXml():String
        {
            var_xml = new XML('<NODE/>');
            var_xml.@KEY = var_key;
            var_xml.@TYPE = var_type;

            for each (var arr:YsVarArray in var_value)
            {
                var_xml.appendChild(arr.toXml());
            }

            return var_xml.toXMLString();
        }

        public override function Pack():ByteArray
        {
            var_pack = new ByteArray;
            var_pack.endian = Endian.BIG_ENDIAN;

            var_len_of_all = 4 /*length of itself*/ + 2 /*length of len_of_key*/ + var_key.length + 4 /*hash value*/ + 4 /*length of size*/;
            var_len_of_key_h = var_key.length / 0xff;
            var_len_of_key_l = var_key.length % 0xff;

            var_pack.writeByte(var_type_number);
            var_pack.writeInt(var_len_of_all);
            var_pack.writeByte(var_len_of_key_h);
            var_pack.writeByte(var_len_of_key_l);

            var_pack.writeMultiByte(var_key, char_set);
            // var_pack.writeUTFBytes(var_key);

            var_pack.writeInt(hash_value);

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
