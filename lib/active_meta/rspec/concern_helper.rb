RSpec::Matchers.define :define_concern_attribute do |attribute|
  description do
    "should define concern attribute '#{attribute}'"
  end

  match do |klass|
    eval_block = klass.instance_eval{ @eval_block }
    ActiveMeta::Rspec::Mock::Concern.new.instance_eval(&eval_block).attribute_defined? attribute
  end

  failure_message do |klass|
    "expected #{klass.class.name} concern to define attribute #{attribute}"
  end

  failure_message_when_negated do |klass|
    "expected #{klass.class.name} concern to not concern attribute #{attribute}"
  end
end


RSpec::Matchers.define :receive_meta_recipe do |*args|
  description do
    method_name = args.first
    arguments   = args[1..-1]
    "receive meta recipe '#{method_name}'#{" with arguments: #{arguments}" if arguments.length > 0}"
  end

  match do |klass|
    eval_block = klass.instance_eval{ @eval_block }
    mock = ActiveMeta::Rspec::Mock::Concern.new.instance_eval(&eval_block)
    target = @matcher_execution_context.class.metadata[:description].gsub(/^attribute /, '').to_sym
    mock_target = mock.attributes[target].methods_called[args.first]
    return nil unless mock_target
    mock_target == args[1..-1]
  end

  failure_message do |klass|
    target = @matcher_execution_context.class.metadata[:description].gsub(/^attribute /, '').to_sym
    "expected attribute :#{args.first} to receive meta recipe :#{args.first} with #{args[1..-1]}"
  end

  failure_message_when_negated do |klass|
    target = @matcher_execution_context.class.metadata[:description].gsub(/^attribute /, '').to_sym
    "expected attribute :#{target} to not receive meta recipe :#{args.first}"
  end
end
