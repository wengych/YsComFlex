compc ^
-source-path=src ^
-output=libs/YsComFlex.swc ^
-include-classes com.yspay.ByteUtils ^
  com.yspay.FunctionHelper ^
  com.yspay.ServiceCall ^
  com.yspay.UserBus ^
  com.yspay.VarFactory ^
  com.yspay.VarTypeDict ^
  com.yspay.YsVar ^
  com.yspay.YsVarArray ^
  com.yspay.YsVarBin ^
  com.yspay.YsVarBool ^
  com.yspay.YsVarDouble ^
  com.yspay.YsVarHash ^
  com.yspay.YsVarInt ^
  com.yspay.YsVarString ^
  com.yspay.YsVarStruct ^
  com.yspay.pool.DBTable ^
  com.yspay.pool.DBTableQueryEvent ^
  com.yspay.pool.Pool ^
  com.yspay.pool.QueryWithIndex ^
  com.yspay.pool.Query ^
  -compiler.library-path "D:/Develop/as3corelib-.92.1/lib"

copy libs\YsComFlex.swc ..\UnitTests\libs /y

