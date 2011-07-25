require "test/unit"

require "../sample/census"
include Census

class TestCensus < Test::Unit::TestCase
  def setup
    @@people ||= DATA.lines.map do |line|
      name, age, sex, nationality, job = line.scan(/\w+/)
      Person[name, age.to_i, sex.intern, nationality.intern, job]
    end
  end

  def test_all_expression
    assert_equal(@@people, All.new.evaluate(@@people))
  end

  def test_only_female
    female = @@people.values_at(2, 4, 8)
    assert_equal(female, Sex.new(:F).evaluate(@@people))
  end

  def test_under_thirty
    under_thirty = @@people.values_at(0, 1, 4, 7, 8)
    assert_equal(under_thirty, Age.new(30, :<).evaluate(@@people))
  end

  def test_eighteen
    eighteens = @@people.values_at(4)
    assert_equal(eighteens, Age.new(18, :==).evaluate(@@people))
  end

  def test_american
    americans = @@people.values_at(0, 1, 2)
    assert_equal(americans, Nationality.new(:US).evaluate(@@people))
  end

  def test_only_teacher
    teachers = @@people.values_at(1, 6)
    assert_equal(teachers, Job.new('Teacher').evaluate(@@people))
  end

  def test_not_japanese
    not_japanese = @@people.values_at(0,1,2,5,6,7,8)
    assert_equal(not_japanese, Except.new(All.new, Nationality.new(:JP)).evaluate(@@people))
  end

  def test_over_thirty_male
    over_thirty_male = @@people.values_at(3, 5, 6)
    assert_equal(over_thirty_male, And.new(Age.new(30, :>), Sex.new(:M)).evaluate(@@people))
  end

  def test_under_thirty_american_and_german_programmer
    utap = @@people.values_at(0, 7)
    assert_equal(utap, And.new(And.new(Age.new(30, :<), Job.new('Programmer')), Or.new(Nationality.new(:US), Nationality.new(:DE))).evaluate(@@people))
  end

  def test_all_expression2
    assert_equal(@@people, all.evaluate(@@people))
  end

  def test_only_female2
    female = @@people.values_at(2, 4, 8)
    assert_equal(female, sex(:F).evaluate(@@people))
  end

  def test_under_thirty2
    under_thirty = @@people.values_at(0, 1, 4, 7, 8)
    assert_equal(under_thirty, age(30, :<).evaluate(@@people))
  end

  def test_eighteen2
    eighteens = @@people.values_at(4)
    assert_equal(eighteens, age(18, :==).evaluate(@@people))
  end

  def test_american2
    americans = @@people.values_at(0, 1, 2)
    assert_equal(americans, nationality(:US).evaluate(@@people))
  end

  def test_only_teacher2
    teachers = @@people.values_at(1, 6)
    assert_equal(teachers, job('Teacher').evaluate(@@people))
  end

  def test_not_japanese2
    not_japanese = @@people.values_at(0,1,2,5,6,7,8)
    assert_equal(not_japanese, except(nationality(:JP)).evaluate(@@people))
  end

  def test_over_thirty_male2
    over_thirty_male = @@people.values_at(3, 5, 6)
    assert_equal(over_thirty_male, (age(30, :>) & sex(:M)).evaluate(@@people))
  end

  def test_under_thirty_american_and_german_programmer2
    utap = @@people.values_at(0, 7)
    expression = age(30, :<) & job('Programmer') & (nationality(:US) | nationality(:DE))
    assert_equal(utap, expression.evaluate(@@people))
  end

  def test_select
    utap = @@people.values_at(0, 7)
    expression = @@people.select do |p|
      p.age < 30 && p.job == 'Programmer' && [:US,:DE].include?(p.nationality)
    end
    assert_equal(utap, expression)
  end
end


__END__
Joe, 25, M, US, Programmer
Armstrong, 28, M, US, Teacher
Karen, 43, F, US, Programmer
Ken, 38, M, JP, Doctor
Yui, 18, F, JP, Student
Paku, 33, M, KO, RestaurantOwner
Soh, 51, M, KO, Teacher
Ralf, 29, M, DE, Programmer
Naomi, 16, F, FR, Student
