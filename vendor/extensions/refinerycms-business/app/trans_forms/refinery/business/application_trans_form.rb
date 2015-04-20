module Refinery
  module Business
    class ApplicationTransForm < TransForms::FormBase
      # Here you can place application specific code to customize the
      # default behavior of TransForms.
      #
      # Here is an example of a custom instantiator that works to set
      # a model and current_user attributes in addition to the params
      # which might come directly from the controller.
      #
      #   def self.new_in_model(model, params = {}, current_user = nil)
      #     new(params.merge(model: model, current_user: current_user))
      #   end

      attr_accessor :current_user

      def self.new_in_model(model, params = {}, current_user = nil)
        new((params || {}).merge(model: model, current_user: current_user))
      end


      # A method to parse the attribute structure of nested child models
      # in the form that the helper +fields_for+ will send it.
      #
      # For example:
      #
      #   nested_attributes = {
      #     '0' => { title: 'Book #1', price: '$0.99' },
      #     '1' => { title: 'Book #2', price: '$1.49' }
      #   }
      #
      #   # Calling +each_nested_hash_for+ with the above attribute structure
      #   # will yield the block once for each of the following two Hashes:
      #
      #   # => { 'title' => 'Book #1', 'price' => '$0.99' }
      #   # => { 'title' => 'Book #2', 'price' => '$1.49' }
      #
      # Note how the Hash objects yielded to the block has converted the keys
      # to strings instead of symbols. This is intentional to keep the behavior
      # persistent.
      #
      def each_nested_hash_for(attr, &block)
        if attr.is_a?(Hash)
          idx = -1
          attr.values.each do |v|
            if v.is_a?(Hash)
              block.call(v.stringify_keys, idx += 1)
            end
          end
        end
      end

    end
  end
end
