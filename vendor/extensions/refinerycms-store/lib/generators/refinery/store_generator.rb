module Refinery
  class StoreGenerator < Rails::Generators::Base

    def rake_db
      rake "refinery_store:install:migrations"
    end

    def append_load_seed_data
      create_file 'db/seeds.rb' unless File.exists?(File.join(destination_root, 'db', 'seeds.rb'))
      append_file 'db/seeds.rb', :verbose => true do
        <<-EOH

# Added by Refinery CMS Store extension
Refinery::Store::Engine.load_seed
        EOH
      end
    end

    def create_redis_initializer
      create_file 'config/initializers/refinery/redis.rb' unless File.exists?(File.join(destination_root, 'config', 'initializers', 'refinery', 'redis.rb'))
      append_file 'config/initializers/refinery/redis.rb', :verbose => true do
        <<-EOH
require 'redis'

# Added by Refinery CMS Store extension
$redis = Redis.new(:driver => :hiredis)
        EOH
      end
    end
  end
end
