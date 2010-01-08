package com.yspay
{

    public dynamic class Pool
    {
        public function Pool()
        {
        }

        public var pool_objects:Object = new Object;

        public function Add(key:String, object_type:Class, ... init_arg_list):void
        {
            this[key] = pool_objects[key] = new object_type(init_arg_list);
        }

        public function Get(key:String):*
        {
            return this[key];
        }

        public function GetAll():Object
        {
            return pool_objects;
        }

        public function GetEvent(key:String):String
        {
            return Get(key).event_name;
        }
    }
}
