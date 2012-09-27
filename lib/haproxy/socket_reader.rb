require 'socket'
require 'haproxy/stats_reader'
require 'haproxy/csv_parser'

module HAProxy
  class SocketReader < HAProxy::StatsReader

    def initialize(path)
      raise ArgumentError, "Socket #{path} doesn't exists or is not a UNIX socket" unless File.exists?(path) and File.socket?(path)
      @path = path
    end

    def info
      returning({}) do |info|
        send_cmd "show info" do |line|
          key, value = line.split(': ')
          info[key.downcase.gsub('-', '_').to_sym] = value
        end
      end
    end

    def errors
      returning("") do |errors|
        send_cmd "show errors" do |line|
          errors << line
        end
      end
    end

    def sessions
      returning([]) do |sess|
        send_cmd "show sess" do |line|
          sess << line
        end
      end
    end

    TYPES = {
      :frontend => 1,
      :backend => 2,
      :server => 4
    }

    def stats(types=[:all], options={})
      params = {
        :proxy => :all,
        :server => :all
      }.merge(options)

      params[:proxy] = "-1" if params[:proxy].eql?(:all)
      params[:server] = "-1" if params[:server].eql?(:all)

      types = [types] unless types.is_a?(Array)

      params[:type] = case
                      when types.eql?([:all])
                        "-1"
                      else
                        types.map{ |type| TYPES[type] }.inject(:+)
                      end

      cmd = "show stat #{params[:proxy]} #{params[:type]} #{params[:server]}"

      returning([]) do |stats|
        send_cmd(cmd) do |line|
          stats << CSVParser.parse(line) unless line.start_with?('#')
        end
      end
    end

    def disable(backend, server)
      cmd = "disable server #{backend}/#{server}"
      send_cmd(cmd)
    end

    def enable(backend, server)
      cmd = "enable server #{backend}/#{server}"
      send_cmd(cmd)
    end

    def frontends
      stats :frontend, :proxy => :all, :server => :all
    end

    def backends
      stats :frontend, :proxy => :all, :server => :all
    end

    def servers
      stats :server, :proxy => :all, :server => :all
    end

    protected

    def send_cmd(cmd, &block)
      socket = UNIXSocket.new(@path)
      socket.write(cmd + ';')
      socket.each do |line|
        next if line.chomp.empty?
        yield(line.strip)
      end
    end

  end
end
