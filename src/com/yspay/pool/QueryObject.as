package com.yspay.pool
{
	public dynamic class QueryObject extends Object
	{
		import com.yspay.YsVarStruct;
		public function QueryObject()
		{
			super();
		}
		
		public function GetLastVer():String
		{
			var last_ver:String = '';
			
			for each (var ys_var:YsVarStruct in this)
			{
				var ver:String = ys_var.VER;
				if (last_ver < ver || last_ver == '')
					last_ver = ver;
			}
			
			return last_ver;
		}
		
		public function Get():*
		{
			return this[GetLastVer()];
		}
	}
}