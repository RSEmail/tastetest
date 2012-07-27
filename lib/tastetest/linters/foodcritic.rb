require "foodcritic"
require "builder"

module TasteTest
    class FoodCritic < FoodCritic::Linter
        attr_reader :name, :results, :path

        def initialize(path)
            super()
            @name = "FoodCritic"
            @path = path
            @tags = []
            @includes = []
            @excludes = []
            @fails = ["all"]
            @results = nil
            @start_time = nil
            @finish_time = nil
        end

        def run
            @start_time = Time.new.utc
            res = check(@path, tags: @tags,
                include_rules: @includes, fail_tags: @fails,
                exclude_paths: @excludes)
            res = res.to_s
            res = res.strip
            @results = res
            @finish_time = Time.new.utc
            return success?
        end

        def success?
            if @results and @results != ""
                return false
            else
                return true
            end
        end

        def to_s(output="standard")
            case output
                when "standard"
                    return @results
                when "xml"
                    xml = Builder::XmlMarkup.new(:indent=>4)
                    testsuite_attrs = {
                        :errors => 0,
                        :failures => @results.lines.count,
                        :name => "TasteTest::Linters::FoodCritic",
                        :tests => @rules.to_s.lines.count,
                        :time => @finish_time - @start_time
                    }
                    xml.testsuite(testsuite_attrs) do |testsuite|
                        @rules.each do |r|
                            testcase_attrs = {
                                :classname => "TasteTest::Linters::FoodCritic",
                                :name => r.to_s
                            }
                            testsuite.testcase(testcase_attrs) do |testcase|
                                code = r.to_s.split(':')[0]
                                test_failed = false
                                @results.each_line do |line|
                                    failed_code = line.split(':')[0]
                                    if failed_code == code
                                        testcase.failure(line.strip)
                                    end
                                end
                            end
                        end
                    end
                    return xml.target!
            end
        end
    end
end

# vim:et:fdm=marker:sts=4:sw=4:ts=4:
