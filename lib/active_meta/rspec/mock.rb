module ActiveMeta
  module Rspec
    module Mock
      class Concern
        class Stubber
          attr_accessor :methods_called

          def initialize(&block)
            instance_eval(&block)
          end

          def method_missing(method_name, *args, &block)
            @methods_called ||= {}
            @methods_called[method_name] = args
            self
          end
        end

        attr_accessor :attributes

        def attribute(attribute_name, &block)
          @attributes ||= {}
          @attributes[attribute_name] = Stubber.new(&block)
          self
        end

        def attribute_defined?(attribute)
          !!@attributes[attribute]
        end
      end
    end
  end
end
