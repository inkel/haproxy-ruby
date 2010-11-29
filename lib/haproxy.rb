libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'uri'
Dir["#{libdir}/haproxy/*.rb"].each do |file|
  require file
end

module HAProxy

  def self.read_stats(from)
    uri = URI.parse(from)

    if uri.is_a?(URI::Generic) and File.socket?(uri.path)
      HAProxy::SocketReader.new(uri.path)
    else
      raise NotImplementedError, "Currently only sockets are implemented"
    end
  end

end
