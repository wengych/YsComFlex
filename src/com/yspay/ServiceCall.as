package com.yspay
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    public class ServiceCall
    {
        protected var sock:Socket;
        protected var send_byte_arr:ByteArray;
        protected var bytes_recv:int;
        protected var recv_byte_arr:ByteArray;
        protected var call_back:Function;
        
        protected function OutputByteArray(bytes:ByteArray):void
        {
            var output_string:String = "";
            for(var idx:int = 0; idx < bytes.length; ++idx)
            {
                output_string += bytes[idx] + ' ';
            }
            trace (output_string, '\n');
        }
        public function ServiceCall()
        {
            this.sock = new Socket;
            this.sock.addEventListener(Event.CONNECT, onConnect);
            this.sock.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
            this.sock.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
            this.sock.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        }
        
        public function Send(pkg:String, ip:String, port:String, func:Function):void
        {
            trace (pkg);
            var size:int = pkg.length;
            this.send_byte_arr = new ByteArray;
            this.send_byte_arr.endian = Endian.BIG_ENDIAN;
            this.send_byte_arr.writeInt(size);
            this.send_byte_arr.writeMultiByte(pkg, "");
            this.call_back = func;
            
            sock.connect(ip, int(port));
        }
        protected function onIoError(event:IOErrorEvent):void
        {
            trace (event.text);
        }
        protected function onSecurityError(event:SecurityErrorEvent):void
        {
            trace (event.text);
        }
        protected function onConnect(event:Event):void
        {
            if (send_byte_arr == null)
                return ;
            
            send_byte_arr.position = 0;
            trace ("send_byte_arr:\n");
            OutputByteArray(send_byte_arr);
            this.sock.writeBytes(send_byte_arr);
            this.send_byte_arr = null;
            this.bytes_recv = -1;
        }
        
        protected function onSocketData(event:ProgressEvent):void
        {
            if (this.sock.connected == false)
                return ;
            this.sock.endian = Endian.BIG_ENDIAN;
            if (this.bytes_recv == -1)
            {
                if (event.bytesLoaded > 4)
                {
                    this.bytes_recv = this.sock.readInt();
                }
            }
            if (this.sock.bytesAvailable >= this.bytes_recv)
            {
                this.recv_byte_arr = new ByteArray;
                // this.sock.readBytes(this.recv_byte_arr);
                // this.sock.close();
                trace ('service call finish.');
                this.call_back(
                    this.sock.readMultiByte(sock.bytesAvailable, "CN-GB"));
                this.sock.flush();
                this.sock.close();
                this.bytes_recv = 0;
            }
        }
    }
}
