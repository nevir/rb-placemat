# Miscellaneous utility methods that have no home elsewhere.
module Placemat::Util
  class << self
    def symbol_to_path(value)
      path_parts = value.split('::').map do |part|
        part.gsub!(/([^A-Z])([A-Z]+)/,          '\\1_\\2') # OneTwo -> One_Two
        part.gsub!(/([A-Z]{2,})([A-Z][^A-Z]+)/, '\\1_\\2') # ABCOne -> ABC_One

        part.downcase
      end

      File.join(path_parts)
    end

    def line_matching(path, matcher)
      File.open(path) do |file|
        file.each_line do |line|
          match = matcher.match(line)
          return match if match
        end
      end

      nil
    end

    def files_under(base_path, match_mode = File::FNM_DOTMATCH)
      matches = Dir.glob(File.join(base_path, '**', '*'), match_mode)
      matches.reject! { |f| File.directory? f }

      matches
    end
  end
end
