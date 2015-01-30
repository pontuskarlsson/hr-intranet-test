require 'basecrm'

module Refinery
  module Marketing

    class BaseSynchroniser
      BASE_TOKEN = ENV['BASE_TOKEN']

      MAPPED_ATTR = %w(name first_name last_name address city skype zip country title private contact_id is_organisation mobile fax website phone description linked_in facebook industry twitter email organisation_name tags_joined_by_comma is_sales_account customer_status prospect_status custom_fields)

      attr_accessor :error

      def initialize
        @all_base_ids = []
        # The API does not support querring at the moment
        #@last_modified_date = Refinery::Contacts::Contact.maximum(:base_modified_at)
      end

      def synchronise
        begin
          Refinery::Marketing::Contact.transaction do
            # Loops through all contacts from Base and updates the ones already
            # present in the database and creates the ones that are not
            each_base_contact do |base_contact|
              if (contact = Refinery::Marketing::Contact.find_by_base_id(base_contact.id)).present?
                sync_contact contact, base_contact
              else
                contact = Refinery::Marketing::Contact.new
                contact.base_id = base_contact.id
                sync_contact contact, base_contact
              end
            end

            # Flags all the contacts that were not found in the latest sync from, as removed.
            Refinery::Marketing::Contact.where('base_id IS NOT NULL AND base_id NOT IN (?)', @all_base_ids + [-1]).update_all(removed_from_base: true)

          end
          true
        rescue StandardError => e
          self.error = e
          false
        end
      end

      private
      def session
        @session ||= BaseCrm::Session.new(BASE_TOKEN)
      end

      # Loads all contacts from base in batches and yields them one at a time. This
      # way we avoid to load all contacts into memory at the same time. And we only
      # store the retrieved ids so that we can look for any existing contacts that
      # was not found in base, later on.
      def each_base_contact(&block)
        @all_base_ids = []

        page = 1 # Contacts uses 1 as first page number
        while (contacts = session.contacts.params(page: page).all).any?
          contacts.each do |contact|
            @all_base_ids << contact.id
            block.call contact
          end
          page += 1
        end

        # Everything okay
        true
      end

      # Copies all information from the base contact into the refinery contact.
      def sync_contact(contact, base_contact)
        MAPPED_ATTR.each do |attr|
          # Use [attr] method instead of send(attr) because zip attribute is calling Enumerable zip method
          contact.send("#{attr}=", base_contact[attr])
        end
        if (o = base_contact.organisation).present? && (c = o['contact']).present? && (c_id = c['id']).present?
          contact.organisation_id = c_id
        end

        # Set the update date in case we want to only sync selectively later on
        contact.base_modified_at = base_contact.updated_at

        # Make sure that the contact is not flagged as removed from base
        contact.removed_from_base = false
        contact.save!
      end

    end

  end
end
