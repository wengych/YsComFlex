package com.yspay.DBTable
{
    import com.yspay.*;

    import flash.events.*;

    public dynamic class Dict extends EventDispatcher
    {
        private static var dts_get_finish:String = "DTS_GET_FINISH";
        public static var event_dts_xml_finish:String = "EVENT_DTS_XML_FINISH";

        public function Dict(disp:EventDispatcher)
        {
            var bus:UserBus = new UserBus;
            var service_call:ServiceCall = new ServiceCall;

            bus.Add(ServiceCall.SCALL_NAME, '');//Pool.info_scall_name);
            bus.Add('YSDICT_DB_TB_STARTPOS', 0);
            bus.Add('YSDICT_DB_TB_ENDPOS', 10000);
            bus.Add('__DICT_IN', "type='DICT' and appname='MapServer'");
            var func_dele:FunctionHelper = new FunctionHelper;
            service_call.Send(bus, '', '', DictInit);//Pool.IP, Pool.PORT, func_dele.create(DictInit, disp));
        }

        protected function DictInit(bus:UserBus, dispatcher:EventDispatcher):void
        {
            /*
               if (null == args.json_head)
               throw String("初始化Dict失败: json_head为空");
               if (-1 == args.json_head.callrtn)
               throw String("初始化Dict失败: callrtn == -1");
               if (null == args.user_bus)
               throw String("初始化Dict失败: user_bus为空");
             */
            if (null == bus)
                throw String("初始化Dict失败: bus为空");
            var dict_arr:Array = bus.YSDICT_DB_TB_DTSINFO.GetAll();
            for each (var dts_info:YsVarStruct in dict_arr)
            {
                if (this[dts_info.VALUE] == null)
                {
                    this[dts_info.VALUE] = new DtsArray;
                    this[dts_info.VALUE][dts_info.VER] = dts_info;
                }
            }

            dispatcher.dispatchEvent(new Event(''));//Pool.dict_init_event));
        }

        public function CacheDTS(dts_value:String, dts_ver:String = ''):void
        {
            var dts_xml:String = this[dts_value][dts_ver].DTS_XML;
            var dts_no:String = '';
            if (null != dts_ver && 0 != dts_ver.length)
                dts_no = this[dts_value][dts_ver].DTS;
            else
                dts_no = this[dts_value].last_dts;

            if (dts_xml == null)
            {
                var service_call:ServiceCall = new ServiceCall();
                var bus:UserBus = new UserBus;
                bus.Add(ServiceCall.SCALL_NAME, 'YSDBSDTSObjectSelect');
                bus.Add('__DICT_IN', dts_no);

                var func_args:Object = {'DTS_VALUE': dts_value, 'DTS_VER': dts_ver, 'TEST': 'test'};
                delete func_args.TEST;

                this[dts_value][dts_ver].CACHE_STATUS = 'caching';
                var func_dele:FunctionHelper = new FunctionHelper;
                service_call.Send(bus, '', '', dict_call_back); // Pool.IP, Pool.PORT, func_dele.create(dict_call_back, func_args));
            }
        }

        public function dict_call_back(bus:UserBus, func_args:Object):void
        {
            if (null == bus)
                throw String("查询dict失败: user_bus为空");
            var dts_value:String = func_args.DTS_VALUE;
            var dts_ver:String = func_args.DTS_VER;

            var dict_xml:YsVarArray = bus.__DICT_XML;
            if (null == dict_xml)
                throw String("查询dict失败: __DICT_XML字段不存在");

            var dts_object:Object = this[dts_value][dts_ver];
            var dts_xml:XML = new XML(dict_xml.first);
            dts_object.DTS_XML = dts_xml;

            this.dispatchEvent(new Event(dts_get_finish));
        }

        public function GetDTSXml(dts_value:String, dts_ver:String, disp:EventDispatcher = null):void
        {
            var dts_obj:Object = this[dts_value][dts_ver];
            var func_dele:FunctionHelper = new FunctionHelper;
            if (dts_obj.DTS_XML == null)
            {
                // 已经发送ServiceCall请求，尚未收到call_back
                if (dts_obj.CACHE_STATUS != null && dts_obj.CACHE_STATUS == 'caching')
                {
                    this.addEventListener(DataEvent.DATA, func_dele.create(dts_xml_call_back, disp));
                }
                // 未发送ServiceCall请求，发送ServiceCall
                else
                {
                    this.addEventListener(DataEvent.DATA, func_dele.create(dts_xml_call_back, disp));
                    CacheDTS(dts_value, dts_ver);
                }
            }
            else
            {
                disp.dispatchEvent(new Event(event_dts_xml_finish));
            }
        }

        public function dts_xml_call_back(event:DataEvent, disp:EventDispatcher):void
        {
            if (disp != null)
                disp.dispatchEvent(new Event(event_dts_xml_finish));
        }
    }
}
