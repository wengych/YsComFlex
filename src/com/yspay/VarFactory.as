package com.yspay
{
    import flash.utils.ByteArray;

    public class VarFactory
    {
        /*private static var var_types_bin:Object =
           {"BOOL"   : 1,
           "INT32"  : 4,
           "BIN"    : 7,
           "STRING" : 8,
           "STRUCT" : 10,
           "ARRAY"  : 101,
         "HASH"   : 105};*/
        public static function GetYsVar(pack:*):YsVar
        {
            if (pack is XML)
                return GetYsVarFromXml(pack);
            else if (pack is ByteArray)
                return GetYsVarFromBytes(pack);
            return null;
        }

        /* VAR TYPES
         * BOOL     : 1
         * BYTE     : 2
         * INT32    : 4
         * BIN      : 7
         * STRING   : 8
         * STRUCT   : 10
         * ARRAY    : 101
         * HASH     : 105
         */
        public static function GetYsVarFromBytes(bytes:ByteArray):YsVar
        {
            var ys_var:YsVar = null; // var for return.
            var var_type:int = bytes.readByte();
            var var_len:int = bytes.readInt();
            var var_key_len:int = bytes.readByte() * 0xff + bytes.readByte();
            // var var_key:String = bytes.readMultiByte(var_key_len, '');
            var var_key:String = bytes.readUTFBytes(var_key_len);

            // trace (VarTypeDict.FindType(var_type));
            // trace ('var_len: ', var_len);
            // trace ('var_key_len: ', var_key_len);
            // trace ('var_key: ', var_key);

            var var_body_len:int = var_len - var_key_len - 4 /*len of len*/ - 2 /*len of key len*/;
            switch (VarTypeDict.FindType(var_type))
            {
                case 'STRING':
                {
                    // var string_tmp:String = bytes.readMultiByte(var_body_len, '');
                    var string_tmp:String = bytes.readUTFBytes(var_body_len);
                    var string_var:YsVarString = new YsVarString(string_tmp, var_key);
                    ys_var = string_var;
                    break;
                }
                case 'INT32':
                {
                    var int_tmp:int = bytes.readInt();
                    var int_var:YsVarInt = new YsVarInt(int_tmp, var_key);
                    ys_var = int_var;
                    break;
                }
                case 'BOOL':
                {
                    var bool_tmp:Boolean = bytes.readInt() == 1 ? true : false;
                    var bool_var:YsVarBool = new YsVarBool(bool_tmp, var_key);
                    ys_var = bool_var;
                    break;
                }
                case 'BIN':
                {
                    var bin_tmp:ByteArray = new ByteArray;
                    bytes.readBytes(bin_tmp, 0, var_body_len);
                    var bin_var:YsVarBin = new YsVarBin(bin_tmp, var_key);
                    ys_var = bin_var;
                    break;
                }
                case 'ARRAY':
                {
                    var array_max:int = bytes.readInt();
                    var array_size:int = bytes.readInt();
                    var array_tmp:Array = new Array;
                    while (array_size-- > 0)
                    {
                        array_tmp.push(GetYsVarFromBytes(bytes));
                    }
                    var array_var:YsVarArray = new YsVarArray(array_tmp, var_key);
                    ys_var = array_var;
                    break;
                }
                case 'STRUCT':
                {
                    var struct_size:int = bytes.readInt();
                    var struct_item:YsVar = null;
                    var struct_var:YsVarStruct = new YsVarStruct(var_key);
                    while (struct_size-- > 0)
                    {
                        struct_item = GetYsVarFromBytes(bytes);
                        if (struct_item != null)
                            struct_var[struct_item.GetKeyName()] = struct_item;
                    }
                    ys_var = struct_var;
                    break;
                }
                case 'HASH':
                {
                    var hash_value:int = bytes.readInt();
                    var hash_size:int = bytes.readInt();
                    ys_var = new UserBus(var_key);
                    var hash_item:YsVar = null;
                    while (hash_size-- > 0)
                    {
                        hash_item = GetYsVarFromBytes(bytes);
                        if (hash_item)
                            ys_var[hash_item.GetKeyName()] = hash_item;
                    }
                    break;
                }
            }
            return ys_var;
        }

        /* VAR TYPES
         * YSVAR       : VAR
         * YSVARINT    : INT32
         * YSVARBOOL   : BOOL
         * YSVARDOUBLE : DOUBLE
         * YSVARSTRING : STRING
         * YSVARBIN    : BIN
         * YSVARSTRUCT : STRUCT
         * USERBUS     : USERBUS
         */
        public static function GetYsVarFromXml(xml:XML):YsVar
        {
            if (xml == null)
                return null;
            var ys_var:YsVar;
            var var_type:String = xml.@TYPE[0];
            var var_value:String = xml.text()[0];
            var var_key:String = xml.@KEY[0];
            var var_len:int;

            var_value = var_value != null ? var_value : "";

            var child:XML; // for userbus or struct or array
            var child_var:YsVar; // for userbus or struct or array
            switch (var_type)
            {
                case 'INT32':
                {
                    var int_var:YsVarInt = new YsVarInt();
                    int_var.SetKeyName(var_key);
                    int_var.fromXmlValue(var_value);
                    ys_var = int_var;
                    break;
                }
                case 'BOOL':
                {
                    var bool_var:YsVarBool = new YsVarBool(Boolean(var_value), var_key);
                    ys_var = bool_var;
                    break;
                }
                case 'STRING':
                {
                    var_len = int(xml.@LEN[0]);
                    var string_var:YsVarString = new YsVarString(var_value.substr(0, var_len), var_key);
                    ys_var = string_var;
                    break;
                }
                case 'BIN':
                {
                    var_len = int(xml.@LEN[0]);
                    var bin_var:YsVarBin = new YsVarBin();
                    bin_var.SetKeyName(var_key);
                    bin_var.fromXmlValue(var_value.substr(0, var_len * 2));
                    ys_var = bin_var;
                    break;
                }
                case 'STRUCT':
                {
                    var struct_var:YsVarStruct = new YsVarStruct;
                    struct_var.SetKeyName(var_key);
                    struct_var.fromXmlValue(var_value);

                    for each (child in xml.children())
                    {
                        child_var = GetYsVar(child);
                        if (child_var != null)
                            struct_var.Add(child_var.GetKeyName(), child_var);
                    }
                    ys_var = struct_var;
                    break;
                }
                case 'ARRAY':
                {
                    var array_var:YsVarArray = new YsVarArray;
                    array_var.SetKeyName(var_key);
                    array_var.fromXmlValue(var_value);

                    for each (child in xml.children())
                    {
                        child_var = GetYsVar(child);
                        if (child_var != null)
                            array_var.push(child_var);
                    }
                    ys_var = array_var;
                    break;
                }
                case 'HASH':
                {
                    var userbus_var:UserBus = new UserBus;
                    userbus_var.SetKeyName(var_key);
                    userbus_var.fromXmlValue(var_value);

                    for each (child in xml.children())
                    {
                        child_var = GetYsVar(child);
                        if (child_var != null)
                        {
                            userbus_var.Add(child_var.GetKeyName(), child_var);
                        }
                    }

                    ys_var = userbus_var;
                    break;
                }
            }

            return ys_var;
        }

        public static function GetUserBus(pack:*):UserBus
        {
            var bus:UserBus = GetYsVar(pack) as UserBus;
            return bus;
        }
    }
}
