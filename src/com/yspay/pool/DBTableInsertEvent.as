package com.yspay.pool
{
	import com.yspay.UserBus;
	import flash.events.Event;
	
	public class DBTableInsertEvent extends Event
	{
		public var user_bus:UserBus;
		
		public function DBTableInsertEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
