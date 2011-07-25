require "test/unit"
require "../sample/file_finder"
include FileSelect

class TestFileFinder < Test::Unit::TestCase
  def setup
    @dir = '~/Dropbox/workspace'
  end
  
  def test_all_files
    all = All.new
    assert_equal(184, all.evaluate(@dir).size)
  end

  def test_only_rb_files
    rb = FileName.new('*.rb')
    assert_equal(28, rb.evaluate(@dir).size)
  end

  def test_bigger_files
    big = Bigger.new(20000)
    assert_equal(12, big.evaluate(@dir).size)
  end

  def test_readonly_files
    ro = Except.new(All.new, Writable.new)
    assert_equal(1, ro.evaluate(@dir).size)
  end

  def test_readonly_bigger_or_rb_files
    rwbig_or_rb = (Bigger.new(20000) & Writable.new) | FileName.new('*.rb')
    assert_equal(40, rwbig_or_rb.evaluate(@dir).size)
  end

  def test_functions
    rwbig_or_rb = (bigger(20000) & writable) | file_name('*.rb')
    assert_equal(40, rwbig_or_rb.evaluate(@dir).size)
  end
  
  def test_functions2
    sm_not_rb = except(bigger(100)) & except(file_name('*.rb'))
    assert_equal(7, sm_not_rb.evaluate(@dir).size)
  end
end
