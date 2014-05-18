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
  end
end
