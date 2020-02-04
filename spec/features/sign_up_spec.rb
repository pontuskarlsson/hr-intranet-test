# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Authentication" do
    describe "Devise" do
      describe "users" do

        describe "create" do
          before do
            visit refinery.new_signup_path
          end

          context "valid data" do
            let(:action) do
              within '#panelSignUp' do
                fill_in "Company Name", :with => "A new Company name"
                fill_in "First Name", :with => "John"
                fill_in "Last Name", :with => "Doe"
                fill_in "Email Address", :with => "john@doe.com"
                fill_in "Password", :with => "12345678"
                fill_in "Confirm Password", :with => "12345678"
                click_button "Sign Up"
              end
            end

            it "creates a new user" do
              expect{ action }.to change{Refinery::Authentication::Devise::User.count}.by 1

#              expect(page).not_to have_content("There were problems with the following fields")

              user = Refinery::Authentication::Devise::User.last
              expect(user.first_name).to eq 'John'
              expect(user.last_name).to eq 'Doe'
              expect(user.full_name).to eq 'John Doe'
            end

            it "creates a new unverified company" do
              expect{ action }.to change{ Refinery::Business::Company.count}.by 1

              company = Refinery::Business::Company.last
              expect(company).not_to be_is_verified
              expect(company.name).to eq 'A new Company name'
              expect(company.code).to be_blank
            end
          end
        end
      end
    end
  end
end
