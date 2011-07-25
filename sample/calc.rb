# encoding: UTF-8
require_relative "../lib/interpreter_builder"

class Fixnum
  def x
    self
  end
end

module Calc
  extend InterpreterBuilder
  
  class Expression
    def x(n)
    end
  end
  
  nonterminals = {
    plus: :+,
    minus: :-,
    multiple: :*,
    divide: :/
  }
  
  nonterminals.each do |name, op|
    define_nonterminal(name, Expression, :x, op)
  end
end