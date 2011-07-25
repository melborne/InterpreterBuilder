# Interpreter Pattern
require "find"

module FileSelect
  module Interface
    def all
      All.new
    end

    def filename(pattern)
      FileName.new(pattern)
    end

    def bigger(size)
      Bigger.new(size)
    end

    def except(expression)
      Not.new(expression)
    end

    def writable
      Writable.new
    end
  end

  class Expression
    def |(other)
      Or.new(self, other)
    end

    def &(other)
      And.new(self, other)
    end

    def evaluate(dir)
      files(dir).select { |f| yield f }
    end

    def files(dir)
      dir = File.expand_path(dir)
      Find.find(dir).each_with_object([]) do |f, mem|
        mem << f if File.file?(f)
      end
    end
  end

  class All < Expression
    def evaluate(dir)
      super { true }
    end
  end

  class FileName < Expression
    def initialize(pattern)
      @pattern = pattern
    end

    def evaluate(dir)
      super { |p| File.fnmatch(@pattern, File.basename(p)) }
    end
  end

  class Bigger < Expression
    def initialize(size)
      @size = size
    end

    def evaluate(dir)
      super { |p| File.size(p) > @size }
    end
  end

  class Writable < Expression
    def evaluate(dir)
      super { |p| File.writable? p }
    end
  end

  class Not < Expression
    def initialize(expression)
      @expression = expression
    end

    def evaluate(dir)
      All.new.evaluate(dir) - @expression.evaluate(dir)
    end
  end

  class Or < Expression
    def initialize(expression1, expression2)
      @expression1 = expression1
      @expression2 = expression2
    end

    def evaluate(dir)
      @expression1.evaluate(dir) | @expression2.evaluate(dir)
    end
  end

  class And < Expression
    def initialize(expression1, expression2)
      @expression1 = expression1
      @expression2 = expression2
    end

    def evaluate(dir)
      @expression1.evaluate(dir) & @expression2.evaluate(dir)
    end
  end
  include Interface
end
