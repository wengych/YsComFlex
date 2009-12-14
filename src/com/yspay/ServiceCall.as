package com.yspay
{
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    public class ServiceCall
    {
        protected var sock:Socket;
        protected var send_byte_arr:ByteArray;
        protected var bytes_recv:int;
        protected var recv_byte_arr:ByteArray;
        
        public function ServiceCall()
        {
            this.sock = new Socket;
            this.sock.addEventListener(Event.CONNECT, onConnect);
            this.sock.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
        }
        
        public function Send(pkg:String, ip:String, port:String):void
        {
            var size:int = pkg.length;
            this.send_byte_arr = new ByteArray;
            this.send_byte_arr.endian = Endian.BIG_ENDIAN;
            this.send_byte_arr.writeInt(size);
            this.send_byte_arr.writeMultiByte(pkg, "");
            
            sock.connect(ip, int(port));
        }
        
        protected function onConnect(event:Event):void
        {
            if (send_byte_arr == null)
                return ;
            
            send_byte_arr.position = 0;
            trace ("send_byte_arr:\n");
            trace (send_byte_arr);
            this.sock.writeBytes(send_byte_arr);
            this.send_byte_arr = null;
            this.bytes_recv = -1;
        }
        
        protected function onSocketData(event:ProgressEvent):void
        {
            this.sock.endian = Endian.BIG_ENDIAN;
            if (this.bytes_recv == -1)
            {
                if (event.bytesTotal > 4)
                {
                    this.bytes_recv = this.sock.readInt();
                }
            }
            else if (event.bytesLoaded - 4 >= this.bytes_recv)
            {
                this.sock.readBytes(this.recv_byte_arr);
            }
        }
    }
}