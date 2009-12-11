package com.yspay
{

    public class VarFactory
    {
        public function VarFactory()
        {
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
        public function GetYsVar(xml:XML):YsVar
        {
            if (xml == null)
                return null;
            var ys_var:YsVar;
            var var_type:String = xml.@TYPE[0];
            var var_value:String = xml.text()[0];
            var var_key:String = xml.@KEY[0];
            var var_len:int;
            
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
                        child_var = this.GetYsVar(child);
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
                        child_var = this.GetYsVar(child);
                        if (child_var != null)
                            array_var.push(child_var);
                    }
                    ys_var = array_var;
                    break;
                }
                case 'USERBUS':
                {
                    var userbus_var:UserBus = new UserBus;
                    userbus_var.SetKeyName(var_key);
                    userbus_var.fromXmlValue(var_value);
                    
                    for each (child in xml.children())
                    {
                        child_var = this.GetYsVar(child);
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

        public function GetUserBus(xml:XML):UserBus
        {
            var bus:UserBus = GetYsVar(xml) as UserBus;
            return bus;
        }
    }
}