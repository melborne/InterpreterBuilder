require "find"
require_relative "../lib/interpreter_builder"

module FileSelect
  extend InterpreterBuilder
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
      Find.find(dir).select { |f| File.file? f }
    end
  end

  terminals = {
    all: ->f { true },
    file_name: ->f, pattern{ File.fnmatch pattern, File.basename(f) },
    bigger: ->f, size{ File.size(f) > size },
    writable: ->f { File.writable? f }
  }
  
  terminals.each do |name, blk|
    converter =->dir{ Expression.new.files(dir) }
    define_terminal(name, Expression, :evaluate, converter, &blk)
  end
  
  nonterminals = {
    except: :-,
    or: :|,
    and: :&
  }
  
  nonterminals.each do |name, op|
    define_nonterminal(name, Expression, :evaluate, op, false)
  end

  def except(exp)
    Except.new(All.new, exp)
  end
end
