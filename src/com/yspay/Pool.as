package com.yspay
{
    import com.yspay.TableInfo.TableInfo;
    
    import flash.events.EventDispatcher;
    
    public class Pool
    {
        public static const info_scall_name:String = 'YSDBSTB_DTSINFOSelect';
        public static const table_info_init_event:String = 'table_info_init_event';
        public static const dict_init_event:String = 'dict_init_event';
        public static var IP:String;
        public static var PORT:String;
        public static var DISPATCHER:EventDispatcher;
        
        public function Pool(ip:String, port:String, dispatcher:EventDispatcher)
        {
            IP = ip;
            PORT = port;
            DISPATCHER = dispatcher;
            info = new TableInfo(dispatcher);
        }
        public var info:TableInfo;
    }
}
