package com.yspay
{
    import flash.utils.ByteArray;
    
    
    public class UserBus extends YsVarHash
    {
        public static const SERVICE_CALL_NAME:String = '__DICT_SCALL_NAME';
        public function UserBus(key:String = "USER_BUS")
        {
            super(key);
        }
    }
}
