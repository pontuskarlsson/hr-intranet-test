require 'active_support/concern'

module Refinery
  module Addons
    module DataTables
      module ApplicationController
        extend ActiveSupport::Concern

        included do

        end

        module ClassMethods

        end
      end

      module ActiveRecord
        extend ActiveSupport::Concern

        included do

        end

        def dt_data
          (dt_columns + Array(dt_options[:methods])).each_with_object({}) { |col, acc| acc[col] = send(col) }
        end

        module ClassMethods

          def responds_to_data_tables(columns, options = {})
            class_attribute :dt_columns, :dt_options
            self.dt_columns = columns
            self.dt_options = options

            class_eval <<-RUBY_EVAL
              def self.dt_response(params)
                scope = where(nil)

                search = params[:search] && params[:search][:value]
                filtered = search.present? ? with_query(search.split(' ').map { |t| "^\#{t}" }.join(' ')) : where(nil)
                 
                begin
                  filtered = params[:columns].values.reduce(filtered) do |acc, col|
                    if col[:search][:value].present? && (ar_col = columns_hash[col[:data]]).present?
                      if ar_col.type == :string
                        acc = acc.where("\#{ar_col.name} LIKE ?", "%\#{col[:search][:value]}%")
                      end
                    end
                    acc
                  end
                rescue StandardError => e

                end

                total = scope.count
                total_filtered = filtered.count

                filtered = Hash(params[:order]).values.inject(filtered) { |s, order|
                  begin
                    s.order(params[:columns][order['column']]['data'] => order['dir'])
                  rescue StandardError => e
                    s
                  end
                }

                data = filtered

                if params[:start].present? && params[:length].present?
                  data = data.offset(params[:start]).limit(params[:length])
                end

                {
                    "draw" => params[:draw].to_i,
                    "recordsTotal" => scope.count,
                    "recordsFiltered": filtered.count,
                    "data" => data.map(&:dt_data)
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
