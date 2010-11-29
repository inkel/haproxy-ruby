module HAProxy
  class CSVParser

    # Uses CSV header from HAProxy 1.5, which is backwards compatible
    COLUMNS = "pxname,svname,qcur,qmax,scur,smax,slim,stot,bin,bout,dreq,dresp,ereq,econ,eresp,wretr,wredis,status,weight,act,bck,chkfail,chkdown,lastchg,downtime,qlimit,pid,iid,sid,throttle,lbtot,tracked,type,rate,rate_lim,rate_max,check_status,check_code,check_duration,hrsp_1xx,hrsp_2xx,hrsp_3xx,hrsp_4xx,hrsp_5xx,hrsp_other,hanafail,req_rate,req_rate_max,req_tot,cli_abrt,srv_abrt".split(",").map(&:to_sym)
    LIMIT = COLUMNS.length

    def self.parse(line)
      line.strip!
      unless line.start_with? "#"
        data = line.split(',')
        pxname = data.shift

        stats = { :pxname => pxname }

        data.each_with_index do |value, i|
          if i < LIMIT
            stats[COLUMNS[i + 1]] = value
          else
            stats[:extra] = Array.new if stats[:extra].nil?
            stats[:extra] << value
          end
        end

        stats
      else
        raise ArgumentError, "Line is a comment"
      end
    end
  end

end
