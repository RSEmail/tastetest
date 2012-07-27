require "optparse"

module TasteTest
    class Configer
        attr_reader :options, :cookbooks

        # Sets up config options, cookbook dirs, etc.
        def initialize(args=[])
            @DEFAULT_LINTERS = ["foodcritic"]
            @DEFAULT_UNITERS = ["chefspec"]
            @DEFAULT_CONVERGERS = ["chef-minitest-handler"]
            @DEFAULT_OUTPUT = "standard"

            @options = parse_opts(args)
            @cookbooks = find_cookbooks(@options["path"])
        end

        # Parses out the options initially passed in from ARGV, provides help
        # messages where necessary, provides default options for anything not
        # provided at the outset
        def parse_opts(args)
            options = {}

            opts = OptionParser.new do |opts|
                opts.banner = "Usage: tastetest [OPTIONS] PATH_TO_COOKBOOK(S)"
                opts.separator ""
                opts.separator "Where 'PATH_TO_COOKBOOK(S)' is a a single"
                opts.separator "cookbook dir, a dir containing 1+ cookbooks,"
                opts.separator "or a dir containing a cookbooks dir"
                opts.separator ""
                opts.separator "Available options:"

                opts.on_tail "-h", "--help", "Display this help message" do
                    puts opts
                    exit
                end

                opts.on "-l", "--linters [L1,L2]", "Run lint tests" do |l|
                    options["linters"] = l ? l.split(',') : @DEFAULT_LINTERS
                end

                opts.on "-u", "--uniters [U1,U2]", "Run unit tests" do |u|
                    options["uniters"] = u ? u.split(',') : @DEFAULT_UNITERS
                end

                opts.on "-c", "--convergers [C1,C2]",
                        "Run convergence tests" do |c|
                    options["convergers"] = c ? c.split(',') : @DEFAULT_CONVERGERS
                end

                opts.on "-a", "--run-all",
                        "Run all types of tests (default behavior)" do
                    options["linters"] ||= @DEFAULT_LINTERS
                    options["uniters"] ||= @DEFAULT_UNITERS
                    options["convergers"] ||= @DEFAULT_CONVERGERS
                end

                opts.on "-o", "--output (standard|xml)", "Display output " +
                        "as the tests send it (default) or prettify it as "+
                        "XML" do |o|
                    options["output"] = o ? o : @DEFAULT_OUTPUT
                end

            end
            opts.parse!(args)

            if ARGV.empty?
                options["path"] = Dir.pwd
            else
                options["path"] = ARGV[-1]
            end

            if !options["linters"] and !options["uniters"] and
                    !options["convergers"]
                options["linters"] = @DEFAULT_LINTERS
                options["uniters"] = @DEFAULT_UNITERS
                options["convergers"] = @DEFAULT_CONVERGERS
            end
            options["output"] ||= @DEFAULT_OUTPUT
            return options
        end

        # Examine the given cookbook path and determine whether it's a cookbook
        # in itself or a directory containing multiple cookbooks
        def find_cookbooks(path)
            if !Dir.exists?(path)
                raise ArgumentError, "Directory #{path} doesn't exist!"
            end

            # #{path} is itself a cookbook
            if Dir.entries(path).include?("metadata.rb")
                return [path]
            end
            
            # #{path} is a cookbooks dir or contains a cookbooks dir
            if path.chomp("/").end_with?("cookbooks")
                cookbooks_dir = path
            elsif Dir.entries(path).include?("cookbooks") and
                    File.directory?("#{path}/cookbooks")
                cookbooks_dir = "#{path}/cookbooks"
            end

            if !cookbooks_dir
                raise ArgumentError, "Couldn't find a cookbooks dir in #{path}"
            end

            cookbooks = []
            Dir.entries(cookbooks_dir).each do |sub_d|
                sub_path = "#{cookbooks_dir}/#{sub_d}"
                if File.directory?(sub_path) and 
                        Dir.entries(sub_path).include?("metadata.rb")
                    cookbooks << sub_path
                end
            end
            if cookbooks == []
                raise ArgumentError, "Couldn't find any cookbooks in #{path}"
            end

            return cookbooks
        end

    end
end

# vim:et:fdm=marker:sts=4:sw=4:ts=4:
