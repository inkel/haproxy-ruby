libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

module HAProxy

  class StatsReader

    def info
      raise NotImplementedError
    end

    def errors
      raise NotImplementedError
    end

    def sessions
      raise NotImplementedError
    end

    def stats
      raise NotImplementedError
    end

    def frontends
      raise NotImplementedError
    end

    def backends
      raise NotImplementedError
    end

    def servers
      raise NotImplementedError
    end

    protected

    # Borrowed from Rails 3
    def returning(value)
      yield(value)
      value
    end

    private

    def initialize
    end

  end

end
