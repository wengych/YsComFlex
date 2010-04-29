package com.yspay.pool
{

    public dynamic class Pool
    {
        public function Pool()
        {
        }

        public var pool_objects:Object = new Object;

        public function Add(key:String, object_type:Class, ... init_arg_list):void
        {
            this[key] = pool_objects[key] = new object_type();
			if (init_arg_list.length > 0)
			{
            	this[key].init.apply(this[key], init_arg_list);
			}
        }

        public function Get(key:String):*
        {
            return pool_objects[key];
        }

        public function GetAll():Object
        {
            return pool_objects;
        }

        public function GetEvent(key:String):String
        {
            return Get(key).select_event_name;
        }
		
    }
}
