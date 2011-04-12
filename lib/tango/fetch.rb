module Tango
  module Fetch

    def fetch(url)
      shell("wget", "--progress=bar:force", "--continue", url)
    end

  end
end
