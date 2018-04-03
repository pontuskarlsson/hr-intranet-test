require 'api_client'

module Refinery
  module Marketing

    class InsightlySynchroniser

      ENDPOINT = 'https://api.insight.ly/v2.2/'

      HEADERS = {
          'Authorization' => "Basic #{Base64.encode64(ENV['INSIGHTLY_TOKEN'])}",
          'Accept' => 'application/json'
      }.freeze

      CONTACT_ATTR = %w(first_name last_name image_url)

      CUSTOM_CONTACT_ATTR = {
          facebook: 'Facebook',
          linked_in: 'LinkedIn',
          skype: 'Skype',
          twitter: 'Twitter'
      }.freeze

      CUSTOM_ORGANISATION_ATTR = {
          email: 'Email, Organisation',
          facebook: 'Facebook',
          linked_in: 'LinkedIn',
          skype: 'Skype',
          twitter: 'Twitter',
          courier_company: 'Courier Company',
          courier_account_no: 'Courier Company A/C No.'
      }.freeze


      #MAPPED_ATTR = %w(name first_name last_name skype title private contact_id is_organisation mobile fax website phone description linked_in facebook industry twitter email organisation_name tags_joined_by_comma is_sales_account customer_status prospect_status custom_fields)
      #ADDRESS_KEYS = %w(line1 city postal_code state country)

      attr_accessor :error

      def initialize(token = ENV['INSIGHTLY_TOKEN'])
        @headers = {
            'Authorization' => "Basic #{Base64.encode64(token)}",
            'Accept' => 'application/json'
        }
      end

      def synchronise
        begin
          Refinery::Marketing::Contact.transaction do
            # Loops through all contacts from Base and updates the ones already
            # present in the database and creates the ones that are not


            ## Custom Fields ###
            custom_fields = list_of('CustomFields').inject({}) { |acc, cf|
              acc[cf.field_for] ||= {}
              acc[cf.field_for][cf.field_name] = cf
              acc
            }


            ### Organisations ###
            @all_crm_ids = []
            list_of('Organisations').each do |crm_contact|
              @all_crm_ids << crm_contact.organisation_id

              if (contact = Refinery::Marketing::Contact.where(is_organisation: true).find_by_insightly_id(crm_contact.organisation_id)).present?
                sync_organisation contact, crm_contact, custom_fields['ORGANISATION']
              else
                contact = Refinery::Marketing::Contact.new
                sync_organisation contact, crm_contact, custom_fields['ORGANISATION']
              end

              contact.save!
            end

            # Flags all the contacts that were not found in the latest sync from, as removed.
            Refinery::Marketing::Contact.where(is_organisation: true).where('insightly_id IS NOT NULL AND insightly_id NOT IN (?)', @all_crm_ids + [-1]).update_all(removed_from_base: true)


            ### Contacts ###
            @all_crm_ids = []
            list_of('Contacts').each do |crm_contact|
              @all_crm_ids << crm_contact.contact_id

              if (contact = Refinery::Marketing::Contact.where(is_organisation: false).find_by_insightly_id(crm_contact.contact_id)).present?
                sync_contact contact, crm_contact, custom_fields['CONTACT']
              else
                contact = Refinery::Marketing::Contact.new
                sync_contact contact, crm_contact, custom_fields['CONTACT']
              end

              contact.save!
            end

            # Flags all the contacts that were not found in the latest sync from, as removed.
            Refinery::Marketing::Contact.where(is_organisation: false).where('insightly_id IS NOT NULL AND insightly_id NOT IN (?)', @all_crm_ids + [-1]).update_all(removed_from_base: true)

          end
          true
        rescue StandardError => e
          self.error = e
          false
        end
      end

      def list_of(resource)
        Refinery::Marketing::ResourceList.new(client, resource)
      end

      private

      def client
        @client ||= ApiClient::Base.headers(@headers).endpoint(ENDPOINT)
      end

      def custom_field_id(field_for, field_name)
        @custom_fields ||= client.get('CustomFields')

        if (field = @custom_fields.detect { |f| f['FIELD_FOR'] == field_for.upcase && f['FIELD_NAME'] == field_name.upcase }).present?
          field['CUSTOM_FIELD_ID']
        end
      end

      def sync_contact(contact, crm_contact, custom_fields = {})
        contact.insightly_id = crm_contact.contact_id
        contact.is_organisation = false
        contact.removed_from_base = false

        # Standard attributes
        contact.first_name = crm_contact.first_name
        contact.last_name = crm_contact.last_name
        contact.name = [crm_contact.first_name, crm_contact.last_name].reject(&:blank?).join(' ')
        contact.image_url = crm_contact.image_url
        contact.description = crm_contact.background

        # Contact Info
        contact.phone = crm_contact.contactinfo(:phone, :work)
        contact.mobile = crm_contact.contactinfo(:phone, :mobile)
        contact.fax = crm_contact.contactinfo(:phone, :fax)
        contact.email = crm_contact.contactinfo(:email)
        contact.website = crm_contact.contactinfo(:website)

        # Link Organisation
        if crm_contact.default_linked_organisation && (organisation = Refinery::Marketing::Contact.where(is_organisation: true).find_by_insightly_id(crm_contact.default_linked_organisation)).present?
          contact.organisation = organisation
          contact.organisation_name = organisation.name
          contact.title = crm_contact.links.detect { |r| r.organisation_id == crm_contact.default_linked_organisation }.try(:role)
        else
          contact.organisation = nil
          contact.organisation_name = nil
          contact.title = nil
        end

        # Sync Address
        sync_address contact, crm_contact

        # Sync Custom Fields
        sync_custom_fields contact, crm_contact, custom_fields, CUSTOM_CONTACT_ATTR

        # Tags
        contact.tags_joined_by_comma = crm_contact.tags.join(',')
      end

      def sync_organisation(contact, crm_contact, custom_fields = {})
        contact.insightly_id = crm_contact.organisation_id
        contact.is_organisation = true
        contact.removed_from_base = false

        # Standard attributes
        contact.name = crm_contact.organisation_name
        contact.organisation_name = crm_contact.organisation_name
        contact.image_url = crm_contact.image_url
        contact.description = crm_contact.background

        # Contact Info
        contact.phone = crm_contact.contactinfo(:phone, :work)
        contact.fax = crm_contact.contactinfo(:phone, :fax)
        contact.website = crm_contact.contactinfo(:website)

        # Sync Address
        sync_address contact, crm_contact

        # Sync Custom Fields
        sync_custom_fields contact, crm_contact, custom_fields, CUSTOM_ORGANISATION_ATTR

        contact.tags_joined_by_comma = crm_contact.tags.join(',')
      end

      def sync_address(contact, crm_contact)
        if crm_contact.primary_address
          contact.address = crm_contact.primary_address.street
          contact.city = crm_contact.primary_address.city
          contact.zip = crm_contact.primary_address.postcode
          contact.state = crm_contact.primary_address.state
          contact.country = crm_contact.primary_address.country
        end
      end

      def sync_custom_fields(contact, crm_contact, custom_fields, attribute_map)
        attribute_map.each_pair do |attr, field|
          if custom_fields[field].present?
            contact.send("#{attr}=", crm_contact.customfield(custom_fields[field].custom_field_id))
          end
        end
      end

    end

    class ResourceList
      include Enumerable

      def initialize(client, resource, batch_size = 100)
        @client, @resource, @batch_size = client, resource, batch_size
        @batch_size = 100 if batch_size < 1
      end

      def each(&block)
        if @records.nil?
          @records = []

          # Request once in raw format to get the total number of records through the header
          res = @client.params(count_total: true, skip: 0, top: 1).get(@resource, raw: true)

          # Iterate the total number of records and load them in batches from Insightly
          res.headers['x-total-count'].to_i.times do |i|
            if i % @batch_size == 0
              @records += @client.params(skip: i, top: @batch_size).get(@resource).map { |r| Refinery::Marketing::Resource.new r }
            end
            block.call @records[i]
          end

        else
          @records.each(&block)
        end

      rescue ApiClient::Errors::ApiClientError => e
        puts e.inspect
      end

    end

    class Resource

      def initialize(record)
        @record = record
      end

      def [](attr)
        @record[attr]
      end

      def addresses
        @record['ADDRESSES'] && @record['ADDRESSES'].map { |r| Refinery::Marketing::Resource.new r } || []
      end

      def contactinfos
        @record['CONTACTINFOS'] && @record['CONTACTINFOS'].map { |r| Refinery::Marketing::Resource.new r } || []
      end

      def customfields
        @record['CUSTOMFIELDS'] && @record['CUSTOMFIELDS'].map { |r| Refinery::Marketing::Resource.new r } || []
      end

      def links
        @record['LINKS'] && @record['LINKS'].map { |r| Refinery::Marketing::Resource.new r } || []
      end

      def tags
        @record['TAGS'].map { |t| t['TAG_NAME'] }
      end

      def contactinfo(type, label = nil)
        if (ci = contactinfos.detect { |ci| ci.type == type.to_s.upcase && (label.nil? || ci.label == label.to_s.upcase) }).present?
          ci.detail
        end
      end

      def customfield(custom_field_id)
        if (cf = customfields.detect { |cf| cf.custom_field_id == custom_field_id }).present?
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
