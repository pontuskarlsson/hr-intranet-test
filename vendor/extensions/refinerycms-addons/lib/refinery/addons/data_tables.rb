require 'active_support/concern'

module Refinery
  module Addons
    module DataTables
      module ApplicationController
        extend ActiveSupport::Concern

        included do

        end

        module ClassMethods

          def responds_to_data_tables(*fields)
            options = fields.extract_options!

          end

        end
      end

      module ActiveRecord
        extend ActiveSupport::Concern

        included do

        end

        module ClassMethods

          def responds_to_data_tables(columns, options = {})
            class_attribute :dt_columns
            self.dt_columns = columns

            class_eval <<-RUBY_EVAL
              def self.dt_response(params)
                scope = where(nil)

                search = params[:search] && params[:search][:value]
                filtered = search.present? ? with_query(search.split(' ').map { |t| "^\#{t}" }.join(' ')) : where(nil)

                total = scope.count
                total_filtered = filtered.count

                filtered = Hash(params[:order]).values.inject(filtered) { |s, order|
                  begin
                    s.order(params[:columns][order['column']]['data'] => order['dir'])
                  rescue StandardError => e
                    s
                  end
                }

                data = filtered.select(dt_columns)

                if params[:start].present? && params[:length].present?
                  data = data.offset(params[:start]).limit(params[:length])
                end

                {
                    "draw" => params[:draw].to_i,
                    "recordsTotal" => scope.count,
                    "recordsFiltered": filtered.count,
                    "data" => data
                }
              end
            RUBY_EVAL

          end

        end
      end
    end
  end
end

if Object.const_defined?('ActiveRecord')
  ActiveRecord::Base.send(:include, Refinery::Addons::DataTables::ActiveRecord)
end
