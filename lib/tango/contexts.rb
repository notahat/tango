require 'tango/contexts/chain'

module Tango
  module Contexts

    def as_user(username, &block)
      Chain.new.as_user(username, &block)
    end

    def in_directory(directory, &block)
      Chain.new.in_directory(directory, &block)
    end

    def with_umask(umask, &block)
      Chain.new.with_umask(umask, &block)
    end

  end
end
