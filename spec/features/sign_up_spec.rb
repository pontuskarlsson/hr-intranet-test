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

            it "does not show any error messages" do
              action

              expect(page).not_to have_content("There were problems with the following fields")
            end

            it "creates a new user with business external role" do
              expect{ action }.to change{Refinery::Authentication::Devise::User.count}.by 1

              user = Refinery::Authentication::Devise::User.last
              expect(user.first_name).to eq 'John'
              expect(user.last_name).to eq 'Doe'
              expect(user.full_name).to eq 'John Doe'

              expect(user.roles.pluck(:title)).to include Refinery::Business::ROLE_EXTERNAL
            end

            it "creates a new unverified company with user as owner" do
              expect{ action }.to change{ Refinery::Business::Company.count}.by 1

              company = Refinery::Business::Company.last
              expect(company).not_to be_is_verified
              expect(company.name).to eq 'A new Company name'
              expect(company.code).to be_blank

              expect(company.company_users.count).to eq 1
              expect(company.company_users.first.role).to eq "Owner"
            end
          end
        end
      end
    end
  end
end
