libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'uri'
Dir["#{libdir}/haproxy/*.rb"].each do |file|
  require file
end

module HAProxy

  def self.read_stats(*from)
    if from.length == 1
      from = from[0]
      uri = URI.parse(from)

      if uri.is_a?(URI::Generic) and File.socket?(uri.path)
        HAProxy::SocketReader.new(uri.path)
      else
        raise NotImplementedError, "Invalid socket path provided."
      end
    elsif from.length == 2
      HAProxy::SocketReader.new(from[0], from[1])
    else
      raise NotImplementedError, "Only UNIX Sockets and host/port combinations are supported"
    end
  end

end
