require "tastetest/linters/foodcritic"

require "builder"

module TasteTest
    class Linters
        def initialize(cookbooks, linters)
            @cookbooks = cookbooks
            @linters = []
            @results = nil

            @cookbooks.each do |c|
                linters.each do |l|
                    case l
                        when "foodcritic"
                            @linters << FoodCritic.new(c)
                        else
                            raise ArgumentError, "Invalid linter: #{l}"
                    end
                end
            end
        end

        def run
            @linters.each do |l|
                l.run
            end
        end

        def success?
            @linters.each do |l|
                if !l.success?
                    return false
                end
            end
            return true
        end

        def to_s(output="standard")
            case output
                when "standard"
                    s = ""
                    @cookbooks.each do |c|
                        @linters.each do |l|
                            s += "Results from #{l.name} on #{l.path}...\n" +
                                "=======================================\n" +
                                "#{l}\n" +
                                "Success? #{l.success? ? "Yes!" : "NO!"}\n" +
                                "=======================================\n"
                        end
                    end
                    return s
                when "xml"
                    s = ""
                    @cookbooks.each do |c|
                        @linters.each do |l|
                            s += l.to_s("xml")
                        end
                    end
                    return s
            end
        end
    end
end

# vim:et:fdm=marker:sts=4:sw=4:ts=4:
