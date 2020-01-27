class ApplicationRecord < ActiveRecord::Base
  include Portal::Wizard::ActiveRecord
  self.abstract_class = true
end
