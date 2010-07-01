package com.yspay.pool
{
    import com.yspay.*;

    import flash.events.*;

    public dynamic class DBTable
    {
        public var scall_select:String;
        public var scall_insert:String;
        public var select_event_name:String;
        public var insert_event_name:String;
        public var arg_select:String;
        public var arg_insert:String;
        protected var query_table:Object = new Object;
        protected var server_ip:String;
        protected var server_port:String;

        public function DBTable()
        {
        }

        public function init(scall_sel:String, scall_arg_sel:String, scall_ins:String,
                             scall_arg_ins:String, ip:String='124.207.197.178', port:String='6802'):void
        {
            scall_select = scall_sel;
            arg_select = scall_arg_sel;
            select_event_name = scall_sel + '_event';

            scall_insert = scall_ins;
            arg_insert = scall_arg_ins;
            insert_event_name = scall_ins + '_event';

            server_ip = ip;
            server_port = port;
        }

        public function Insert(sc_in_arg_names:Array, sc_in_args:Array, event_dispatcher:EventDispatcher):void
        {
            trace('Insert arg names');
            trace(sc_in_arg_names);

            trace('Insert args');
            trace(sc_in_args);

            var bus:UserBus = new UserBus;
            var scall:ServiceCall = new ServiceCall;

            bus.Add(ServiceCall.SCALL_NAME, scall_insert);
            for (var idx:int = 0; idx < sc_in_arg_names.length; ++idx)
            {
                bus.Add(sc_in_arg_names[idx], sc_in_args[idx]);
            }

            var func_helper:FunctionHelper = new FunctionHelper;
            var func:Function = func_helper.create(OnInsertComplete, event_dispatcher);

            trace('Insert bus');
            trace(bus.toXml());
            scall.Send(bus, server_ip, server_port, func);
        }

        public function OnInsertComplete(bus:UserBus, disp:EventDispatcher):void
        {
            var event:DBTableInsertEvent = new DBTableInsertEvent(insert_event_name);

            event.user_bus = bus;
            disp.dispatchEvent(event);
        }

        public function AddQuery(query_name:String, query_type:Class, condition:String,
                                 event_dispatcher:EventDispatcher):void
        {
            if (null == query_name || '' == query_name)
                throw String('DBTable.AddQuery : query_name must not be EMPTY!');
            query_name = query_name.toLocaleUpperCase();

            if (query_table.hasOwnProperty(query_name) && query_table[query_name].QUERY != null)
            {
                this.query_table[query_name].DISPATCHER = event_dispatcher;
            }
            else
            {
                // this[query_name] = new Query(this, condition, event_dispatcher);
                var query_obj:Object = new Object;
                query_obj.TYPE = query_type;
                query_obj.CONDITION = condition;
                query_obj.DISPATCHER = event_dispatcher;
                this[query_name] = new query_type;
                query_obj.QUERY = this[query_name];
                this.query_table[query_name] = query_obj;
            }
        /*else
           {
           this.query_table[query_name].DISPATCHER = event_dispatcher;
         }*/
        }

        protected function CheckObjectHasProperty(obj:Object, property_name:String=''):Boolean
        {
            // 查询某对象是否包含指定属性
            // 如果属性字段为空，查询对象是否包含任意属性
            // 无属性的对象将返回false

            // 暂时关闭缓冲比较机制
            // return false;
            var rtn:Boolean = false;

            if ((property_name != '') && (obj.hasOwnProperty(property_name)))
                rtn = true;
            else
            {
                for each (var child:Object in obj)
                {
                    rtn = true;
                    break;
                }
            }

            return rtn;
        }

        public function DoQuery(query_name:String, full_link:Boolean=false, ... args):void // indexes:Array):void
        {
            if (null == query_name || '' == query_name)
                throw String('DBTable.DoQuery : query_name must not be EMPTY!');

            query_name = query_name.toLocaleUpperCase();
            var disp:EventDispatcher = query_table[query_name].DISPATCHER;

            if (this.hasOwnProperty(query_name)
                && CheckObjectHasProperty(this[query_name], this.arg_select))
            {
                var event:DBTableQueryEvent = new DBTableQueryEvent(select_event_name);
                event.query_name = query_name;

                disp.dispatchEvent(event);

                return;
            }
            else
            {
                if (args != null && args.length > 0)
                    this.query_table[query_name].ARGS = args;

                var bus:UserBus = new UserBus;
                var service_call:ServiceCall = new ServiceCall;
                bus.Add(ServiceCall.SCALL_NAME, scall_select);
                if (true == full_link)
                {
                    bus.Add('__DICT_DTS_XML_FULL__', 'true');
                }
                bus.Add('YSDICT_DB_TB_STARTPOS', 0);
                bus.Add('YSDICT_DB_TB_ENDPOS', 10000);
                bus.Add('__DICT_IN', query_table[query_name].CONDITION);

                var call_back:Function = function(bus:UserBus, error:ErrorEvent=null):void
                    {
                        OnQueryComplete(bus, error, query_name, disp);
                    }
                service_call.Send(bus, server_ip, server_port, call_back);

                // 取消使用FunctionHelper,改用临时函数对象
                // 使用FunctionHelper携带额外参数，传递给OnQueryComplete，异步事件
                // var func_helper:FunctionHelper = new FunctionHelper;
                /* service_call.Send(bus, server_ip, server_port,
                   func_helper.create(OnQueryComplete, [query_name,
                   service_call,
                   query_table[query_name].DISPATCHER]));
                 */
                return;
            }
        }

        public function OnQueryComplete(bus:UserBus, error:ErrorEvent, query_name:String,
                                        disp:EventDispatcher):void
        {
            var event:DBTableQueryEvent = new DBTableQueryEvent(select_event_name);
            event.query_name = query_name;
            if (bus == null && error != null)
            {
                event.error_event = error;
                disp.dispatchEvent(event);
            }
            else if (bus == null)
            {
                event.error_event = new ErrorEvent('ServiceCallFail',
                                                   false, false, 'ServiceCallFail');
                disp.dispatchEvent(event);
            }
            else
            {
                this[query_name].Do(bus, this, query_table[query_name].ARGS);
                event.query_name = query_name;
                event.user_bus = bus;

                disp.dispatchEvent(event);
            }
        }

        public function GetByUrl(url:String):void
        {
            var search_str:String = '://';
            var idx:int = url.search(search_str);
            var query_key:String = url.substr(0, idx).toLocaleUpperCase();
            var obj_key:String = url.substr(idx + search_str.length);

            if (this.query_table[query_key] == null)
                this.DoQuery(query_key);
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
