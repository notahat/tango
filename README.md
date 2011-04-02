Credit Where It's Due
---------------------

This is a re-invention of Ben Hoskings's excellent
[Babushka](https://github.com/benhoskings/babushka).

There are a bunch of things I love about Babushka, and a bunch of other things
that really don't fit with the way we want to use it at
[Envato](http://envato.com/). Tango is an experiment in changing around a few
of Babushka's fundamentals to try to find a better fit.


Bootstrapping Ubuntu
--------------------

    sudo apt-get install -y ruby irb rdoc

    # Use the real rubygems, not the silly apt version. 
    wget http://production.cf.rubygems.org/rubygems/rubygems-1.6.2.tgz
    tar -zxvf rubygems-1.6.2.tgz
    cd rubygems-1.6.2
    sudo ruby setup.rb --no-format-executable

    sudo gem install tango

Example Runner
--------------

    class AptInstaller < Tango::Runner
      def installed?(package)
        shell("dpkg-query", "--status", package, :echo => false).output !~ /not.installed|deinstall/
      end

      step "install" do |package|
        met? { installed?(package) }
        # Need to figure out how to make this non-interactive. See:
        # http://ubuntuforums.org/showthread.php?t=1218525
        meet { shell("apt-get", "install", "-y", package) }
      end
    end

    class GemInstaller < Tango::Runner
      def installed?(gem)
        shell("gem", "query", "--installed", "--name-matches", gem, :echo => false).output =~ /true/
      end

      step "install" do |gem|
        met? { installed?(gem) }
        meet { shell("gem", "install", gem) }
      end
    end

    class ExampleInstaller < Tango::Runner
      def initialize
        @apt = AptInstaller.new
        @gem = GemInstaller.new
      end

      step "install" do
        @apt.install "build-essential"

        @apt.install "mysql-server"
        @apt.install "libmysqlclient-dev"

        @apt.install "git-core"

        @gem.install "bundler"
      end
    end

Running the Example
-------------------

    tango example_installer.rb ExampleInstaller.install

Copyright
---------

Copyright © 2011 Envato &amp; Pete Yandell. See LICENSE for details.
