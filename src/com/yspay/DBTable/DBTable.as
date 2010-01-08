package com.yspay.DBTable
{
    import com.yspay.*;

    import flash.events.*;

    public dynamic class DBTable
    {
        public var scall_name:String;
        public var event_name:String;

        public function DBTable(service_call_name:String)
        {
            scall_name = service_call_name;
            event_name = service_call_name + '_event';
        }

        public function AddQuery(query_name:String, condition:String, event_dispatcher:EventDispatcher):void
        {
            this[query_name] = new Query(this, condition, event_dispatcher);
        }

        public function init(disp:EventDispatcher, ... init_query_list):void
        {
            var bus:UserBus = new UserBus;
            var service_call:ServiceCall = new ServiceCall;
            //bus.Add(ServiceCall.SCALL_NAME, this.info_init_scall);
            //bus.Add('__DICT_IN', '');
            // this.dict = new Dict(disp);
            // this.windows = new Object;
            TableInfoInit(null, disp);
            // service_call.Send(bus, this.IP, this.PORT, TableInfoInit);
        }

        protected function TableInfoInit(bus:UserBus, disp:EventDispatcher):void
        {
            disp.dispatchEvent(new Event(''));
        }

        public function GetLastVer(type:String, value:String):String
        {
            if (null == this[type])
                return '';
            return this[type].GetLastVer(value);
        }
    }
}