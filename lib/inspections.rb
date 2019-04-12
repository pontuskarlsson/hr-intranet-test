Dir[File.join(Rails.root, 'lib/inspections/**/*.rb')].each { |f| require f }

module Inspections

end
