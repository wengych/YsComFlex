package com.yspay
{
    import com.adobe.serialization.json.*;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class ServiceCall
    {
        protected var sock:Socket; // socket connection.
        protected var send_byte_arr:ByteArray; // ByteArray for sending data.

        protected var data_arrival:Boolean; // counts how many bytes that received from remote.
        protected var resp_head:Object; // json head that received from remote.
        protected var resp_body:ByteArray; // response data.
        protected var len_of_len:int; // length of current package length
        protected var resp_head_len:int; // length of head.
        protected var resp_body_len:int; // length of body.

        protected var call_back:Function;
        // protected var call_back_args:SCallArgs;

        public static const SCALL_NAME:String = '__DICT_SCALL_NAME';
        public static const REQ_TYPE_XML:String = "xml2userbus";
        public static const REQ_TYPE_BIN:String = "userbus";

        public static const RESP_TYPE_XML:String = "xml";
        public static const RESP_TYPE_BIN:String = "userbus";

        public static const BUS_TYPE_BINARY:String = "binary-bus";
        public static const BUS_TYPE_XML:String = "xml-bus";
        protected static const char_set:String = 'cn-gb';

        protected function OutputByteArray(bytes:ByteArray):void
        {
            var output_string:String = "";
            for (var idx:int = 0; idx < bytes.length; ++idx)
            {
                output_string += bytes[idx] + ' ';
            }
        }

        public function ServiceCall()
        {
            this.sock = new Socket;
            this.sock.addEventListener(Event.CONNECT, onConnect);
            this.sock.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
            this.sock.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
            this.sock.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        }

        public function Send(bus:UserBus, ip:String, port:String, func:Function,
                             req_bus_type:String=REQ_TYPE_BIN, resp_bus_type:String=RESP_TYPE_BIN):void
        {
            var len_of_len:int = 0;
            var req_head_obj:Object = new Object;
            req_head_obj['version'] = '1.0';
            req_head_obj['type'] = 'request';
            req_head_obj['reqflag'] = true;
            req_head_obj['reqtype'] = req_bus_type;
            req_head_obj['respflag'] = true;
            req_head_obj['resptype'] = resp_bus_type;
            req_head_obj['active'] = bus.GetFirst(SCALL_NAME) as String;

            var req_head:ByteArray = new ByteArray;
            var tmp:String = JSON.encode(req_head_obj);
            req_head.writeMultiByte(tmp, char_set);
            var head_len:int = req_head.length;

            // trace('head_len', head_len);
            // trace('req_head', tmp);

            var req_body:ByteArray = new ByteArray;
            var body_len:int;
            if (req_bus_type == REQ_TYPE_XML)
            {
                var xml_head:String = '<?xml version="1.0"?>\n';
                var xml_string:String = xml_head + bus.toXml();

                req_body.writeMultiByte(xml_string, char_set);
                body_len = req_body.length;

                    // trace('body_len', body_len);
                    // trace('req_body', xml_string);
            }
            else if (req_bus_type == REQ_TYPE_BIN)
            {
                req_body = bus.Pack();
                body_len = req_body.length;

                    // trace('body_len', body_len);
                    // trace('req_body', req_body);
            }

            this.send_byte_arr = new ByteArray;
            this.send_byte_arr.endian = Endian.BIG_ENDIAN;

            len_of_len = String(head_len).length;
            this.send_byte_arr.writeMultiByte(String(len_of_len), char_set);
            this.send_byte_arr.writeMultiByte(String(head_len), char_set);
            this.send_byte_arr.writeBytes(req_head);

            len_of_len = String(body_len).length;
            this.send_byte_arr.writeMultiByte(String(len_of_len), char_set);
            this.send_byte_arr.writeMultiByte(String(body_len), char_set);
            this.send_byte_arr.writeBytes(req_body);

            this.call_back = func;
            // this.call_back_args = (args == null ? new SCallArgs : args);

            // trace('ip: ', ip, 'port: ', port);
            sock.connect(ip, int(port));
        }

        protected function onIoError(event:IOErrorEvent):void
        {
            call_back(null, event);
        }

        protected function onSecurityError(event:SecurityErrorEvent):void
        {
            call_back(null, event);
        }

        protected function onConnect(event:Event):void
        {
            if (send_byte_arr == null)
                return;
            // trace(Bytes2String(send_byte_arr));

            this.sock.endian = Endian.BIG_ENDIAN;

            send_byte_arr.position = 0;
            OutputByteArray(send_byte_arr);
            this.sock.writeBytes(send_byte_arr);

            this.send_byte_arr = null;
            this.data_arrival = false;
            this.resp_head_len = -1;
            this.resp_body_len = -1;
            this.resp_head = null;
            this.resp_body = null;
        }

        protected function onSocketData(event:ProgressEvent):void
        {
            if (this.sock.connected == false)
                return;

            if (data_arrival == false)
            {
                // receive first package
                if (sock.bytesAvailable < 1)
                    return;

                // get length of head length.
                len_of_len = int(sock.readMultiByte(1, char_set));
                data_arrival = true;
            }

            if (resp_head_len == -1 && resp_head == null)
            {
                // get response head length here.
                if (sock.bytesAvailable < len_of_len)
                    return;

                resp_head_len = int(sock.readMultiByte(len_of_len, char_set));
                len_of_len = -1;
            }

            if (resp_head == null)
            {
                // get response head.
                if (sock.bytesAvailable < resp_head_len)
                    return;

                var resp_head_str:String = sock.readMultiByte(resp_head_len, char_set);
                resp_head = JSON.decode(resp_head_str);
            }

            if (len_of_len == -1 && resp_body_len == -1 && resp_body == null)
            {
                // get length of body length.
                if (sock.bytesAvailable < 1)
                    return;

                len_of_len = int(sock.readMultiByte(1, char_set));
                if (len_of_len == 0)
                {
                    // no response body
                    // error occured here.
                    // do callback.
                    trace('No response body!');
                    trace(JSON.encode(resp_head));
                    // call_back_args.json_head = resp_head;
                    // call_back_args.user_bus = null;
                    call_back(null); // call_back_args);
                    if (sock.connected)
                        sock.close();
                    return;
                }
            }

            if (resp_body_len == -1 && resp_body == null)
            {
                if (sock.bytesAvailable < len_of_len)
                    return;

                // get length of body.
                resp_body_len = int(sock.readMultiByte(len_of_len, char_set));
            }

            if (resp_body == null)
            {
                if (sock.bytesAvailable < resp_body_len)
                    return;

                // get response body.
                resp_body = new ByteArray;
                // trace('resp_body_len: ', resp_body_len);
                // trace('sock.bytesAvl: ', sock.bytesAvailable);
                sock.readBytes(resp_body, 0, resp_body_len);

                // response get over.
                // do callback.
                var factory:VarFactory = new VarFactory;
                var bus:UserBus = null;
                if (resp_head['resptype'] == ServiceCall.RESP_TYPE_XML)
                {
                    var xml_string:String = resp_body.readMultiByte(resp_body_len,
                                                                    char_set);
                    // trace('xml string:\n', xml_string);
                    // trace('xml length: ', xml_string.length);
                    // try {
                    bus = VarFactory.GetUserBus(new XML(xml_string));
                        // } catch (error:Error) {
                        //     trace (error.name, ' : ', error.message);
                        // }
                }
                else if (resp_head['resptype'] == ServiceCall.RESP_TYPE_BIN)
                {
                    //trace (ByteUtils.Bytes2String(resp_body));
                    bus = VarFactory.GetUserBus(resp_body);
                }

                // call_back_args.json_head = resp_head;
                // call_back_args.user_bus = bus;
                call_back(bus); // call_back_args);

                sock.close();
            }
        }

        private function Bytes2String(bytes:ByteArray):String
        {
            if (bytes == null)
                return '';
            var rtn:String = '';
            for (var i:int = 0; i < bytes.length; ++i)
            {
                var v_b:int = bytes[i];
                if (v_b < 16)
                    rtn += '0';
                rtn += v_b.toString(16);

                if ((i + 1) % 32 == 0)
                    rtn += '\n';
                else
                    rtn += ' ';
            }
            return rtn;
        }
    }
}
