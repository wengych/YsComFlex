package com.yspay.pool
{
    import com.yspay.UserBus;

    import flash.events.Event;

    public class DBTableQueryEvent extends Event
    {
        public var query_name:String;

        public function DBTableQueryEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}