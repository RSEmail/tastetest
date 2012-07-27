require "optparse"

require "tastetest/version"
require "tastetest/configer"
require "tastetest/linters"
require "tastetest/uniters"
require "tastetest/convergers"

module TasteTest
    def run(args)
        confs = Configer.new(args)

        if confs.options["linters"] and confs.options["linters"] != []
            linters = Linters.new(confs.cookbooks, confs.options["linters"])
            linters.run
        else
            linters = nil
        end

        if confs.options["uniters"] and confs.options["uniters"] != []
            #puts "Unit tests not yet implemented"
        else
            uniters = nil
        end

        if confs.options["convergers"] and confs.options["convergers"] != []
            #puts "Convergence tests not yet implemented"
        else
            convergers = nil
        end

        if linters then puts linters.to_s(confs.options["output"]) end
        if uniters then puts uniters.to_s(confs.options["output"]) end
        if convergers then puts convergers.to_s(confs.options["output"]) end

    end
end

# vim:et:fdm=marker:sts=4:sw=4:ts=4:
