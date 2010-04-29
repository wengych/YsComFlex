package com.yspay.pool
{
    import com.yspay.UserBus;
    import com.yspay.YsVarStruct;

    public dynamic class QueryWithIndex
    {
        public function QueryWithIndex()
        {
        }

        protected function SetCurrentObject(obj:YsVarStruct, arr:Array):void
        {
            var deep:uint = arr.length;

            if (deep == 1)
            {
                if (this[obj[arr[0]]] == null)
                    this[obj[arr[0]]] = obj;
                else
                    throw String("Query.SetCurrentObject : 索引项不唯一");
            }

            var curr_obj:QueryObject = this[obj[arr[0]]] = new QueryObject;

            for (var curr:uint = 1; (curr + 1) < deep; ++curr)
            {
                curr_obj[obj[arr[curr]]] = new Object;
                curr_obj = curr_obj[obj[arr[curr]]];
            }

            curr_obj[obj[arr[curr]]] = obj;
        }
		
		public function GetCurrentObject(obj:YsVarStruct, arr:Array):Object
		{
			var rtn_obj:Object;
			var deep:uint = arr.length;
			
			if (deep == 1)
			{
				if (this[obj[arr[0]]] == null)
					this[obj[arr[0]]] = obj;
				else
					throw String("Query.SetCurrentObject : 索引项不唯一");
			}
			
			var curr_obj:Object = this[obj[arr[0]]] = new Object;
			
			for (var curr:uint = 1; (curr + 1) < deep; ++curr)
			{
				curr_obj[obj[arr[curr]]] = new Object;
				curr_obj = curr_obj[obj[arr[curr]]];
			}
			
			curr_obj[obj[arr[curr]]] = obj;
			
			return rtn_obj;
		}

        public function Do(bus:UserBus, table:DBTable, indexes:Array):void
        {
            SetIndex(bus, table, indexes);
        }

        // 设置索引，务必保证索引项能够唯一确定一个对象，可使用多字段进行索引，通过数组方式传递索引字段key
        public function SetIndex(bus:UserBus, table:DBTable, indexes:Array):void
        {
			if (bus == null)
			{
				// trace ('QueryWithIndex::SetIndex: bus is null!');
				return;
			}
			
			if (!bus.hasOwnProperty(table.arg_select))
			{
				return ;
			}
			
            var out_arr:Array = bus[table.arg_select].GetAll();
            if (null == out_arr || 0 == out_arr.length)
                throw String("Query.SetIndex : get output array from user bus failed!");

            for each (var row:YsVarStruct in out_arr)
            {
                SetCurrentObject(row, indexes);
            }
        }
    }
}
