# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Employees" do
    describe "dashboard" do

      describe "index view" do
        it "successfully shows view" do
          visit refinery.employees_root_path
          page.should have_content("Employees Dashboard")
        end
      end

    end
  end
end
