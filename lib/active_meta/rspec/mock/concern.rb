module ActiveMeta
  module Rspec
    module Mock
      class Concern
        class Stubber
          attr_accessor :methods_called

          def initialize(&block)
            instance_eval(&block) if block_given?
            self
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
          if @attributes[attribute_name]
            @attributes[attribute_name].instance_eval(&block)
          else
            @attributes[attribute_name] = Stubber.new(&block)
          end
          self
        end

        def attribute_defined?(attribute)
          !!@attributes[attribute]
        end
      end
    end
  end
end
