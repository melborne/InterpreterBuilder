# encoding: UTF-8
require_relative "../lib/interpreter_builder"

module Census
  extend InterpreterBuilder
  
  Person = Struct.new(:name, :age, :sex, :nationality, :job)  
  
  class Expression
    def |(other)
      Or.new(self, other)
    end

    def &(other)
      And.new(self, other)
    end
    
    def evaluate(people)
      raise "override this method in the subclass"
    end
  end

  subclasses = {
    all: ->person { true },
    sex: ->person,sex { person.sex == sex },
    age: ->person,age,op { person.age.send(op, age) },
    nationality: ->person, nation { person.nationality == nation },
    job: ->person,job { person.job == job }
  }
  
  subclasses.each do |name, blk|
    define_terminal(name, Expression, :evaluate, &blk)
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

  # module Interface
    # def all
    #   All.new
    # end

    # def sex(sex)
    #   Sex.new(sex)
    # end
    # 
    # def age(age, op)
    #   Age.new(age, op)
    # end
    # 
    # def nationality(n)
    #   Nationality.new(n)
    # end
    # 
    # def job(job)
    #   Job.new(job)
    # end
    # 
    # def except(expression1, expression2)
    #   Except.new(expression1, expression2)
    # end
  # end

  # include Interface

  # class All < Expression
  #   def evaluate(people)
  #     super { true }
  #   end
  # end

  # class Sex < Expression
  #   def initialize(sex)
  #     @sex = sex
  #   end
  # 
  #   def evaluate(people)
  #     super { |p| p.sex == @sex }
  #   end
  # end

  # class Age < Expression
  #   def initialize(age, op)
  #     @age, @op = age, op
  #   end
  # 
  #   def evaluate(people)
  #     super { |p| p.age.send(@op, @age) }
  #   end
  # end

  # class Nationality < Expression
  #   def initialize(nationality)
  #     @nationality = nationality
  #   end
  # 
  #   def evaluate(people)
  #     super { |p| p.nationality == @nationality }
  #   end
  # end

  # class Job < Expression
  #   def initialize(job)
  #     @job = job
  #   end
  # 
  #   def evaluate(people)
  #     super { |p| p.job == @job }
  #   end
  # end

  # class Except < Expression
  #   def initialize(expression1, expression2)
  #     @expression1 = expression1
  #     @expression2 = expression2
  #   end
  # 
  #   def evaluate(people)
  #     @expression1.evaluate(people) - @expression2.evaluate(people)
  #   end
  # end
  # 
  # class Or < Expression
  #   def initialize(expression1, expression2)
  #     @expression1, @expression2 = expression1, expression2
  #   end
  # 
  #   def evaluate(people)
  #     @expression1.evaluate(people) | @expression2.evaluate(people)
  #   end
  # end
  # 
  # class And < Expression
  #   def initialize(expression1, expression2)
  #     @expression1, @expression2 = expression1, expression2
  #   end
  # 
  #   def evaluate(people)
  #     @expression1.evaluate(people) & @expression2.evaluate(people)
  #   end
  # end
end
