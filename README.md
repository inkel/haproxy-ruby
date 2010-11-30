# HAProxy RubyGem

This gem aims to provide an interface to query HAProxy for statistics,
and eventually management through the sockets API.

## What's HAProxy?

[HAProxy](http://haproxy.1wt.eu/) is the _Reliable, High Performance
TCP/HTTP Load Balancer_.

## Why this gem?

* I use HAProxy at my work.
* I wanted to know how to create gems.
* I wanted to contribute with OSS.
* Why not?
* All of the above.

## Example of use

    #! /usr/bin/env ruby
    require 'haproxy'
    require 'pp'
    
    haproxy = HAProxy.read_stats '/path/to/haproxy.stats.socket'
    
    pp haproxy.info
    
    # {:name=>"HAProxy",
    #  :version=>"1.3.22",
    #  :release_date=>"2009/10/14",
    #  :nbproc=>"1",
    #  :process_num=>"1",
    #  :pid=>"10222",
    #  :uptime=>"0d 0h33m12s",
    #  :uptime_sec=>"1992",
    #  :memmax_mb=>"0",
    #  :ulimit_n=>"4013",
    #  :maxsock=>"4013",
    #  :maxconn=>"2000",
    #  :maxpipes=>"0",
    #  :currconns=>"1",
    #  :pipesused=>"0",
    #  :pipesfree=>"0",
    #  :tasks=>"1",
    #  :run_queue=>"1",
    #  :node=>"roke",
    #  :"description:"=>nil}
    
    pp haproxy.stats
    
    # [{:pxname=>"app1",
    #   :svname=>"thin1",
    #   :qcur=>"0",
    #   :qmax=>"0",
    #   :scur=>"0",
    #   :smax=>"0",
    #   :slim=>"",
    #   :stot=>"0",
    #   :bin=>"0",
    #   :bout=>"0",
    #   :dreq=>"",
    #   :dresp=>"0",
    #   :ereq=>"",
    #   :econ=>"0",
    #   :eresp=>"0",
    #   :wretr=>"0",
    #   :wredis=>"0",
    #   :status=>"no check",
    #   :weight=>"1",
    #   :act=>"1",
    #   :bck=>"0",
    #   :chkfail=>"",
    #   :chkdown=>"",
    #   :lastchg=>"",
    #   :downtime=>"",
    #   :qlimit=>"",
    #   :pid=>"1",
    #   :iid=>"1",
    #   :sid=>"1",
    #   :throttle=>"",
    #   :lbtot=>"0",
    #   :tracked=>"",
    #   :type=>"2",
    #   :rate=>"0",
    #   :rate_lim=>"",
    #   :rate_max=>"0"},...]

#### HAProxy sample configuration

    global
    	stats socket haproxy
    
    defaults
    	mode	http
    	option httplog
      option httpclose
    	retries	3
    	option redispatch
    	maxconn	2000
    	contimeout	5000
    	clitimeout	50000
    	srvtimeout	50000
      stats uri /haproxy
    
    listen app1 0.0.0.0:10000
    	balance	roundrobin
    
      server thin1 127.0.0.1:10001
      server thin1 127.0.0.1:10002
      server thin1 127.0.0.1:10003
      server thin1 127.0.0.1:10004
      server thin1 127.0.0.1:10005
    
    frontend app2
      bind 0.0.0.0:10011
      default_backend app2
    
    backend app2
      balance roundrobin
      server thin1 127.0.0.1:10006
      server thin1 127.0.0.1:10007
      server thin1 127.0.0.1:10008
      server thin1 127.0.0.1:10009
      server thin1 127.0.0.1:10010

## Roadmap

* Improve documentation
* Improve CSV parsing
* Add tests
* Add examples
* Read stats from HTTP and CSV files
