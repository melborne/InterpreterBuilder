# encoding: UTF-8
class String
  alias _capitalize capitalize
  def capitalize
    self.split('_').map(&:_capitalize).join
  end
end

module InterpreterBuilder
  def define_terminal(name, superclass, target_meth, converter=->p{p}, function=true)
    define_node(name, superclass, target_meth, function) do |*dir|
      converter[*dir].select { |item| yield item, *@attrs }
    end
  end

  def define_nonterminal(name, superclass, target_meth, op, function=true)
    define_node(name, superclass, target_meth, function) do |*dir|
      f1, *f2 = @attrs.map { |attr| attr.send(target_meth, *dir) }
      f1.send(op, *f2)
    end
  end

  def define_node(name, superclass, target_meth, function, &blk)
    klass = Class.new(superclass) do
      def initialize(*attrs)
        *@attrs = attrs
      end
      define_method(target_meth, &blk)
    end
    const_set(name.to_s.capitalize, klass)
    define_function(name) if function
  end

  def define_function(name)
    self.class_eval {
      define_method(name) do |*args|
        Module.const_get(name.to_s.capitalize).new(*args)
      end
    }
  end
end
