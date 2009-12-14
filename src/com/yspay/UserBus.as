package com.yspay
{
    import flash.utils.ByteArray;
    
    
    public class UserBus extends YsVar
    {
        protected var bus_object:Object;
        public function UserBus(key:String = "USER_BUS")
        {
            super(key);
            bus_object = new Object;
            var_type = "HASH";
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
            var user_bus_array:YsVarArray;
            if (!bus_object.hasOwnProperty(key))
            {
                user_bus_array = new YsVarArray(new Array, key);
                ys_var.SetKeyName(key);
                user_bus_array.push(ys_var);
                bus_object[key] = user_bus_array;
            }
            else
            {
                user_bus_array = bus_object[key];
                ys_var.SetKeyName(key);
                user_bus_array.push(ys_var);
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
        public function GetBusObject():Object
        {
            return bus_object;
        }
        
        public function GetVarArray(key:String):Array
        {
            if (bus_object.hasOwnProperty(key))
                return bus_object[key];
            return null;
        }
        public function GetFirstVar(key:String):YsVar
        {
            if (bus_object.hasOwnProperty(key))
                return bus_object[key][0];
            return null;
        }
        public override function toString():String
        {
            var rtn:String = var_key + ":\n";
            
            for (var key:String in bus_object)
            {
                rtn += '\t';
                var array:YsVarArray = bus_object[key];
                for each(var item:YsVar in array.GetAll())
                    rtn += item.toString();
                // rtn += array.every(arrayToString);
                rtn += '\n';
            }
            return rtn;
        }
        public override function toXml():String
        {
            var_xml = new XML('<NODE/>');
            var_xml.@KEY = var_key;
            var_xml.@TYPE = var_type;
            
            for each(var arr:YsVarArray in bus_object)
            {
                var_xml.appendChild(arr.toXml());
            }
            
            return var_xml.toXMLString();
        }
    }
}
