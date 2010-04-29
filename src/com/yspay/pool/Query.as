package com.yspay.pool
{
    import com.yspay.UserBus;
    import com.yspay.YsVarStruct;

    public dynamic class Query
    {
        public function Query()
        {
        }

        public function Do(bus:UserBus, table:DBTable, ... args /*not in use*/):void
        {
            this[table.arg_select] = bus.GetFirst(table.arg_select);
        }
    }
}
