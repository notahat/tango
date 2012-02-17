# coding: utf-8

module Tango
  module Fetch

    def fetch(url)
      if have_wget?
        shell("wget", "--progress=bar:force", "--continue", url)
      else
        shell("curl", "-O", "-C", "-", "-L", "--progress-bar", url)
      end
    end

  private

    def have_wget?
      shell("which", "wget", :echo => false).succeeded?
    end

  end
end
