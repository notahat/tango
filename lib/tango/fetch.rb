module Tango
  module Fetch

    def fetch(url)
      shell("curl", "-O", "-C", "-", "--progress-bar", url)
    end

  end
end
