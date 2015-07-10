module RSpec::Core::MemoizedHelpers
  def subject
    __memoized.fetch(:subject) do
      __memoized[:subject] = begin
        described = described_class || self.class.metadata.fetch(:description_args).first
        # Class === described_class ? described_class.new : described_class
      end
    end
  end
end

RSpec::Matchers.define :inherit_from do |superclass|
  match do |klass|
    klass.ancestors.include? superclass
  end

  failure_message do |klass|
    "expected #{klass.name} to inherit from #{superclass}"
  end

  failure_message_when_negated do |klass|
    "expected #{klass.name} not to inherit from #{superclass}"
  end
end
