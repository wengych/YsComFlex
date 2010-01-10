package com.yspay.DBTable
{
	import com.yspay.UserBus;
	import com.yspay.YsVarStruct;

    public dynamic class Query
    {
        public function Query()
        {
        }
		public function SetIndex(bus:UserBus, table:DBTable, indexes:Array):void
		{
			var index_len:int = indexes.length;
			var out_arr:Array = bus[table.output_arg].GetAll();
			if (null == out_arr || 0 == out_arr.length)
				throw String ("Query.SetIndex : get output array from user bus failed!");
			
			for each(var row:YsVarStruct in out_arr)
			{
				for (var idx:uint = 0; idx < indexes.length; ++idx)
				{
					if ( (idx + 1) < indexes.length )
						this[ indexes[idx] ] = new Object;
					else
						;
				}
				
					// row;
			}
		}
    }
}
