require 'test/unit'
require 'tmpdir'
require 'find-duplicates'

include FindDuplicates

class FindDuplicatesTest < Test::Unit::TestCase
  def test_main
    Dir.mktmpdir do |p|
      Dir.chdir(p) do
        path = File.dirname(__FILE__) + '/test.sh'
        `#{ path }`
        assert_equal 9, Dir.glob(p + '/**/*').find_all { |file| File.file?(file) }.size
        assert_equal 0, $?
        find_duplicates({ :bar => lambda { |s| DummyBar.new },
                          :remove_policy => PolicyLeaveLongest.new,
                          :dry => false }, [ p ])
        assert_equal 0, $?
        assert_equal 1, Dir.glob(p + '/**/*').find_all { |file| File.file?(file) }.size
      end
    end
  end
end

