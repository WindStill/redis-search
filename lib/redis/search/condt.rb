class Redis
  module Search
    class Condt
      def self.make_condition(json)
        if json == "null" or MultiJson.load(json).blank?
          return "true"
        end
        hash = MultiJson.load(json)
        c = ""
        hash.keys.each_with_index do |key,i|
          if key.to_s.include? " "
            if ["Fixnum", "Float"].include? hash[key].class.to_s 
              str = "self.#{key.to_s}" + hash[key].to_s
            else
              str = hash[key] ? "self.#{key.to_s}" : "!self.#{key.to_s}"
            end
          else
            str = "self.#{key.to_s} == " + hash[key].to_s
          end
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