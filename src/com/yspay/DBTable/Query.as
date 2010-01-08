package com.yspay.DBTable
{
    import com.yspay.ServiceCall;
    import com.yspay.UserBus;

    import flash.events.Event;
    import flash.events.EventDispatcher;

    public dynamic class Query
    {
        public function Query(table:DBTable, condition:String, dispatcher:EventDispatcher)
        {
            this.TABLE = table;
            this.CONDITION = condition;
            this.DISPATCHER = dispatcher;
        }

        public function doQuery():void
        {
            var bus:UserBus = new UserBus;
            var service_call:ServiceCall = new ServiceCall;
            this.DISPATCHER.dispatchEvent(new Event(this.TABLE.event_name));
        }
    }
}
