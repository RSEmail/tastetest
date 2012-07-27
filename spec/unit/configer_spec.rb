require "tastetest/configer"

module TasteTest
    describe Configer do
        describe ".initialize" do
            context "When no options are passed in" do
                it "should load all the defaults" do
                    Configer.any_instance.stub(:find_cookbooks).
                        and_return(["x"])
                    c = Configer.new
                    c.options["linters"].should ==
                        c.instance_variable_get(:@DEFAULT_LINTERS)
                    c.options["uniters"].should ==
                        c.instance_variable_get(:@DEFAULT_UNITERS)
                    c.options["convergers"].should ==
                        c.instance_variable_get(:@DEFAULT_CONVERGERS)
                    c.options["output"].should ==
                        c.instance_variable_get(:@DEFAULT_OUTPUT)
                    c.cookbooks.should == ["x"]
                end
            end

            context "When '-l' is passed in" do
                it "should run the appropriate lint tests" do
                    Configer.any_instance.stub(:find_cookbooks).
                        and_return(["x"])
                    con1 = Configer.new(["-l"])
                    con2 = Configer.new(["-l", "some_linter"])
                    con3 = Configer.new(["--linters"])
                    con4 = Configer.new(["--linters", "some_linter"])
                    [con1, con2, con3, con4].each do |c|
                        c.options.should_not have_key(:uniters)
                        c.options.should_not have_key(:convergers)
                        c.cookbooks.should == ["x"]
                    end
                    [con1, con3].each do |c|
                        c.options["linters"].should ==
                            c.instance_variable_get(:@DEFAULT_LINTERS)
                    end
                    [con2, con4].each do |c|
                        c.options["linters"].should == ["some_linter"]
                    end
                end
            end

            context "When '-u' is passed in" do
                it "should run the appropriate unit tests" do
                    Configer.any_instance.stub(:find_cookbooks).
                        and_return(["x"])
                    con1 = Configer.new(["-u"])
                    con2 = Configer.new(["-u", "some_uniter"])
                    con3 = Configer.new(["--uniters"])
                    con4 = Configer.new(["--uniters", "some_uniter"])
                    [con1, con2, con3, con4].each do |c|
                        c.options.should_not have_key(:linters)
                        c.options.should_not have_key(:convergers)
                        c.cookbooks.should == ["x"]
                    end
                    [con1, con3].each do |c|
                        c.options["uniters"].should ==
                            c.instance_variable_get(:@DEFAULT_UNITERS)
                    end
                    [con2, con4].each do |c|
                        c.options["uniters"].should == ["some_uniter"]
                    end
                end
            end

            context "When '-c' is passed in" do
                it "should run the appropriate convergence tests" do
                    Configer.any_instance.stub(:find_cookbooks).
                        and_return(["x"])
                    con1 = Configer.new(["-c"])
                    con2 = Configer.new(["-c", "some_converger"])
                    con3 = Configer.new(["--convergers"])
                    con4 = Configer.new(["--convergers", "some_converger"])
                    [con1, con2, con3, con4].each do |c|
                        c.options.should_not have_key(:linters)
                        c.options.should_not have_key(:uniters)
                        c.cookbooks.should == ["x"]
                    end
                    [con1, con3].each do |c|
                        c.options["convergers"].should ==
                            c.instance_variable_get(:@DEFAULT_CONVERGERS)
                    end
                    [con2, con4].each do |c|
                        c.options["convergers"].should == ["some_converger"]
                    end
                end
            end

            context "When '-o' is passed in" do
                it "should use the appropriate output format" do
                    Configer.any_instance.stub(:find_cookbooks).
                        and_return(["x"])
                    con1 = Configer.new(["-o", "standard"])
                    con2 = Configer.new(["-o", "xml"])
                    con3 = Configer.new(["--output", "xml"])
                    [con1, con2, con3].each do |c|
                        c.options.should_not have_key(:linters)
                        c.options.should_not have_key(:uniters)
                        c.options.should_not have_key(:convergers)
                        c.cookbooks.should == ["x"]
                    end
                    con1.options["output"].should == "standard"
                    [con2, con3].each do |c|
                        c.options["output"].should == "xml"
                    end
                end
            end

        end

        describe ".find_cookbooks" do
            context "When a non-existent path is passed in" do
                it "should raise an exception"
            end

            context "When a cookbook is itself passed in" do
                it "should be found as a single cookbook"
            end

            context "When a cookbooks directory is passed in" do
                it "should find the multiple cookbooks within"
            end

            context "When a directory with a cookbooks dir is passed in" do
                it "should find the cookbooks within that sub-dir"
            end
        end
    end
end

# vim:et:fdm=marker:sts=4:sw=4:ts=4:
