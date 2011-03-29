Example
-------

    class Homebrew < Tango::Namespace
      def installed?(formula)
        `brew info #{formula}` !~ /Not installed/
      end

      step "bootstrap" do
        met? { system "brew info" }

        meet do
          system %{ruby -e "$(curl -fsSL https://gist.github.com/raw/323731/install_homebrew.rb)"}
        end
      end

      step "install" do |formula|
        met? { installed?(formula) }
        meet { system "brew install #{formula}" }
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
        meet { system "brew install --no-gtk mtr" }
      end
    end
