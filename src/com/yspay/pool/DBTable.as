package com.yspay.pool
{
    import com.yspay.*;

    import flash.events.*;

    public dynamic class DBTable
    {
        public var scall_name:String;
        public var event_name:String;
        public var output_arg:String;
        protected var query_table:Object = new Object;

        public function DBTable()
        {
        }

        public function init(service_call_name:String, service_call_out_arg:String):void
        {
            scall_name = service_call_name;
            output_arg = service_call_out_arg;
            event_name = service_call_name + '_event';
        }

        public function AddQuery(query_name:String, query_type:Class, condition:String, event_dispatcher:EventDispatcher):void
        {
            if (null == query_name || '' == query_name)
                throw String('DBTable.AddQuery : query_name must not be EMPTY!');
            // this[query_name] = new Query(this, condition, event_dispatcher);
            var query_obj:Object = new Object;
            query_obj.TYPE = query_type;
            query_obj.CONDITION = condition;
            query_obj.DISPATCHER = event_dispatcher;
            this[query_name] = new query_type;
            query_obj.QUERY = this[query_name];
            this.query_table[query_name] = query_obj;
        }

        public function DoQuery(query_name:String, ... args):void // indexes:Array):void
        {
            if (null == query_name || '' == query_name)
                throw String('DBTable.DoQuery : query_name must not be EMPTY!');

            this.query_table[query_name].ARGS = args;

            var bus:UserBus = new UserBus;
            var service_call:ServiceCall = new ServiceCall;
            bus.Add(ServiceCall.SCALL_NAME, scall_name);
            bus.Add('YSDICT_DB_TB_STARTPOS', 0);
            bus.Add('YSDICT_DB_TB_ENDPOS', 10000);
            bus.Add('__DICT_IN', query_table[query_name].CONDITION);

            var func_helper:FunctionHelper = new FunctionHelper;
            service_call.Send(bus, '124.207.197.178', '6802',
                              func_helper.create(OnQueryComplete, query_name));
        }

        public function OnQueryComplete(bus:UserBus, query_name:String):void
        {
            var disp:EventDispatcher = query_table[query_name].DISPATCHER;
            var event:DBTableQueryEvent = new DBTableQueryEvent(event_name);
            if (null == query_name)
                throw String('DBTable.OnQueryComplete : query_name must not be EMPTY!');

            if (null == bus)
            {
                if (null != this[query_name])
                    delete this[query_name];
            }

            this[query_name].Do(bus, this, query_table[query_name].ARGS);

            event.query_name = query_name;
            disp.dispatchEvent(event);
        }




        public function init1(disp:EventDispatcher, ... init_query_list):void
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