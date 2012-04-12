class Redis
  module Search
    class Condt
      def self.make_condition(json)
        if json == "null" or MultiJson.decode(json).blank?
          return "true"
        end
        hash = MultiJson.decode(json)
        puts hash.keys
        c = ""
        hash.keys.each_with_index do |key,i|
          str = "self.#{key.to_s}" + i.to_s
          if i == 0
            c = str
          else
            c = c + " and " + str
          end
        end
        c
      end
    end
  end
end