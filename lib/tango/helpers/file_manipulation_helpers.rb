module Tango
  module Helpers
    module FileManipulationHelpers

      require 'pathname'

      private

      # shameless stolen from babushka and ported to work with plain ruby without so much magic
      def insert_into_file(insert_before, path, lines)
        #@insert_after = nil

        nlines = lines.split("\n").length
        before, after = cut(Pathname.new(path).readlines, insert_before)

        write path, [ before, comment_string, lines, after ].join
      end

      def comment_string
        comment_char = '#'
        "#{comment_char} Envato config added #{Time.now}\n"
      end

      def cut(data, cut_before)
        index = data.index{ |l| l.strip == cut_before.strip }
        raise "Couldn't find the spot to cut." if index.nil?
        [data[0...index], data[index..-1]]
      end

      def change_line(line_regex, replacement, filename)
        replaced = false
        contents = Pathname.new(filename).readlines.collect do |line|
          if line =~ line_regex
            replaced = true
            [comment_string, "#{replacement.chomp}\n"]
          else
            line
          end
        end.flatten
        raise "couldnt find the specified line" unless replaced
        File.open(filename, 'w') do |f|
          contents.each{|line| f.write line }
        end
      end

      def grep(pattern, file)
        !!(File.read(file) =~ pattern)
      end

      # for files where attributes are specified:
      # attribute_name value
      def change_config_attribute(keyword, from, to, file)
        # Remove the incorrect setting if it's there
        contents = File.open(file).reject do |line|
          line.match(/^#{keyword}\s+#{from}/)
        end

        # Add the correct setting unless it's already there
        if contents.none?{|line| line.match /^#{keyword}\s+#{to}/ }
          contents << "#{keyword} #{to}\n"
        end

        File.open(file, 'w') do |f|
          contents.each{|line| f.write line}
        end
      end

    end
  end
end
