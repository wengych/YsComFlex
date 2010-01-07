package com.yspay
{

    public class FunctionDelegate
    {
        protected var my_arg:Object;
        protected var my_func:Function;
        
        public function create(func:Function, arg:Object):Function
        {
            my_func = func;
            my_arg = arg;
            
            return _func;
        }
        
        protected function _func(any:*):void
        {
            my_func.call(null, any, my_arg);
        }
    }
}