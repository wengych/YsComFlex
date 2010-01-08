package com.yspay.DBTable
{
    import com.yspay.YsVarStruct;
    
    public dynamic class DtsArray
    {
        public function DtsArray()
        {
        }
        protected function GetLastVer():String
        {
            var last_ver:String = '0';
            for (var ver:String in this)
            {
                if ( ver > last_ver )
                    last_ver = ver;
            }
            return last_ver;
        }
        protected function GetLastDts():YsVarStruct
        {
            return this[GetLastVer()];
        }
        
        public function get last_ver():String
        {
            return GetLastVer();
        }
        public function get last_dts():YsVarStruct
        {
            return GetLastDts();
        }
    }
}