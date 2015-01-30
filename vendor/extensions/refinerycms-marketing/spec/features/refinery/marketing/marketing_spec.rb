# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Marketing" do
    describe "marketing" do

      describe "dashboard" do

        it "succeeds" do
          visit refinery.marketing_root_path
          page.should have_content("Marketing")
        end

      end

    end
  end
end
