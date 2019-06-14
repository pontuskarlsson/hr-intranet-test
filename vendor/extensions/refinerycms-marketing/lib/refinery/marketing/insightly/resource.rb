module Refinery
  module Marketing
    module Insightly
      class Resource

        def initialize(record)
          @record = record
        end

        def [](attr)
          @record[attr]
        end

        def addresses
          @record['ADDRESSES'] && @record['ADDRESSES'].map { |r| Resource.new r } || []
        end

        def contactinfos
          @record['CONTACTINFOS'] && @record['CONTACTINFOS'].map { |r| Resource.new r } || []
        end

        def customfields
          @record['CUSTOMFIELDS'] && @record['CUSTOMFIELDS'].map { |r| Resource.new r } || []
        end

        def links
          @record['LINKS'] && @record['LINKS'].map { |r| Resource.new r } || []
        end

        def tags
          @record['TAGS'].map { |t| t['TAG_NAME'] }
        end

        def contactinfo(type, label = nil)
          if (ci = contactinfos.detect { |ci| ci.type == type.to_s.upcase && (label.nil? || ci.label == label.to_s.upcase) }).present?
            ci.detail
          end
        end

        def customfield(field_name)
          if (cf = customfields.detect { |cf| cf.field_name == field_name }).present?
            cf.field_value
          end
        end

        def primary_address
          addresses.detect { |r| r.address_type == 'PRIMARY' } || addresses.first
        end

        private

        def respond_to_missing?(method_name, include_private = false)
          @record.has_key?(method_name.to_s.upcase)
        end

        def method_missing(method_name, *arguments)
          if @record.has_key?(method_name.to_s.upcase)
            @record[method_name.to_s.upcase]
          else
            super
          end
        end

      end
    end
  end
end
