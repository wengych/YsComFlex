package com.yspay
{
    // 用来伪装回调函数，帮助接收单参数的回调函数增加一个参数。
    // 若该回调需要多参数，可通过object的动态属性方式绑定多参数。
    
    // 基于类的方式，需要使用此伪装类时必须创建该类的对象
    // 由于静态类无法在异步条件下安全的携带属性传递，所以以类的方式创建
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