require 'active_meta/rspec/mock/concern'

class ActiveMeta::Attribute
  attr_accessor :eval_block
  def initialize(attribute, &block)
    @attribute = attribute
    @rules = []
    @eval_block = block
    instance_eval(&block)
  end
end


RSpec::Matchers.define :define_active_meta_attribute do |attribute|
  description do
    "should define attribute '#{attribute}'"
  end

  match do |described_item|
    if described_item.name =~ /^ActiveMeta::Concerns::/
      eval_block = described_item.instance_eval{ @eval_block }
      ActiveMeta::Rspec::Mock::Concern.new.instance_eval(&eval_block).attribute_defined? attribute
    elsif described_item.name =~ /^Meta::/
      described_item.attributes[attribute]
    else
      raise "Described item #{described_item} is not a Concern or a Meta class"
    end
  end

  failure_message do |described_item|
    "expected #{described_item.class.name} to define attribute #{attribute}"
  end

  failure_message_when_negated do |described_item|
    "expected #{described_item.class.name} to not define attribute #{attribute}"
  end
end


RSpec::Matchers.define :receive_active_meta_rule do |*args|
  description do
    method_name = args.first
    arguments   = args[1..-1]
    "receive meta rule '#{method_name}'#{" with arguments: #{arguments}" if arguments.length > 0}"
  end

  match do |described_item|
    target = @matcher_execution_context.class.metadata[:description].gsub(/^attribute /, '').to_sym
    if described_item.name =~ /^ActiveMeta::Concerns::/
      eval_block = described_item.instance_eval{ @eval_block }
      mock = ActiveMeta::Rspec::Mock::Concern.new.instance_eval(&eval_block)
    elsif described_item.name =~ /^Meta::/
      eval_block = described_item.attributes[target].eval_block
      mock = ActiveMeta::Rspec::Mock::Concern::Stubber.new(&eval_block)
    else
      raise "Described item #{described_item} is not a Concern or a Meta class"
    end
    mock_target = mock.attributes[target].methods_called[args.first]
    return nil unless mock_target
    mock_target.each_with_index.all? do |item, idx|
      next true if item.is_a?(Proc)
      item == args[idx + 1]
    end
  end

  failure_message do |described_item|
    target = @matcher_execution_context.class.metadata[:description].gsub(/^attribute /, '').to_sym
    "expected attribute :#{args.first} to receive meta rule :#{args.first} with #{args[1..-1]}"
  end

  failure_message_when_negated do |described_item|
    target = @matcher_execution_context.class.metadata[:description].gsub(/^attribute /, '').to_sym
    "expected attribute :#{target} to not receive meta rule :#{args.first}"
  end
end

RSpec::Matchers.define :extend_active_meta_concern do |concern|
  description do
    "extend concern '#{concern}'"
  end

  match do |described_item|
    modules = described_item.singleton_class.included_modules.map do
      |mod| mod if mod.to_s  =~ /^ActiveMeta::Concerns::Save::*/
    end.compact
    modules.include?(concern)
  end

  failure_message do |described_item|
    "expected #{described_item} to include concern #{concern}"
  end

  failure_message_when_negated do |described_item|
    "expected #{described_item} to not include concern #{concern}"
  end
end
