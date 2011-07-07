module Tango
  module Fetch

    def fetch(url)
      shell("curl", "-O", "-C", "-", "-L", "--progress-bar", url)
    end

  end
end
