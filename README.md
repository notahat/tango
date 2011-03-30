Credit Where It's Due
---------------------

This is a re-invention of Ben Hoskings's excellent
[Babushka](https://github.com/benhoskings/babushka).

There are a bunch of things I love about Babushka, and a bunch of other things
that really don't fit with the way we want to use it at
[Envato](http://envato.com/). Tango is an experiment in changing around a few
of Babushka's fundamentals to try to find a better fit.


Example
-------

    class Homebrew < Tango::Namespace
      def installed?(formula)
        shell("brew", "info", formula, :echo => false).output !~ /Not installed/
      end

      step "bootstrap" do
        met? { shell("brew info").succeeded? }
        meet { shell(%{ruby -e "$(curl -fsSL https://gist.github.com/raw/323731/install_homebrew.rb)"}) }
      end

      step "install" do |formula|
        met? { installed?(formula) }
        meet { shell("brew, "install", formula) }
      end
    end

    class MyNamespace < Tango::Namespace
      step "install" do
        Homebrew.run "bootstrap"
        Homebrew.run "install", "git"
        Homebrew.run "install", "mysql"
        run "install mtr"
      end

      step "install mtr" do
        met? { Homebrew.installed?("mtr") }
        meet { shell("brew install --no-gtk mtr") }
      end
    end

