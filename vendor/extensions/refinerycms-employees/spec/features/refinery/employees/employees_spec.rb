# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Employees" do
    describe "employees" do
      refinery_login_with :refinery_user

      describe "employee directory" do
        before do
          FactoryGirl.create(:employee, :full_name => "Jack Bower")
          FactoryGirl.create(:employee, :full_name => "Bruce Wayne")
        end

        it "shows two items" do
          visit refinery.employees_employees_path
          page.should have_content("Jack Bower")
          page.should have_content("Bruce Wayne")
        end
      end

    end
  end
end
