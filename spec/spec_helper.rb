require 'tempfile'

module HAProxy

  module Test

    class << self
      def temp_file_path
        tmp = Tempfile.new('haproxy-ruby-mocksock')
        path = tmp.path
        tmp.close!
        path
      end

      def with_socket action = nil, &block
        path = self.temp_file_path

        UNIXServer.open(path) do |socket|
          pid = Process.fork do
            client = socket.accept
            cmd, data = client.recvfrom(1024)
            cmd.chomp!
            client.send self.send(action || :unknown), 0
            client.close
            exit
          end

          block.call(path)

          Process.kill "TERM", pid rescue nil
        end
      end

      def unknown
        "Unknown command"
      end

      def info
        """Name: HAProxy
Version: 1.3.25
Release_date: 2010/06/16
Nbproc: 1
Process_num: 1
Pid: 20518
Uptime: 6d 7h07m46s
Uptime_sec: 544066
Memmax_MB: 0
Ulimit-n: 80110
Maxsock: 80110
Maxconn: 40000
Maxpipes: 0
CurrConns: 28
PipesUsed: 0
PipesFree: 0
Tasks: 125
Run_queue: 1
node: A1441
description
"""
      end

      def with_errors
        '''
[09/Mar/2011:16:05:48.038] frontend http-in (#1): invalid request
  src 10.0.111.185, session #25765333, backend <NONE> (#-1), server <NONE> (#-1)
  request length 352 bytes, error at position 23:

  00000  POS LWqEQR/710 HTTP/1.1\x00\x00Content-Type: application/x-fcs\x00\x00
  00058+ User- HTTP/1.1\r\n
  00074  kwave Flash\r\n
  00087  Host: 10.0.49.24\x00\x00Content-Length: 1\x00\x00P\r\n
  00128  xy-Connection: Keep\r\n
  00149  live\x00\x00Pragm\r\n
  00162   no-cache\x00\x00X-NovINet: v1.2\x00\x00\x00\n
  00192  \r\n
  00194  \n
  00195  k\xC3\xD9\xFB\x02\x9F\x02\r\x08\xBC\xDB\x1E\xD3Z[\xD4]\xDD%O\x0FX\x01
  00218+ \xDD\x02\xB4\x98\xB4r\x87\xDB\x88\xD4\xBD\xA6\xBD\x80@\x15\x9D\x1A\xA7
  00237+ \xE8,\x8B\x01\x1Ft\x97\x80\xDB\xBF\x87\xAD\x15\r\xDE\x9E\x0CL\x13 FB
  00259+ \x822\xAA\xE0G\x10\t\xC3\xBC\e\xD0!\xC2dYh/\x01\x8A~\x85]z1\xC00\xBF
  00286+ \xC5\x14\xFA\x7F\x03\xF2\xC1\x06\x10\r\n
  00297  X\xA4Cqj0\xFC\x81\x14\xF2U\n
  00309  (0\xBF\xC12<\xA0:\xB2\x84\xC5\xA1\xFAa01\xD0-\xF2\x85\xC8\xB0\r\n
  00333  \x96$\x16\xB6\xB2\r,\x1D\x8B\x93\xAED\xBA\x9BE\r\n
  00350  \r\n
'''
      end

      def without_errors
        ""
      end

      def with_sessions
        '''0xa14a288: proto=tcpv4 src=10.0.16.1:56772 fe=http-in be=gelderlander_textlink srv=mongrel-10306 as=0 ts=08 age=49s calls=5 rq[f=00f0a0h,l=0,an=00h,rx=,wx=,ax=] rp[f=001000h,l=0,an=10h,rx=4s,wx=,ax=] s0=[7,0h,fd=13,ex=] s1=[7,0h,fd=16,ex=] exp=4s
0x9745898: proto=tcpv4 src=10.0.73.31:2778 fe=http-in be=gelderlander_textlink srv=mongrel-10315 as=0 ts=08 age=42s calls=4 rq[f=009080h,l=0,an=00h,rx=,wx=,ax=] rp[f=001000h,l=0,an=10h,rx=8s,wx=,ax=] s0=[7,0h,fd=19,ex=] s1=[7,8h,fd=20,ex=] exp=8s
0xa26cff0: proto=tcpv4 src=10.0.221.60:19546 fe=http-in be=limburger_textlink srv=mongrel-10708 as=0 ts=08 age=40s calls=4 rq[f=009080h,l=0,an=00h,rx=,wx=,ax=] rp[f=001000h,l=0,an=10h,rx=10s,wx=,ax=] s0=[7,0h,fd=25,ex=] s1=[7,8h,fd=26,ex=] exp=10s
0x9f2dff0: proto=tcpv4 src=10.0.45.76:59090 fe=http-in be=tctubantia_textlink srv=mongrel-10507 as=0 ts=08 age=38s calls=5 rq[f=00f0a0h,l=0,an=00h,rx=,wx=,ax=] rp[f=001000h,l=0,an=10h,rx=11s,wx=,ax=] s0=[7,0h,fd=23,ex=] s1=[7,0h,fd=24,ex=] exp=11s
0xa2cb998: proto=tcpv4 src=10.0.108.32:1734 fe=http-in be=tctubantia_textlink srv=mongrel-10505 as=0 ts=08 age=37s calls=3 rq[f=009080h,l=0,an=00h,rx=,wx=,ax=] rp[f=001000h,l=0,an=10h,rx=12s,wx=,ax=] s0=[7,0h,fd=28,ex=] s1=[7,8h,fd=29,ex=] exp=12s
0xa04b7e8: proto=tcpv4 src=10.0.148.59:1158 fe=http-in be=destentor_textlink srv=mongrel-10403 as=0 ts=08 age=34s calls=4 rq[f=009080h,l=0,an=00h,rx=,wx=,ax=] rp[f=001000h,l=0,an=10h,rx=16s,wx=,ax=] s0=[7,0h,fd=32,ex=] s1=[7,8h,fd=33,ex=] exp=16s
0x97d0b90: proto=tcpv4 src=10.0.133.111:50836 fe=http-in be=tctubantia_textlink srv=mongrel-10510 as=0 ts=08 age=21s calls=4 rq[f=009080h,l=0,an=00h,rx=,wx=,ax=] rp[f=001000h,l=0,an=10h,rx=29s,wx=,ax=] s0=[7,0h,fd=1,ex=] s1=[7,8h,fd=8,ex=] exp=29s
0x96b1220: proto=tcpv4 src=10.0.217.27:14445 fe=http-in be=gelderlander_textlink srv=mongrel-10310 as=0 ts=08 age=19s calls=4 rq[f=009080h,l=0,an=00h,rx=,wx=,ax=] rp[f=001000h,l=0,an=10h,rx=30s,wx=,ax=] s0=[7,0h,fd=21,ex=] s1=[7,8h,fd=22,ex=] exp=30s
0xa12e7a8: proto=tcpv4 src=10.0.34.84:49421 fe=http-in be=gelderlander_textlink srv=mongrel-10303 as=0 ts=08 age=16s calls=4 rq[f=009080h,l=0,an=00h,rx=,wx=,ax=] rp[f=001000h,l=0,an=10h,rx=33s,wx=,ax=] s0=[7,0h,fd=15,ex=] s1=[7,8h,fd=17,ex=] exp=33s
0x9b5f570: proto=tcpv4 src=10.0.242.177:50124 fe=http-in be=limburger_textlink srv=mongrel-10701 as=0 ts=08 age=14s calls=4 rq[f=009080h,l=0,an=00h,rx=,wx=,ax=] rp[f=001000h,l=0,an=10h,rx=35s,wx=,ax=] s0=[7,0h,fd=38,ex=] s1=[7,8h,fd=40,ex=] exp=35s
0x9fda668: proto=unix_stream as=2 ts=09 age=0s calls=2 rq[f=00e042h,l=10,an=20h,rx=10s,wx=,ax=] rp[f=048060h,l=2499,an=00h,rx=,wx=10s,ax=] s0=[7,0h,fd=2,ex=] s1=[0,0h,fd=-1,ex=] exp=10s
'''
      end

      def without_sessions
        ""
      end

    end
  end
end
