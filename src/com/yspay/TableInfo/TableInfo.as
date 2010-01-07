package com.yspay.TableInfo
{
    import com.yspay.*;
    
    import flash.events.*;
    
    public dynamic class TableInfo
    {
        public var dict:Dict;
        public var windows:Object;
                
        public function TableInfo(disp:EventDispatcher)
        {
            var bus:UserBus = new UserBus;
            var service_call:ServiceCall = new ServiceCall;
            
            //bus.Add(ServiceCall.SCALL_NAME, this.info_init_scall);
            //bus.Add('__DICT_IN', '');
            this.dict = new Dict(disp);
            this.windows = new Object;
            
            TableInfoInit(null, disp);
            // service_call.Send(bus, this.IP, this.PORT, TableInfoInit);
        }
        
        protected function TableInfoInit(bus:UserBus, disp:EventDispatcher):void
        {
            /*
            if (null == args.json_head)
                throw String("初始化Info失败: json_head为空");
            if (-1 == args.json_head.callrtn)
                throw String("初始化Info失败: callrtn == -1");
            if (null == args.user_bus)
                throw String("初始化Info失败: user_bus为空");
            */
            
            disp.dispatchEvent( new Event(Pool.table_info_init_event) );
        }
        
        public function GetLastVer(type:String, value:String):String
        {
            if (null == this[type])
                return '';
            
            return this[type].GetLastVer(value);
        }
    }
}
