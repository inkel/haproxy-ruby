require File.expand_path('../spec_helper.rb', __FILE__)
require File.expand_path('../../lib/haproxy', __FILE__)

describe HAProxy::SocketReader do

  it "should accept an existing socket file" do
    HAProxy::Test.with_socket do |path|
      HAProxy::SocketReader.new(path).should_not be_nil
    end
  end

  it "should fail without an existing socket file" do
    Tempfile.new('invalid-file') do |file|
      file.path.should_not be_socket
      HAProxy::SocketReader.new(file.path).should_raise ArgumentError
    end.close!
  end

  it "should return a Hash with proxy information" do
    HAProxy::Test.with_socket(:info) do |path|
      reader = HAProxy::SocketReader.new(path)
      reader.info.class.should == Hash
    end
  end

  it "should return a String when asking for errors" do
    HAProxy::Test.with_socket(:without_errors) do |path|
      reader = HAProxy::SocketReader.new(path)
      reader.errors.class.should == String
    end

    HAProxy::Test.with_socket(:with_errors) do |path|
      reader = HAProxy::SocketReader.new(path)
      reader.errors.class.should == String
    end
  end

  it "should return a String when asking for sessions" do
    HAProxy::Test.with_socket(:without_sessions) do |path|
      reader = HAProxy::SocketReader.new(path)
      reader.sessions.class.should == Array
    end

    HAProxy::Test.with_socket(:with_sessions) do |path|
      reader = HAProxy::SocketReader.new(path)
      reader.sessions.class.should == Array
    end
  end

  [ :frontends, :backends, :servers ].each do |type|
    it "should return an Array with #{type} information" do
      HAProxy::Test.with_socket do |path|
        reader = HAProxy::SocketReader.new(path)
        reader.send(type).class.should == Array
      end
    end
  end

end
