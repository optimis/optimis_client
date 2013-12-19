# In order to have a painless upgrade to the newest Typhoeus,
# we do some dirty hack to ensure Typhoeus generate the same
# request params format as the old Typhoeus does.

module Ethon
  class Easy
    module Queryable
      private
      def recursively_generate_pairs(h, prefix, pairs)
        case h
        when Hash
          h.each_pair do |k,v|
            key = prefix.nil? ? k : "#{prefix}[#{k}]"
            pairs_for(v, key, pairs)
          end
        when Array
          h.each_with_index do |v, i|
            key = "#{prefix}[]"
            pairs_for(v, key, pairs)
          end
        end
      end
    end
  end
end
