# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Store" do
    describe "store" do

      describe "products list" do
        let(:retailer) { FactoryGirl.create(:retailer) }
        before do
          FactoryGirl.create(:product, :product_number => "UniqueTitleOne", retailer: retailer)
          FactoryGirl.create(:product, :product_number => "UniqueTitleTwo")
          FactoryGirl.create(:product, :product_number => "UniqueTitleThree", expired_at: Date.yesterday, featured_at: Date.yesterday, retailer: retailer)
          FactoryGirl.create(:product, :product_number => "UniqueTitleFour", featured_at: Date.yesterday, retailer: retailer)
        end

        it "only shows product that are not expired" do
          visit refinery.store_root_path
          page.should have_content("UniqueTitleOne")
          page.should have_content("UniqueTitleTwo")
          page.should_not have_content("UniqueTitleThree")
          page.should have_content("UniqueTitleFour")
        end

        it "only shows non-expired, featured products when scope is featured" do
          visit refinery.store_root_path(scope: 'featured')
          page.should_not have_content("UniqueTitleOne")
          page.should_not have_content("UniqueTitleTwo")
          page.should_not have_content("UniqueTitleThree")
          page.should have_content("UniqueTitleFour")
        end

        it "only shows non-expired products from a specific retailer" do
          visit refinery.store_root_path(retailer_id: retailer.id)
          page.should have_content("UniqueTitleOne")
          page.should_not have_content("UniqueTitleTwo")
          page.should_not have_content("UniqueTitleThree")
          page.should have_content("UniqueTitleFour")
        end

        describe "Add to Cart" do
          it "does not show 'Add to Cart' or 'Remove from Cart' links when no user is signed in" do
            visit refinery.store_root_path
            page.should_not have_content('Add to Cart')
            page.should_not have_content('Remove from Cart')
          end

          describe 'As logged in user' do
            refinery_login_with :refinery_user

            it "does show 'Add to Cart' links when user is signed in" do
              visit refinery.store_root_path
              page.should have_content('Add to Cart')
            end
          end
        end
      end

    end
  end
end
