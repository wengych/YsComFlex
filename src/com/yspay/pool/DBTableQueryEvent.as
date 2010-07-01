package com.yspay.pool
{
    import com.yspay.UserBus;
    
    import flash.events.ErrorEvent;
    import flash.events.Event;

    public class DBTableQueryEvent extends Event
    {
        public var query_name:String;
        public var user_bus:UserBus;
        public var error_event:ErrorEvent = null;

        public function DBTableQueryEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}