require 'active_support/concern'

module Refinery
  module Addons
    module DataTables
      module ActionController
        extend ActiveSupport::Concern

        included do

        end

        def server_side?
          params.has_key? :draw
        end

        module ClassMethods

        end
      end

      module ActiveRecord
        extend ActiveSupport::Concern

        included do
          class_attribute :dt_columns, :dt_joined, :dt_methods
        end

        def dt_record_data
          data = dt_columns.each_with_object({}) { |(as, col), acc|
            if col[:assoc]
              acc[as] = send(col[:assoc]).try(col[:column])
            else
              acc[as] = send(col[:column])
            end
          }
          Array(dt_methods).each_with_object(data) { |method, acc| acc[method] = send(method) }
        end

        module ClassMethods

          def responds_to_data_tables(*columns)
            joined = columns.extract_options!
            methods = joined.delete(:methods)

            column_config = columns.each_with_object({}) { |c, acc|
              acc[c.to_s] = { column: c.to_s }
            }

            column_config = joined.each_pair.each_with_object(column_config) { |(k,v), acc|
              assoc = reflect_on_association k

              raise 'association not found' if assoc.nil?

              v.each { |c| acc["#{k}_#{c}"] = { column: c.to_s, assoc: k.to_s, class_name: assoc.klass.name } }
            }

            self.dt_columns, self.dt_methods = column_config, methods
          end

          def dt_response(params)
            raise '+dt_response+ not configured' unless dt_columns.present?

            scope = where(nil)

            search = params[:search] && params[:search][:value]
            filtered = search.present? ? with_query(search.split(' ').map { |t| "^#{t}" }.join(' ')) : where(nil)

            column_filter = method(:dt_filter_column)
            filtered = params[:columns].values.inject(filtered, &column_filter)
            # filtered = params[:columns].values.inject(filtered) do |acc, col|
            #   if col[:search][:value].present? && (ar_col = columns_hash[col[:data]]).present?
            #     if ar_col.type == :string
            #       acc = acc.where("#{ar_col.name} LIKE ?", "%#{col[:search][:value]}%")
            #     end
            #   end
            #   acc
            # end

            filtered = Hash(params.permit(:order)).values.inject(filtered) { |s, order|
              begin
                s.order(params[:columns][order['column']]['data'] => order['dir'])
              rescue StandardError => e
                s
              end
            }

            data = filtered

            if params[:start].present? && params[:length].present?
              length = params[:length].to_i
              start = params[:start].to_i

              if length != -1
                data = data.offset([0, start].max).limit([0, length].max)
              end
            end

            {
                "draw" => params[:draw].to_i,
                "recordsTotal" => scope.count,
                "recordsFiltered": filtered.count,
                "data" => data.map(&:dt_record_data)
            }
          end

          def dt_filter_column(acc, col)
            val = col[:search][:value]

            if val.present? && (dt_col = dt_columns[col[:data]]).present?
              klass = dt_col[:class_name] ? dt_col[:class_name].constantize : self

              if (ar_col = klass.columns_hash[dt_col[:column]]).present?
                if dt_col[:assoc]
                  acc = acc.includes(dt_col[:assoc]).where.not(klass.table_name => { ar_col.name => nil })
                end

                if ar_col.type == :string
                  acc = acc.where("#{klass.table_name}.#{ar_col.name} LIKE ?", "%#{val}%")

                elsif ar_col.type == :date
                  if val[':']
                    from, to = val.split(':').map(&:to_date)
                    acc = acc.where(klass.table_name => { ar_col.name => from..to })
                  else
                    acc = acc.where(klass.table_name => { ar_col.name => val })
                  end
                end
              end
            end
            acc
          rescue StandardError
            acc
          end

        end
      end
    end
  end
end

if Object.const_defined?('ActiveRecord')
  ActiveRecord::Base.send(:include, Refinery::Addons::DataTables::ActiveRecord)
end

if Object.const_defined?('ActionController')
  ActionController::Base.send(:include, Refinery::Addons::DataTables::ActionController)
end
