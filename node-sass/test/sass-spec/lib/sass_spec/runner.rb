require 'minitest'
require 'pathname'
require_relative 'test'
require_relative 'test_case'


class SassSpec::Runner

  def initialize(options = {})
    @options = options
  end

  def run
    unless @options[:silent]
      puts "Recursively searching under directory '#{@options[:spec_directory]}' for test files to test '#{@options[:sass_executable]}' with."
    end

    test_cases = _get_cases
    SassSpec::Test.create_tests(test_cases, @options)

    minioptions = []
    if @options[:verbose]
      minioptions.push '--verbose'
    end

    exit Minitest.run(minioptions)
  end

  def _get_cases
    cases = []
    glob = File.join(@options[:spec_directory], "**", "#{@options[:input_file]}")
    Dir.glob(glob) do |filename|
      expected = Pathname.new(filename).dirname.join(@options[:expected_file])
      input = Pathname.new(filename)
      cases.push SassSpec::TestCase.new(input.realpath(), expected.realpath(), @options)
    end
    cases
  end

end
